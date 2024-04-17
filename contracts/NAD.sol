// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import Strings lib
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BasicMotif.sol";
import "./NDDecoder.sol";


import "./NDRenderer.sol";
import "./NDAlgos.sol";



import "./NDMotifDataManager.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ERC721Reservations.sol";
 


contract NAD is ERC721Reservations {
     using Strings for uint256;
     using Strings for int256;


      string topSVG = 
      '<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" viewbox="0 0 1080 1080">'
      '<filter id="makeBlack">'
      '<feColorMatrix type="matrix"'
      ' values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0" /></filter>';

    


    NDMotifDataManager public motifDataManager;
  


     
    constructor(address _motifDataManager) ERC721Reservations("Night And Day", "N&D") {

        _setDefaultRoyalty(payable(0x29C8950157979A0bC26772F1cC74006D6cF97473), 2500);

       motifDataManager =  NDMotifDataManager(_motifDataManager);



    }



    function tokenURI(uint256 tokenId) public override view returns (string memory) {
    //    _requireOwned(tokenId);
    
        return generateNFT(tokenId);
    }

    function tokenUriWithTime(uint256 tokenId, uint256 timestamp) public view returns (string memory) {
        return generateNFT(tokenId, timestamp);
    }

    function generateNFT(uint256 tokenId, uint256 _timestamp) public view returns (string memory) {


        Motif memory motif  = motifDataManager.getMotifByTokenId(tokenId);

        string memory motifSVG = motif.svg;

        uint timestamp = _timestamp;
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


          (int fraction, int phase, int angle )  = SunCalc.getMoonIllumination(timestamp * 1e18);


          moonSVG = NDRenderer.renderMoon( motif.motifType,  motif.heading * 1e4, motif.horizon * 1e4, moonAzimuth / 1e14, moonAltitude / 1e14, parallacticAngle / 1e14, fraction / 1e14, angle / 1e14);
           string memory waterColor;
          ( skyColor, waterColor) = NDRenderer.getSkyColor(altitude / 1e16);
           motifSVG = NDRenderer.replaceFirst(motifSVG, "<!--watercolor-->", waterColor);



        
        uint randomFlower = NDRenderer.randomNum(tokenId, 0, 2);        

         FlowerType flowerType =  FlowerType(randomFlower);
         bool hasPot = motif.motifType != MotifType.SIGHT_SEEING;

        (string memory blossom, string memory stick, string memory back, string memory front) = flowerType == FlowerType.ROSE ? motifDataManager.getRose() : flowerType == FlowerType.SUNFLOWER ? motifDataManager.getSunflower() : motifDataManager.getGentian(); 
         motifSVG = NDRenderer.renderFlower(motifSVG, azimuth / 1e14, altitude / 1e16, motif.heading * 1e4, flowerType, blossom, stick, back, front, hasPot);

         nightSVG = NDRenderer.applyNight( altitude / 1e14, motif.motifType);
        }

         AssetInScene[] memory assetInScene = motifDataManager.getAssetInScene();
         string memory maskedAssetsSVG;
        (motifSVG, maskedAssetsSVG) = NDRenderer.renderMainScene(motifSVG, timestamp, tokenId, motif.scenes, assetInScene, sunrise, sunset);
         motifSVG = NDRenderer.renderReplacements(motifSVG, motif.replacements);
         string memory skySceneSVG = renderAirplanes( timestamp, tokenId, uint(motif.horizon), motif.heading);

                  // take first second of day and add token id to it
        uint cloudNonce = block.timestamp - (block.timestamp  % 86400) + tokenId;
         string memory cloudsSVG = NDRenderer.generateClouds( motif.horizon, cloudNonce);
         
        if (motif.motifType == MotifType.BEACH) {
            motifSVG = renderBeachTraits(motifSVG, tokenId);
        }

        if(motif.motifType == MotifType.SKYSCRAPER) {
            motifSVG = renderCityTraits(motifSVG, tokenId);
        }

        if(motif.motifType == MotifType.LANDSCAPE) {
            motifSVG = renderLandscapeTraits(motifSVG, tokenId);
        }

        if(motif.motifType != MotifType.SIGHT_SEEING) {
            motifSVG = renderNFTInside(motifSVG, tokenId, _timestamp);
        }



       string memory outputSVG = renderNFT(skyColor, motif.motifType, motifSVG, sunSVG, cloudsSVG, skySceneSVG, maskedAssetsSVG, moonSVG, nightSVG);

        return outputSVG;
    }

    function renderNFT(string memory skyColor, MotifType motifType, string memory motifSVG, string memory sunSVG, string memory cloudsSVG, string memory skySceneSVG, string memory maskedAssetsSVG, string memory moonSVG, string memory nightSVG) public view returns (string memory) {


        string memory motifTypeString = motifType == MotifType.SIGHT_SEEING ? "S" : "G";



         string memory assetsSVG = motifDataManager.assets();

        string memory skyBGSVG = string.concat('<rect fill="', skyColor, '" width="1080" height="1080"/>');
        string memory skyBehind = string.concat(topSVG, skyBGSVG , sunSVG, cloudsSVG, skySceneSVG, assetsSVG);

        string memory moonMask = string.concat('<mask id="moonMask', motifTypeString, '"><rect fill="#fff" width="1080" height="1080"/>','<use href="#motif', motifTypeString, '" filter="url(#makeBlack)"/></mask>', nightSVG , moonSVG ,'</svg>');
        string memory lightHouse = '<use href="#lighthouse" filter="url(#makeBlack)"/>';
        string memory nightMask = string.concat('</g><mask id="nightMask', motifTypeString, '">','<rect fill="#fff" width="1080" height="1080"/>', motifType == MotifType.SIGHT_SEEING ? lightHouse : '', maskedAssetsSVG ,'</mask>');

        string memory outputSVG = string.concat(skyBehind, '<g id="motif', motifTypeString, '">', motifSVG, nightMask, moonMask );

        return outputSVG;


    }



    function generateNFT(uint256 tokenId) public view returns (string memory) {

   

    //     Motif memory motif  = motifDataManager.getMotifByTokenId(tokenId);


    //     string memory outputSVG = motif.svg;

    //     uint timestamp = block.timestamp;



    //      (int azimuth, int altitude) = SunCalc.getPosition(motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);
    //      (uint sunrise, uint sunset) = SunCalc.getSunRiseSet(timestamp * 1e18, motif.lat * 1e12, motif.lng * 1e12);

    //      outputSVG = NDRenderer.renderSun(outputSVG, uint(motif.horizon) * 1e4, azimuth / 1e14, altitude / 1e14, uint(motif.heading) * 1e4);



    //      (int moonAzimuth, int moonAltitude, int parallacticAngle) = SunCalc.getMoonPosition( motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);


    //       (int fraction, int phase, int angle )  = SunCalc.getMoonIllumination(timestamp * 1e18);

    //       outputSVG = NDRenderer.renderMoon(outputSVG, motif.motifType,  motif.heading * 1e4, motif.horizon * 1e4, moonAzimuth / 1e14, moonAltitude / 1e14, parallacticAngle / 1e14, fraction / 1e14, angle / 1e14);

    //       outputSVG = NDRenderer.setSkyColor(outputSVG, altitude / 1e16);

    //       outputSVG = NDRenderer.applyNight(outputSVG, altitude / 1e14, motif.motifType);
    //      // take first second of day and add token id to it
    //       uint cloudNonce = block.timestamp - (block.timestamp  % 86400) + tokenId;
    //      outputSVG = NDRenderer.generateClouds(outputSVG, motif.horizon, cloudNonce);


    //       uint randomFlower = NDRenderer.randomNum(tokenId, 0, 2);        

    //      FlowerType flowerType =  FlowerType(randomFlower);
    //       bool hasPot = motif.motifType != MotifType.SIGHT_SEEING;
         
    //     (string memory blossom, string memory stick, string memory back, string memory front) = flowerType == FlowerType.ROSE ? motifDataManager.getRose() : flowerType == FlowerType.SUNFLOWER ? motifDataManager.getSunflower() : motifDataManager.getGentian(); 
    //      outputSVG = NDRenderer.renderFlower(outputSVG, azimuth / 1e14, altitude / 1e16, motif.heading * 1e4, flowerType, blossom, stick, back, front, hasPot);


         
    //      AssetInScene[] memory assetInScene = motifDataManager.getAssetInScene();
    //      //outputSVG = NDRenderer.renderMainScene(outputSVG, timestamp, tokenId, motif.scenes, assetInScene, sunrise, sunset);
    //      outputSVG = NDRenderer.renderReplacements(outputSVG, motif.replacements);
    //      outputSVG = renderAirplanes(outputSVG, timestamp, tokenId, uint(motif.horizon), motif.heading);
         
    //     if (motif.motifType == MotifType.BEACH) {
    //         outputSVG = renderBeachTraits(outputSVG, tokenId);
    //     }

    //     if(motif.motifType == MotifType.SKYSCRAPER) {
    //         outputSVG = renderCityTraits(outputSVG, tokenId);
    //     }

    //     if(motif.motifType == MotifType.LANDSCAPE) {
    //         outputSVG = renderLandscapeTraits(outputSVG, tokenId);
    //     }

    //     if(motif.motifType != MotifType.SIGHT_SEEING) {
    //    //     outputSVG = renderNFTInside(outputSVG, tokenId);
    //     }


        return "";


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

        function renderBeachTraits(string memory svg, uint tokenId) public view returns (string memory) {
            
            (string memory beachColor, string memory beachColorTrait) =  motifDataManager.getBeachColor(tokenId);
            svg = NDRenderer.replaceFirst(svg, "<!--bc-->", beachColor);
            (string memory skinColor, string memory skinColorTrait) =  motifDataManager.getSkinColor(tokenId);
            svg = NDRenderer.replaceFirst(svg, "<!--sc-->", skinColor);
            return svg;
        } 

        function renderNFTInside(string memory svg, uint tokenId, uint timestamp) public view returns (string memory) {
            
            uint sightSeeingTokenId = NDRenderer.randomNum(tokenId, 0, 18);

            string memory externalNft = generateNFT(sightSeeingTokenId, timestamp);

            return NDRenderer.replaceFirst(svg, "<!--nft-->", externalNft);
        }


        function renderCityTraits(string memory svg, uint tokenId) public view returns (string memory) {


            //RENDER SkYLINE
            string[4] memory skyLineTypes = ["mini", "midi", "large", "mega"];
            uint skyLineType = motifDataManager.getSkylineType(tokenId);
            for(uint i = 0; i < skyLineTypes.length; i++) {
                string memory skylineString = skyLineTypes[i];
                svg = NDRenderer.replaceFirst(svg, string.concat("<!--", skylineString, "-->"), i <=skyLineType ? "visible" : "hidden");
            }

            bool isCityCoastel = motifDataManager.isCityCoastel(tokenId);

            svg = NDRenderer.replaceFirst(svg, "<!--coastal-->", isCityCoastel ? "visible" : "hidden");

         
            //RENDER CHART
            uint[] memory prices = new uint[](16);
            address tradingChartAddress = motifDataManager.getTradingChartAddress(tokenId);
            AggregatorV3Interface dataFeed = AggregatorV3Interface(tradingChartAddress);
            (uint80 firstRoundID , int price , ,uint firstUpdatedAt , ) = dataFeed.latestRoundData();
            prices[0] = uint(price);
            prices[1] = firstUpdatedAt;

            string memory description = dataFeed.description();
            firstRoundID--;
            for(uint i = 2; i < 16; i+=2) {
                (, int price, , uint updatedAt , ) = dataFeed.getRoundData(firstRoundID);
                prices[i] = uint(price);
                prices[i+1] = updatedAt;
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
            
            return NDRenderer.replaceFirst(svg, "<!--chart-->", string.concat(chartSVG, descriptionSVG));
        }


        function renderLandscapeTraits(string memory svg, uint tokenId) public view returns (string memory) {
            
            (string memory landscapeColor, string memory landscapeColorTrait, uint climateZoneIndex) =  motifDataManager.getClimateZoneForLandscape(tokenId);
            svg = NDRenderer.replaceFirst(svg, "<!--cc-->", landscapeColor);
            
            svg = NDRenderer.replaceFirst(svg, "<!--polar-->", climateZoneIndex == 0 ? "visible" : "hidden");
            svg = NDRenderer.replaceFirst(svg, "<!--temperate-->",  climateZoneIndex == 1 ? "visible" : "hidden");
            svg = NDRenderer.replaceFirst(svg, "<!--desert-->", climateZoneIndex == 2 ? "visible" : "hidden");

             (bool hasCity,bool hasRiver,bool hasMountains,bool hasOcean) = motifDataManager.getLandScapeTraits(tokenId);

            svg = NDRenderer.replaceFirst(svg, "<!--city-->", hasCity ? "visible" : "hidden");
            svg = NDRenderer.replaceFirst(svg, "<!--river-->", hasRiver ? "visible" : "hidden");
            svg = NDRenderer.replaceFirst(svg, "<!--mountains-->", hasMountains ? "visible" : "hidden");
            svg = NDRenderer.replaceFirst(svg, "<!--ocean-->", hasOcean ? "visible" : "hidden");



            
            return svg;
        }




}

