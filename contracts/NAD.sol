// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import Strings lib
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BasicMotif.sol";
import "./NDDecoder.sol";


import "./NDRenderer.sol";
import "./NDAlgos.sol";

import "@openzeppelin/contracts/utils/Base64.sol";

import "./NDMotifDataManager.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ERC721Reservations.sol";
 


contract NAD is ERC721Reservations {
     using Strings for uint256;
     using Strings for int256;

     struct ConstructedNFT {
        string svg;
        string attributes;
        string name;
     }

    

    NDMotifDataManager public motifDataManager;
  


     
    constructor(address _motifDataManager) ERC721Reservations("Night And Day", "N&D") {

        _setDefaultRoyalty(payable(0x29C8950157979A0bC26772F1cC74006D6cF97473), 2500);

       motifDataManager =  NDMotifDataManager(_motifDataManager);



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

        uint sunrise;
        uint sunset;
        string memory sunSVG;
        string memory skyColor;
        string memory moonSVG;
        string memory nightSVG;



        {
         (int azimuth, int altitude) = SunCalc.getPosition(motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);
         if (tokenId != 3) {
                (sunrise, sunset) = SunCalc.getSunRiseSet(timestamp * 1e18, motif.lat * 1e12, motif.lng * 1e12);
         } else {
            sunrise = 0;
            sunset = 0;
         }
        

         sunSVG = NDRenderer.renderSun(uint(motif.horizon) * 1e4, azimuth / 1e14, altitude / 1e14, uint(motif.heading) * 1e4);


         (int moonAzimuth, int moonAltitude, int parallacticAngle) = SunCalc.getMoonPosition( motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);


          (int fraction, , int angle )  = SunCalc.getMoonIllumination(timestamp * 1e18);


          moonSVG = NDRenderer.renderMoon( motif.motifType,  motif.heading * 1e4, motif.horizon * 1e4, moonAzimuth / 1e14, moonAltitude / 1e14, parallacticAngle / 1e14, fraction / 1e14, angle / 1e14);
           string memory waterColor;
          ( skyColor, waterColor) = NDRenderer.getSkyColor(altitude / 1e16);
           constructedNFT.svg = NDRenderer.replaceFirst(constructedNFT.svg, "<!--watercolor-->", waterColor);

        uint randomFlower = NDRenderer.randomNum(tokenId, 0, 2);        

         FlowerType flowerType =  FlowerType(randomFlower);
         bool hasPot = motif.motifType != MotifType.SIGHT_SEEING;
         constructedNFT.attributes = NDRenderer.createStandardAttributes(motif, flowerType);


        (string memory blossom, string memory stick, string memory back, string memory front) = flowerType == FlowerType.ROSE ? motifDataManager.getRose() : flowerType == FlowerType.SUNFLOWER ? motifDataManager.getSunflower() : motifDataManager.getGentian(); 
         constructedNFT.svg = NDRenderer.renderFlower(constructedNFT.svg, azimuth / 1e14, altitude / 1e16, motif.heading * 1e4, flowerType, blossom, stick, back, front, hasPot);

         nightSVG = NDRenderer.applyNight( altitude / 1e14, motif.motifType);
        }

         AssetInScene[] memory assetInScene = motifDataManager.getAssetInScene();
         string memory maskedAssetsSVG;
        (constructedNFT.svg, maskedAssetsSVG) = NDRenderer.renderMainScene(constructedNFT.svg, timestamp, tokenId, motif.scenes, assetInScene, sunrise, sunset);
         constructedNFT.svg = NDRenderer.renderReplacements(constructedNFT.svg, motif.replacements);
         string memory skySceneSVG = renderAirplanes( timestamp, tokenId, uint(motif.horizon), motif.heading);

                  // take first second of day and add token id to it
        uint cloudNonce = block.timestamp - (block.timestamp  % 86400) + tokenId;
         string memory cloudsSVG = NDRenderer.generateClouds( motif.horizon, cloudNonce);
         
        if (motif.motifType == MotifType.BEACH) {
            constructedNFT = renderBeachTraits(constructedNFT, tokenId);
        }

        if(motif.motifType == MotifType.SKYSCRAPER) {
            constructedNFT = renderCityTraits(constructedNFT, tokenId);
        }

        if(motif.motifType == MotifType.LANDSCAPE) {
            constructedNFT = renderLandscapeTraits(constructedNFT, tokenId);
        }

        if(motif.motifType != MotifType.SIGHT_SEEING) {
            constructedNFT.svg = renderNFTInside(constructedNFT.svg, tokenId, timestamp);
        }



        constructedNFT.svg = renderNFT(skyColor, motif.motifType, constructedNFT.svg, sunSVG, cloudsSVG, skySceneSVG, maskedAssetsSVG, moonSVG, nightSVG);
        constructedNFT.name = motif.name;


       



        return constructedNFT;
    }

    function renderNFT(string memory skyColor, MotifType motifType, string memory motifSVG, string memory sunSVG, string memory cloudsSVG, string memory skySceneSVG, string memory maskedAssetsSVG, string memory moonSVG, string memory nightSVG) public view returns (string memory) {


        string memory motifTypeString = motifType == MotifType.SIGHT_SEEING ? "S" : "G";
        string memory topSVG = 
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1080 1080">'
        '<filter id="makeBlack">'
        '<feColorMatrix type="matrix"'
        ' values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0" /></filter>';




        string memory assetsSVG = motifDataManager.assets();

        string memory skyBGSVG = string.concat('<rect fill="', skyColor, '" width="1080" height="1080"/>');
        string memory skyBehind = string.concat(topSVG, skyBGSVG , sunSVG, cloudsSVG, skySceneSVG, assetsSVG);

        string memory moonMask = string.concat('<mask id="moonMask', motifTypeString, '"><rect fill="#fff" width="1080" height="1080"/>','<use href="#motif', motifTypeString, '" filter="url(#makeBlack)"/></mask>', nightSVG , moonSVG ,'</svg>');
        string memory lightHouse = '<use href="#lighthouse" filter="url(#makeBlack)"/>';
        string memory nightMask = string.concat('</g><mask id="nightMask', motifTypeString, '">','<rect fill="#fff" width="1080" height="1080"/>', motifType == MotifType.SIGHT_SEEING ? lightHouse : '', maskedAssetsSVG ,'</mask>');

        string memory outputSVG = string.concat(skyBehind, '<g id="motif', motifTypeString, '">', motifSVG, nightMask, moonMask );

        return outputSVG;


    }

    function renderAirplanes(        
        uint timestamp, 
        uint tokenId, uint horizonInPx, int heading) public pure returns (string memory) {

            string memory assetName = "aeroplane";
            string memory salt = string.concat(tokenId.toString(), heading.toStringSigned());

            string memory assetsSVG =  NDRenderer.renderMovingAsset(timestamp, salt, assetName, false, 0, horizonInPx, false, 1, 3, 120, 60, 100, 60 );
            return assetsSVG;
        }


        function renderWaterScene(string memory svg, uint timestamp, uint tokenId, uint horizonInPx, int heading) public pure returns (string memory) {
            
            
            string memory salt = string.concat(tokenId.toString(), heading.toStringSigned());
            

            string memory tankerSVG =  NDRenderer.renderMovingAsset(timestamp, salt, "tanker", true, horizonInPx, 0, false, 1, 3, 120, 60, 100, 60 );
            string memory fisherSVG =  NDRenderer.renderMovingAsset(timestamp, salt, "fisher", true, horizonInPx, 0, false, 1, 3, 120, 60, 100, 60 );
            string memory yachtSVG =   NDRenderer.renderMovingAsset(timestamp, salt, "yacht", true, horizonInPx, 0, false, 1, 3, 120, 60, 100, 60 );

            string memory assetsSVG = string.concat(tankerSVG, fisherSVG, yachtSVG);

            return NDRenderer.replaceFirst(svg, "<!--waterscene-->", assetsSVG);


        }

        function renderBeachTraits(ConstructedNFT memory nft, uint tokenId) public view returns (ConstructedNFT memory) {
            
            (string memory beachColor, string memory beachColorAttribute) =  motifDataManager.getBeachColor(tokenId);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--bc-->", beachColor);
            nft.attributes = string.concat(nft.attributes, beachColorAttribute);
            (string memory skinColor, string memory skinColorAttribute) =  motifDataManager.getSkinColor(tokenId);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--sc-->", skinColor);
            nft.attributes = string.concat(nft.attributes, skinColorAttribute);
            return nft;
        } 

        function renderNFTInside(string memory svg, uint tokenId, uint timestamp) public view returns (string memory) {
            
            uint sightSeeingTokenId = NDRenderer.randomNum(tokenId, 0, 18);
            ConstructedNFT memory nft = generateNFT(sightSeeingTokenId, timestamp);

            return NDRenderer.replaceFirst(svg, "<!--nft-->", nft.svg);
        }


        function renderCityTraits(ConstructedNFT memory nft, uint tokenId) public view returns (ConstructedNFT memory) {


            //RENDER SkYLINE
            string[4] memory skyLineTypes = ["mini", "midi", "large", "mega"];
            uint skyLineType = motifDataManager.getSkylineType(tokenId);
            for(uint i = 0; i < skyLineTypes.length; i++) {
                string memory skylineString = skyLineTypes[i];
                nft.svg = NDRenderer.replaceFirst( nft.svg, string.concat("<!--", skylineString, "-->"), i <=skyLineType ? "visible" : "hidden");
            }
            nft.attributes = string.concat(nft.attributes, ',{"trait_type": "Skyline", "value": "', skyLineTypes[skyLineType], '"}');

            (bool isCityCoastel, string memory attribute) = motifDataManager.isCityCoastel(tokenId);
            nft.attributes = string.concat(nft.attributes, attribute);

             nft.svg = NDRenderer.replaceFirst( nft.svg, "<!--coastal-->", isCityCoastel ? "visible" : "hidden");

         
            //RENDER CHART
            uint[] memory prices = new uint[](16);
            address tradingChartAddress = motifDataManager.getTradingChartAddress(tokenId);
            AggregatorV3Interface dataFeed = AggregatorV3Interface(tradingChartAddress);
            (uint80 firstRoundID , int price , ,uint firstUpdatedAt , ) = dataFeed.latestRoundData();
            prices[0] = uint(price);
            prices[1] = firstUpdatedAt;

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


            uint chartWidth = 350;
            uint chartHeight = 150;
            uint chartX = 40;
            uint chartY = 680;

            // iterate prices and create line chart based on price and timestamp
            string memory chart;
           
            for(uint j = 0; j < prices.length; j+=2) {
                uint x = (prices[j+1] - prices[prices.length - 1]) * chartWidth / timeRange + chartX;
                uint y = chartHeight - (prices[j] - lowestPrice) * chartHeight / priceRange + chartY;

                chart = string.concat( chart, j == 0 ? "M" : "L", x.toString(), " ", y.toString());
            }

            string memory chartSVG = string.concat('<path d="', chart,'" fill="none" stroke="#FFDB19" stroke-width="4" />');
            string memory descriptionSVG = string.concat('<text x="20" y="620" fill="#9400E3" font-family="Arial-Black" font-size="24px">',description, '</text>');
            
            nft.svg =  NDRenderer.replaceFirst(nft.svg, "<!--chart-->", string.concat(chartSVG, descriptionSVG));
            return nft;
        }


        function renderLandscapeTraits(ConstructedNFT memory nft, uint tokenId) public view returns (ConstructedNFT memory) {

            string memory hidden = "hidden";
            string memory visible = "visible";

            

            (string memory landscapeColor, string memory landscapeColorTrait, uint climateZoneIndex) =  motifDataManager.getClimateZoneForLandscape(tokenId);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--cc-->", landscapeColor);
            nft.attributes = string.concat(nft.attributes, landscapeColorTrait);
            
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--p-->", climateZoneIndex == 0 ? visible : hidden);
            nft.svg= NDRenderer.replaceFirst(nft.svg, "<!--t-->",  climateZoneIndex == 1 ? visible : hidden);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--d-->", climateZoneIndex == 2 ? visible : hidden);

             (bool hasCity,bool hasRiver,bool hasMountains,bool hasOcean, string memory sTraits) = motifDataManager.getLandScapeTraits(tokenId);

            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--c-->", hasCity ? visible : hidden);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--r-->", hasRiver ? visible : hidden);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--m-->", hasMountains ? visible : hidden);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--o-->", hasOcean ? visible : hidden);
            nft.attributes = string.concat(nft.attributes, sTraits);

            (string memory skinColor, string memory skinColorAttribute) =  motifDataManager.getSkinColor(tokenId);
            nft.svg = NDRenderer.replaceFirst(nft.svg, "<!--sc-->", skinColor);
            nft.attributes = string.concat(nft.attributes, skinColorAttribute);



            return nft;
        }




}

