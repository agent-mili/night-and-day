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
import "./ERC721Random.sol";


import "./SunCalc.sol";
 


contract NAD is ERC721Random {
     using Strings for uint256;
     using Strings for int256;

              struct ConstructedNFT {
        string svg;
        string attributes;
        string name;
        uint assetTraitId;
        string description;
     }






     

    

    NDMotifDataManager public motifDataManager;
  


     
    constructor(address _motifDataManager) ERC721Random("Night And Day", "NAD") {

        setDefaultRoyalty(payable(0x7007780F983C3E33bE7E765f726d6866fc5CBe6c), 350);
       motifDataManager =  NDMotifDataManager(_motifDataManager);
       
    }

   function tokenURI(uint256 tokenId) public view override returns (string memory) {

        ownerOf(tokenId);

        AssetInScene[] memory assetInScene = motifDataManager.getAssetInScene();
        string memory assets = motifDataManager.assets();
        uint timestamp = block.timestamp;
        ConstructedNFT memory nft = generateNFT(tokenId, timestamp,assetInScene, assets);

        string memory base64SVG = string.concat( '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(nft.svg)), '"');
        string memory base64JSON =  string.concat('data:application/json;base64,', Base64.encode(bytes(string.concat('{"description" : "', nft.description,'", "name":"',nft.name, '",', nft.attributes,'],', base64SVG, '}'))));
        return base64JSON;
    }

  
    // function tokenUriWithTime(uint256 tokenId, uint256 timestamp) external view returns (string memory) {

    //     require(tokenId < 321, "Token ID out of range");


    //     AssetInScene[] memory assetInScene = motifDataManager.getAssetInScene();
    //     string memory assets = motifDataManager.assets();

    //     ConstructedNFT memory nft = generateNFT(tokenId, timestamp,assetInScene, assets);

    //     string memory base64SVG = string.concat( '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(nft.svg)), '"');
    //     string memory base64JSON =  string.concat('data:application/json;base64,', Base64.encode(bytes(string.concat('{"description" : "', nft.description ,'", "name":"',nft.name, '",', nft.attributes,'],', base64SVG, '}'))));
    //     return base64JSON;
    // }

    function generateNFT(uint256 tokenId, uint256 timestamp, AssetInScene[] memory assetInScene, string memory assets) internal view returns (ConstructedNFT memory) {


        Motif memory motif  = motifDataManager.getMotifByTokenId(tokenId);

        ConstructedNFT memory constructedNFT;

        constructedNFT.svg = motif.svg;

        SunMoon memory sunMoon;
        SVGData memory svgData;



      
   

        {
         (sunMoon.azimuth, sunMoon.altitude) = SunCalc.getPosition(motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);
         (sunMoon.sunrise, sunMoon.sunset) = SunCalc.getSunRiseSet(timestamp * 1e18, motif.lat * 1e12, motif.lng * 1e12);
       


        

         svgData.sunSVG = NDRenderer.renderSun(motif.horizon * 1e4, sunMoon.azimuth / 1e14, sunMoon.altitude / 1e14, uint(motif.heading) * 1e4);


         ( sunMoon.moonAzimuth, sunMoon.moonAltitude, sunMoon.parallacticAngle) = SunCalc.getMoonPosition( motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);


          (sunMoon.fraction, , sunMoon.angle )  = SunCalc.getMoonIllumination(timestamp * 1e18);


          svgData.moonSVG = NDRenderer.renderMoon( tokenId,  motif.heading * 1e4, motif.horizon * 1e4, sunMoon.moonAzimuth / 1e14, sunMoon.moonAltitude / 1e14, sunMoon.parallacticAngle / 1e14, sunMoon.fraction / 1e14, sunMoon.angle / 1e14);
          ( svgData.skyColor, svgData.waterColor) = NDUtils.getSkyColor(sunMoon.altitude / 1e16);

           if (motif.motifType != MotifType.SIGHT_SEEING || tokenId == 0 || tokenId == 1 || tokenId == 3 || tokenId == 6 || tokenId == 10 || tokenId == 13 || tokenId == 14 || tokenId == 18 || tokenId == 20)
           {
            constructedNFT.svg = NDUtils.replaceFirst(constructedNFT.svg, "$wc", svgData.waterColor);

            if (motif.motifType != MotifType.SKYSCRAPER && motif.motifType != MotifType.LANDSCAPE && tokenId != 18) {
                constructedNFT.svg = NDUtils.replaceFirst(constructedNFT.svg, "$wtok", tokenId.toString());
            }

           }


         FlowerType flowerType =  motifDataManager.getFlowerType(tokenId);
         (constructedNFT.attributes, constructedNFT.description) = NDUtils.createStandardAttributes(motif, flowerType, sunMoon.altitude / 1e14);


        FlowerParts memory flowerParts = motifDataManager.getFlower(flowerType);
        svgData.flowerSVG = NDRenderer.renderFlower(sunMoon, motif.heading * 1e4, flowerType, flowerParts, motif.motifType != MotifType.SIGHT_SEEING, tokenId);
        constructedNFT.svg = NDUtils.replaceFirst(constructedNFT.svg, "$flok", tokenId.toString());
         constructedNFT.svg = NDUtils.renderLighthouse(constructedNFT.svg, sunMoon.altitude, timestamp, tokenId);
         svgData.nightSVG = NDUtils.applyNight( sunMoon.altitude / 1e14, tokenId);
        
        }
        
         string memory maskedAssetsSVG;


         svgData.replacements = NDUtils.renderReplacements(motif.replacements, tokenId);
         (svgData.skySceneSVG, constructedNFT.svg) = NDRenderer.renderExtraMovingAssets(constructedNFT.svg, motif.movingScenes,timestamp, tokenId,  sunMoon);
        svgData.cloudsSVG = NDUtils.generateClouds( motif.horizon, tokenId , timestamp);


         
        if (motif.motifType == MotifType.BEACH) {
            constructedNFT = renderBeachTraits(constructedNFT, tokenId);
        }

        if(motif.motifType == MotifType.SKYSCRAPER) {
            constructedNFT = renderCityTraits(constructedNFT, tokenId, sunMoon, timestamp);
        }

        if(motif.motifType == MotifType.LANDSCAPE) {

            constructedNFT = renderLandscapeTraits(constructedNFT, tokenId);
            constructedNFT.svg = NDRenderer.renderSunclock(constructedNFT.svg, sunMoon.azimuth / 1e14, sunMoon.altitude / 1e16, motif.heading * 1e4);
        }
        
        if  (motif.motifType != MotifType.SIGHT_SEEING) {

           motif.scenes[0].sceneDetails[0].assets[0] = uint8(constructedNFT.assetTraitId);

           if (motif.motifType == MotifType.BEACH) {
               motif.scenes[0].sceneDetails[1].assets[0] = uint8(constructedNFT.assetTraitId);
               motif.scenes[0].sceneDetails[2].assets[0] = uint8(constructedNFT.assetTraitId);
           }
        }

        (constructedNFT.svg, maskedAssetsSVG) = NDRenderer.renderMainScene(constructedNFT.svg, timestamp, tokenId, motif.scenes, assetInScene, sunMoon.sunrise, sunMoon.sunset);

        //constructedNFT.svg = NDRenderer.renderWaterScene(constructedNFT.svg, timestamp, tokenId, motif, sunMoon);


        constructedNFT.svg = NDUtils.renderFinalNFT(assets,
        tokenId, constructedNFT.svg, svgData,maskedAssetsSVG, motif.motifType, timestamp);
        constructedNFT.name = motif.name;


          if(motif.motifType != MotifType.SIGHT_SEEING) {
            constructedNFT = renderNFTInside(constructedNFT, tokenId, timestamp, assetInScene);
        }



        return constructedNFT;
    }






        function renderBeachTraits(ConstructedNFT memory nft, uint tokenId) internal view returns (ConstructedNFT memory) {
            
            BeachTraits memory beachTraits =  motifDataManager.getBeachTraits(tokenId);
            nft.assetTraitId = beachTraits.jellyTypeId;
            nft.svg = NDUtils.replaceFirst(nft.svg, "$bc", beachTraits.beachColor);
            nft.attributes = string.concat(nft.attributes, beachTraits.attributes);
            nft.svg = NDUtils.replaceFirst(nft.svg, "$sc", beachTraits.skinColor);

            nft.svg = NDUtils.replaceFirst(nft.svg, "$sh", beachTraits.shortsSVG);
            nft.svg = NDUtils.replaceFirst(nft.svg, "$to", string.concat(beachTraits.towelSVG, beachTraits.beverage));
            return nft;
        } 

        function renderNFTInside(ConstructedNFT memory nft, uint tokenId, uint timestamp, AssetInScene[] memory assetInScene) internal view returns (ConstructedNFT memory) {
            
            uint sightSeeingTokenId = motifDataManager.getNFTInside(tokenId);

            ConstructedNFT memory nftInside = generateNFT(sightSeeingTokenId, timestamp, assetInScene, "");



            nft.attributes = string.concat(nft.attributes, ',{"trait_type": "NFT Inside", "value": "', nftInside.name, '"}');
            nft.svg =  NDUtils.replaceFirst(nft.svg, "$nft", nftInside.svg);
            return nft;
        }



        function renderCityTraits(ConstructedNFT memory nft, uint tokenId, SunMoon memory sunMoon, uint timestamp) internal view returns (ConstructedNFT memory) {

            string memory tokenIdStr = tokenId.toString();

            // render city lights
            uint xLight = NDUtils.randomNum(string.concat("xLight", tokenIdStr, sunMoon.sunset.toString()), 0, 400);
            uint yLight = NDUtils.randomNum(string.concat("yLight",tokenIdStr, sunMoon.sunset.toString()), 0, 400);
            string memory skyLineMask = string.concat('<defs><mask id="m-skyl', tokenIdStr, 
            '"><use href="#skyl', tokenIdStr, '" ></use><use href="#inner" filter="url(#makeBlack)" /><use href="#houses', tokenIdStr, 
            '" filter="url(#makeBlack)" /></mask><g id="s-light', tokenIdStr, '" mask="url(#m-skyl', tokenIdStr,
            ')"><path fill="url(#window', tokenIdStr, ')" d="M0 0h1080v1080H0z"></path></g><pattern x="', xLight.toString() ,'" y="', yLight.toString() ,'" width="400" height="400" patternUnits="userSpaceOnUse" id="window', tokenIdStr, '"  viewBox="0 -200 400 400"><use href="#city-lights" /></pattern></defs>');

            nft.svg = string.concat(nft.svg, skyLineMask);

            CityTraits memory cityTraits = motifDataManager.getCityTraits(tokenId);
        

            nft.assetTraitId = cityTraits.catTypeId;
            nft.attributes = string.concat(nft.attributes, cityTraits.attributes);

            nft.svg = NDUtils.replaceFirst( nft.svg, "$be", cityTraits.beverage);
            nft.svg = NDUtils.replaceFirst( nft.svg, "$tok", tokenIdStr);
            nft.svg = NDUtils.replaceFirst( nft.svg, "$co", cityTraits.isCoastel ? "hidden" : "visible");
            nft.svg = NDUtils.replaceFirst( nft.svg, "$oc", cityTraits.isCoastel ? "visible" : "hidden");
            // we need to choose two different houses from 6
            uint8[7] memory houses = [1, 2, 3, 4,5,6,7];
            // house 2 needs to be different from house 1
            // we need to remove the first house from the array, so that we can choose a different house for house 2
            uint houseIndex1 = NDUtils.randomNum(string.concat("h1",tokenIdStr), 0, 6);
            uint house1 = houses[houseIndex1];
            houses[houseIndex1] = houses[houses.length - 1];
            uint house2 = houses[NDUtils.randomNum(string.concat("h2",tokenIdStr), 0, 5)];


            string memory house1SVG = string.concat('<use href="#house_', house1.toString(), '" y="556" transform="translate(460,0)" />');
            string memory house2SVG = string.concat('<use href="#house_', house2.toString(), '" transform="translate(450,0) scale(-1,1)" y="556"/>');

            string memory housesSVG =  string.concat("<g id='houses",tokenIdStr,"'>" ,house1SVG, house2SVG, "</g>");

        




            nft.svg = NDUtils.replaceFirst( nft.svg, "$skyl", string.concat(cityTraits.skylineSVG, housesSVG));
         
            //RENDER CHART
            uint[] memory prices = new uint[](16);

            AggregatorV3Interface dataFeed = AggregatorV3Interface(cityTraits.priceFeed);

            uint80 firstRoundID;
            int256 price;
            uint256 firstUpdatedAt;
            
            try dataFeed.latestRoundData() returns (
            uint80 _firstRoundID,
            int256 _price,
            uint256,
            uint256 _firstUpdatedAt,
            uint80
            ) {

            firstRoundID = _firstRoundID;
            prices[0] = uint(_price);
            prices[1] = _firstUpdatedAt;

        } catch {
           
            firstUpdatedAt = timestamp - timestamp % 600;
            string memory fakeChartSalt = string.concat(tokenIdStr, firstUpdatedAt.toString());
            firstRoundID = 20;
            prices[0] = NDUtils.randomNum(fakeChartSalt, 0, 100000);
            prices[1] = firstUpdatedAt;
        }

            string memory description;

            try dataFeed.description() returns (string memory _description) {
                description = _description;
            } catch {
                description = "TULIPS / USD";
            }

            nft.attributes = string.concat(nft.attributes, ',{"trait_type":"Trading Chart","value":"', description, '"}');
            firstRoundID--;




        for(uint i = 2; i < 16; i+=2) {

            try dataFeed.getRoundData(firstRoundID) returns (
            uint80,
            int256 _price,
            uint256,
            uint256 _firstUpdatedAt,
            uint80
            ) {
           
            prices[i] = uint(_price);
            prices[i+1] = _firstUpdatedAt;

           

        } catch {

            firstUpdatedAt = timestamp - (timestamp % 600) - i * 600;
            string memory fakeChartSalt = string.concat(tokenIdStr, firstUpdatedAt.toString());
            price = int(NDUtils.randomNum(fakeChartSalt, 0, 100000));
           
            prices[i] = uint(price);
            prices[i+1] = firstUpdatedAt;
        }
            
            firstRoundID--;
        }

            uint decimals;
            try dataFeed.decimals() returns (uint8 _decimals) {
                decimals = _decimals;
            } catch {
                decimals = 2;
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

            string memory chart;
            for(uint j = 0; j < prices.length; j+=2) {
                uint x = (prices[j+1] - prices[prices.length - 1]) * chartWidth / timeRange + chartX;
                uint y = chartHeight - (prices[j] - lowestPrice) * chartHeight / priceRange + chartY;

                chart = string.concat( chart, j == 0 ? "M" : "L", x.toString(), " ", y.toString());
            }
            string memory highPriceStr = NDUtils.formatChartNumber(highestPrice/(10**(decimals-2)));
            string memory lowPriceStr = NDUtils.formatChartNumber(lowestPrice/(10**(decimals -2)));


            string memory chartSVG = string.concat('<path d="', chart,'" fill="none" stroke="#FFDB19" stroke-width="4" />');
            string memory descriptionSVG = string.concat('<text x="190" y="', cityTraits.displayType == 0 ? '760' : '960' ,'" text-anchor="middle" fill="#9400E3" font-family="Arial-Black"  font-size="20px">',description, '</text>');
            string memory pricesStr = string.concat('<g font-family="Arial-BoldMT" fill="#9400E3" text-anchor="end" font-size="18"><text transform="translate(328 790)">', highPriceStr ,'</text><text transform="translate(328 916)">',lowPriceStr,'</text></g>');

            nft.svg =  NDUtils.replaceFirst(nft.svg, "$di", string.concat(cityTraits.tableSVG, cityTraits.displaySVG, chartSVG, descriptionSVG, pricesStr));
            return nft;
        }


        function renderLandscapeTraits(ConstructedNFT memory nft, uint tokenId) internal view returns (ConstructedNFT memory) {


            LandscapeTraits memory landscapeTraits = motifDataManager.getLandScapeTraits(tokenId);

            nft.assetTraitId = landscapeTraits.catTypeId;
                        
            nft.svg = NDUtils.replaceFirst( nft.svg, "$tok", tokenId.toString());
            nft.svg = NDUtils.replaceFirst( nft.svg, "$oc", landscapeTraits.hasOcean ? "visible" : "hidden");


             nft.svg = NDUtils.replaceFirst(nft.svg, "$pe",string.concat(landscapeTraits.artistSVG));
             nft.svg = NDUtils.replaceFirst(nft.svg, "$fu", string.concat(landscapeTraits.furnitureSVG, landscapeTraits.beverage));


            nft.svg = NDUtils.replaceFirst(nft.svg, "$be", landscapeTraits.before);
            nft.attributes = string.concat(nft.attributes, landscapeTraits.attributes);


            return nft;
        }




}

