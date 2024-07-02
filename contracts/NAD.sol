// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import Strings lib
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BasicMotif.sol";
import "./NDDecoder.sol";


import "./NDRenderer.sol";
import "./NDUtils.sol";

import "@openzeppelin/contracts/utils/Base64.sol";

import "./NDMotifDataManager.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ERC721Reservations.sol";

//import "forge-std/console.sol";
 


contract NAD is ERC721Reservations {
     using Strings for uint256;
     using Strings for int256;

     struct ConstructedNFT {
        string svg;
        string attributes;
        string name;
     }

     struct SunMoon {
        uint sunrise;
        uint sunset;
        int altitude;
        int azimuth;
        int moonAzimuth;
        int moonAltitude;
        int parallacticAngle;
        int fraction;
        int angle;
     }

     

    

    NDMotifDataManager public motifDataManager;
  


     
    constructor(address _motifDataManager) ERC721Reservations("Night And Day", "N&D") {

        _setDefaultRoyalty(payable(0x29C8950157979A0bC26772F1cC74006D6cF97473), 2500);

       motifDataManager =  NDMotifDataManager(_motifDataManager);



    }

   function tokenURI(uint256 tokenId) public view override returns (string memory) {

        uint timestamp = block.timestamp;
        ConstructedNFT memory nft = generateNFT(tokenId, timestamp);

        string memory base64SVG = string.concat( '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(nft.svg)), '"');
        string memory base64JSON =  string.concat('data:application/json;base64,', Base64.encode(bytes(string.concat('{"description" : "juhu", "name":"',nft.name, '",', nft.attributes,'],', base64SVG, '}'))));
        return base64JSON;
    }

  
    function tokenUriWithTime(uint256 tokenId, uint256 timestamp) public view returns (string memory) {

        ConstructedNFT memory nft = generateNFT(tokenId, timestamp);

        string memory base64SVG = string.concat( '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(nft.svg)), '"');
        string memory base64JSON =  string.concat('data:application/json;base64,', Base64.encode(bytes(string.concat('{"description" : "juhu", "name":"',nft.name, '",', nft.attributes,'],', base64SVG, '}'))));
        return base64JSON;
    }

    function generateNFT(uint256 tokenId, uint256 timestamp) public view returns (ConstructedNFT memory) {


        Motif memory motif  = motifDataManager.getMotifByTokenId(tokenId);

        ConstructedNFT memory constructedNFT;

        constructedNFT.svg = motif.svg;

        SunMoon memory sunMoon;
        SVGData memory svgData;


      
   

        {
         (sunMoon.azimuth, sunMoon.altitude) = SunCalc.getPosition(motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);
         (sunMoon.sunrise, sunMoon.sunset) = SunCalc.getSunRiseSet(timestamp * 1e18, motif.lat * 1e12, motif.lng * 1e12);
       


        

         svgData.sunSVG = NDRenderer.renderSun(uint(motif.horizon) * 1e4, sunMoon.azimuth / 1e14, sunMoon.altitude / 1e14, uint(motif.heading) * 1e4);


         ( sunMoon.moonAzimuth, sunMoon.moonAltitude, sunMoon.parallacticAngle) = SunCalc.getMoonPosition( motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);


          (sunMoon.fraction, , sunMoon.angle )  = SunCalc.getMoonIllumination(timestamp * 1e18);


          svgData.moonSVG = NDRenderer.renderMoon( tokenId,  motif.heading * 1e4, motif.horizon * 1e4, sunMoon.moonAzimuth / 1e14, sunMoon.moonAltitude / 1e14, sunMoon.parallacticAngle / 1e14, sunMoon.fraction / 1e14, sunMoon.angle / 1e14);
          ( svgData.skyColor, svgData.waterColor) = NDRenderer.getSkyColor(sunMoon.altitude / 1e16);
           constructedNFT.svg = NDUtils.replaceFirst(constructedNFT.svg, "$wc", svgData.waterColor);


         FlowerType flowerType =  FlowerType(NDUtils.randomNum(tokenId, 0, 3));
         constructedNFT.attributes = NDUtils.createStandardAttributes(motif, flowerType);


        FlowerParts memory flowerParts = motifDataManager.getFlower(flowerType);
          constructedNFT.svg = NDRenderer.renderFlower(constructedNFT.svg, sunMoon.azimuth / 1e14, sunMoon.altitude / 1e16, motif.heading * 1e4, flowerType, flowerParts, motif.motifType != MotifType.SIGHT_SEEING);
         constructedNFT.svg = NDRenderer.renderLighthouse(constructedNFT.svg, sunMoon.altitude, timestamp);
         svgData.nightSVG = NDRenderer.applyNight( sunMoon.altitude / 1e14, tokenId);
        
        }
         AssetInScene[] memory assetInScene = motifDataManager.getAssetInScene();
        
         string memory maskedAssetsSVG;
        
        (constructedNFT.svg, maskedAssetsSVG) = NDRenderer.renderMainScene(constructedNFT.svg, timestamp, tokenId, motif.scenes, assetInScene, sunMoon.sunrise, sunMoon.sunset);
         constructedNFT.svg = NDUtils.renderReplacements(constructedNFT.svg, motif.replacements);
         constructedNFT.svg = renderBallon(constructedNFT.svg ,timestamp, tokenId);
         constructedNFT.svg = renderWaterScene(constructedNFT.svg, timestamp, tokenId, motif.motifType);
        
         
        svgData.skySceneSVG = NDRenderer.renderAirplanes( timestamp, tokenId, uint(motif.horizon));

        svgData.cloudsSVG = NDRenderer.generateClouds( motif.horizon, timestamp - (timestamp  % 86400) + tokenId);

        
         
        if (motif.motifType == MotifType.BEACH) {
            constructedNFT = renderBeachTraits(constructedNFT, tokenId);
        }

        if(motif.motifType == MotifType.SKYSCRAPER) {
            constructedNFT = renderCityTraits(constructedNFT, tokenId);
        }

        if(motif.motifType == MotifType.LANDSCAPE) {
            constructedNFT = renderLandscapeTraits(constructedNFT, tokenId);
            constructedNFT.svg = NDRenderer.renderSunclock(constructedNFT.svg, sunMoon.azimuth / 1e14, sunMoon.altitude / 1e16, motif.heading * 1e4);
        }

    

        constructedNFT.svg = NDUtils.renderFinalNFT(motifDataManager.assets(),
        tokenId, constructedNFT.svg, svgData,maskedAssetsSVG);
        constructedNFT.name = motif.name;


          if(motif.motifType != MotifType.SIGHT_SEEING) {
            constructedNFT = renderNFTInside(constructedNFT, tokenId, timestamp);
        }



        return constructedNFT;
    }

  

   

        function renderBallon(string memory svg, uint timestamp, uint tokenId)  public view returns (string memory) {
            string memory assetName = "ball";
            string memory salt = tokenId.toString();

            string memory assetsSVG =  NDRenderer.renderMovingAsset(timestamp, salt, assetName, true, 0, 150, false, 50, 50, 20 * 60, 120 * 60, 70, 30 * 60);
            return NDUtils.replaceFirst(svg, "$ba", assetsSVG);
        }


        function renderWaterScene(string memory svg, uint timestamp, uint tokenId,MotifType motifType) public view returns (string memory) {
            
            
            string memory salt = tokenId.toString();
            uint scale = motifType == MotifType.LANDSCAPE ||  motifType == MotifType.SKYSCRAPER ? 70 : 100;


            string memory cruiserSVG =  NDRenderer.renderMovingAsset(timestamp, salt, "cruise", false,  0, 5, true, scale, scale, 360, 1200, 50, 360 );
            string memory fisherSVG =  NDRenderer.renderMovingAsset(timestamp, salt, "fisher", false, 0, 5, true, scale, scale,600, 1200, 50, 600 );
            string memory yachtSVG =   NDRenderer.renderMovingAsset(timestamp, salt, "yacht", true,  0, 5, true, scale, scale,180, 360, 50, 180 );

            string memory assetsSVG = string.concat(cruiserSVG, fisherSVG, yachtSVG);

            return NDUtils.replaceFirst(svg, "$ws", assetsSVG);


        }

        function renderBeachTraits(ConstructedNFT memory nft, uint tokenId) public view returns (ConstructedNFT memory) {
            
            BeachTraits memory beachTraits =  motifDataManager.getBeachTraits(tokenId);
            nft.svg = NDUtils.replaceFirst(nft.svg, "$bc", beachTraits.beachColor);
            nft.attributes = string.concat(nft.attributes, beachTraits.attributes);
            nft.svg = NDUtils.replaceFirst(nft.svg, "$sc", beachTraits.skinColor);

            nft.svg = NDUtils.replaceFirst(nft.svg, "$sh", beachTraits.shortsSVG);
            nft.svg = NDUtils.replaceFirst(nft.svg, "$to", beachTraits.towelSVG);
            return nft;
        } 

        function renderNFTInside(ConstructedNFT memory nft, uint tokenId, uint timestamp) public view returns (ConstructedNFT memory) {
            
            uint sightSeeingTokenId = NDUtils.randomNum(tokenId, 0, 18);
            ConstructedNFT memory nftInside = generateNFT(sightSeeingTokenId, timestamp);


            nft.attributes = string.concat(nft.attributes, ',{"trait_type": "NFT Inside", "value": "', nftInside.name, '"}');
            nft.svg =  NDUtils.replaceFirst(nft.svg, "$nft", nftInside.svg);
            return nft;
        }



        function renderCityTraits(ConstructedNFT memory nft, uint tokenId) public view returns (ConstructedNFT memory) {


            //RENDER SkYLINE
            CityTraits memory cityTraits = motifDataManager.getCityTraits(tokenId);


            nft.attributes = string.concat(nft.attributes, cityTraits.attributes);

            nft.svg = NDUtils.replaceFirst( nft.svg, "$tok", tokenId.toString());

            nft.svg = NDUtils.replaceFirst( nft.svg, "$skyl", cityTraits.skylineSVG);
             nft.svg = NDUtils.replaceFirst( nft.svg, "$coa", cityTraits.isCoastel ? "hidden" : "visible");
            nft.svg = NDUtils.replaceFirst( nft.svg, "$oc", cityTraits.isCoastel ? "visible" : "hidden");

         
            //RENDER CHART
            uint[] memory prices = new uint[](16);
            AggregatorV3Interface dataFeed = AggregatorV3Interface(cityTraits.priceFeed);
            (uint80 firstRoundID , int price , ,uint firstUpdatedAt , ) = dataFeed.latestRoundData();
            prices[0] = uint(price);
            prices[1] = firstUpdatedAt;
            uint decimals = dataFeed.decimals();

            string memory description = dataFeed.description();
            nft.attributes = string.concat(nft.attributes, ',{"trait_type":"Trading Chart","value":"', description, '"}');
            firstRoundID--;
            for(uint i = 2; i < 16; i+=2) {
                (,  price, ,  firstUpdatedAt , ) = dataFeed.getRoundData(firstRoundID);
                prices[i] = uint(price);
                prices[i+1] = firstUpdatedAt;
                firstRoundID--;
            }

            // find lowest and highest price
            uint lowestPrice = prices[0];
            uint highestPrice = prices[0];
            for(uint j = 0; j < prices.length; j+=2) {
                if(prices[j] < lowestPrice) {
                    lowestPrice = prices[j];
                }
                if(prices[j] > highestPrice) {
                    highestPrice = prices[j];
                }
            }

            // find the price range
            uint priceRange = highestPrice - lowestPrice;

            //time range by subtracting the first timestamp from the last
            uint timeRange = prices[1] - prices[prices.length - 1];


            uint chartWidth = 200;
            uint chartHeight = 144;
            uint chartX = 62;
            uint chartY = 777;

            // iterate prices and create line chart based on price and timestamp
            string memory chart;
           
            for(uint j = 0; j < prices.length; j+=2) {
                uint x = (prices[j+1] - prices[prices.length - 1]) * chartWidth / timeRange + chartX;
                uint y = chartHeight - (prices[j] - lowestPrice) * chartHeight / priceRange + chartY;

                chart = string.concat( chart, j == 0 ? "M" : "L", x.toString(), " ", y.toString());
            }

            string memory highPriceStr = NDUtils.formatChartNumber(highestPrice/(10**decimals));
            string memory lowPriceStr = NDUtils.formatChartNumber(lowestPrice/(10**decimals));


            string memory chartSVG = string.concat('<path d="', chart,'" fill="none" stroke="#FFDB19" stroke-width="4" />');
            string memory descriptionSVG = string.concat('<text x="220" y="', cityTraits.displayType == 0 ? '970' : '750' ,'" text-anchor="middle" fill="#9400E3" font-family="Arial-Black"  font-size="20px">',description, '</text>');
            string memory pricesStr = string.concat('<g font-family="Arial-BoldMT" fill="#9400E3" text-anchor="end" font-size="18"><text transform="translate(328 790)">', highPriceStr ,'</text><text transform="translate(328 916)">',lowPriceStr,'</text></g>');

            nft.svg =  NDUtils.replaceFirst(nft.svg, "$ch", string.concat(chartSVG, descriptionSVG, pricesStr));
            nft.svg = NDUtils.replaceFirst(nft.svg, "$di",cityTraits.displaySVG);
            return nft;
        }


        function renderLandscapeTraits(ConstructedNFT memory nft, uint tokenId) public view returns (ConstructedNFT memory) {

            string memory hidden = "hidden";
            string memory visible = "visible";

            



            LandscapeTraits memory landscapeTraits = motifDataManager.getLandScapeTraits(tokenId);

            nft.svg = NDUtils.replaceFirst( nft.svg, "$tok", tokenId.toString());
            nft.svg = NDUtils.replaceFirst( nft.svg, "$oc", landscapeTraits.hasOcean ? "visible" : "hidden");


             nft.svg = NDUtils.replaceFirst(nft.svg, "$cc", landscapeTraits.climateZoneColor);
             nft.svg = NDUtils.replaceFirst(nft.svg, "$pe",landscapeTraits.artistSVG);

            nft.svg = NDUtils.replaceFirst(nft.svg, "$be", landscapeTraits.before);
            nft.svg = NDUtils.replaceFirst(nft.svg, "$af", landscapeTraits.front);
            nft.attributes = string.concat(nft.attributes, landscapeTraits.attributes);


            return nft;
        }




}

