pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Strings.sol";

//import "./NDAlgos.sol";
import "./BasicMotif.sol";
//import "./Assets.sol";

import "./SunCalc.sol";

import "./NDUtils.sol";

import "forge-std/console.sol";


library NDRenderer {
using Strings for uint256;
using Strings for int256;
using Strings for int16;

int constant viewingRangeHorizontal = 120 * 1e4;
int constant viewingRangeVertical = 60 * 1e4;
int constant skyWidth = 1080 * 1e4;
int constant sunWidthInDegree = viewingRangeHorizontal * 1e4 / skyWidth * 95;

uint256 constant TO_RAD = 17453292519943296;
uint256 constant TO_DEG = 57295779513224454144;

 struct SkyAndWaterColor {
        int altitude;
        string skyColor;
        string waterColor;
    }

    struct SceneElement {
        uint y;
        string svg;
    }





    function renderMainScene(string memory svg, uint256 timestamp, uint256 tokenID, SceneInMotif[] memory scenes, AssetInScene[] memory assetsInScene, uint sunrise, uint sunset) public pure returns (string memory, string memory) {
        string memory nightMaskSvg = "";

        for (uint i = 0; i < scenes.length; i++) {
            SceneInMotif memory scene = scenes[i];
  

            (string memory sceneSvg, string memory sceneMaskSvg) = renderSceneAssets(scene,assetsInScene, timestamp, tokenID, sunrise, sunset);
   
            svg = NDUtils.replaceFirst(svg,string.concat("$", scene.placeHolder ), sceneSvg);
            nightMaskSvg = string.concat(nightMaskSvg, sceneMaskSvg);
        }

        return (svg, nightMaskSvg);
    }

    function renderSceneAssets(SceneInMotif memory scene,  AssetInScene[] memory assets, uint256 timestamp, uint256 tokenID ,uint sunrise, uint sunset) public pure returns (string memory sceneSvg, string memory sceneMaskSvg) {
         
        SceneElement [] memory elements = new SceneElement[](assets.length);

            
        
        for (uint i = 0; i < scene.assets.length; i++) {
            uint allAssetIndex = 0;
            uint8 assetId = scene.assets[i];
            AssetInScene memory asset = assets[assetId];

            {
            string memory assetSalt = string.concat(tokenID.toString(), asset.name, scene.placeHolder);
            uint[] memory visibleStartTimes = computeStarttime(timestamp, asset, assetSalt , sunrise, sunset, false);

            for (uint i2 = 0; i2 < visibleStartTimes.length; i2++) {
                {

                uint startTime = visibleStartTimes[i2];
                
                string memory posSalt = string(abi.encodePacked(startTime.toString(), asset.name));
                uint256 y = uint(scene.area[1]) + NDUtils.randomNum(posSalt, 0, uint(scene.area[3]));
                uint256 x = uint(scene.area[0]) + NDUtils.randomNum(posSalt, 0, uint(scene.area[2]));
                int xScale = NDUtils.randomNum(posSalt, 0,1)  == 0 ? int(1): int(-1);
                string memory assetSvg = string.concat('<use fill="<!--rdColor-->" href="#',asset.name, '" transform="translate(', x.toString(), ',', y.toString(), ') scale(', NDUtils.renderDecimal(int(xScale *  int(scene.scale))), ' '  , NDUtils.renderDecimal(int(scene.scale)), ')"/>');

                assetSvg = NDUtils.setRandomColor(assetSvg, posSalt);

                elements[allAssetIndex] = SceneElement(y, assetSvg);
                allAssetIndex++;
                

                string memory maskName = string.concat(asset.name, "-mask");
                sceneMaskSvg = string.concat(sceneMaskSvg, '<use href="#', maskName, '" filter="url(#makeBlack)" transform="translate( ', x.toString(),',', y.toString(), ') scale(', NDUtils.renderDecimal(int(xScale * int(scene.scale))), ' ' , NDUtils.renderDecimal(int(scene.scale)),')"/>');
                }
                
        }
        
  
        }

        elements = sortElements(elements);
        }


       

        for (uint i = 0; i < elements.length; i++) {
            sceneSvg = string.concat(sceneSvg, elements[i].svg);
        }


        return (sceneSvg, sceneMaskSvg);
    }

    function sortElements( SceneElement [] memory elements ) public pure returns (SceneElement [] memory){

            uint n = elements.length;
              for (uint i = 0; i < n; i++) {
            for (uint j = 0; j < n - i - 1; j++) {
                if (elements[j].y > elements[j + 1].y) {
                    // Elemente tauschen
                    SceneElement memory temp = elements[j];
                    elements[j] = elements[j + 1];
                    elements[j + 1] = temp;
                }
            }
        }
        return elements;

    }

    function renderMovingAsset(
        uint timestamp, 
        string memory salt, 
        string memory assetName, 
        bool hasRandomColor, 
        uint minY, 
        uint maxY, 
        bool horizontUp, 
        uint minScale, 
        uint maxScale, 
        uint duration, 
        uint checkInterval, 
        uint appearanceProbability, 
        uint possibleOffset
    ) public view returns (string memory) {
        string memory assetSalt = string(abi.encodePacked(salt, assetName));
        AssetInScene memory assetInScene = AssetInScene(assetName, duration, duration, checkInterval, possibleOffset, appearanceProbability, DAYTIME.NIGHT_AND_DAY);
        uint[] memory visibleStartTimes = computeStarttime(timestamp, assetInScene, assetSalt , 0, 0, true);

        string memory assets;
        for (uint i = 0; i < visibleStartTimes.length; i++) {
            uint startTime = (visibleStartTimes[i]);

            int progress = int(timestamp - startTime) * 100 / int(duration);


            if (progress >= -30 && progress <= 130) {
                string memory visibleAssetSalt = string(abi.encodePacked(salt, startTime.toString()));
                uint y = NDUtils.randomNum(visibleAssetSalt, uint(minY), uint(maxY));
                int direction = int8(NDUtils.randomNum(visibleAssetSalt, 0, 1) == 0 ? -1 : int8(1));
                uint maxX = 1080;
                int x = direction == -1 ? int(maxX) * progress / 100 : int(maxX) * (100 - progress) / 100;

                uint rangeY = maxY - minY;
                uint diffY = y - minY;
                uint scaleDiff = maxScale - minScale;

            
                uint proportion = diffY * 1e18 / rangeY; 
                uint scale;
                if (horizontUp) {
                    scale = minScale + scaleDiff * proportion / 1e18; 
                } else {
                    scale = maxScale - scaleDiff * proportion / 1e18; 
                }
               
                string memory assetSvg;
                if (hasRandomColor)
                {
                    assetSvg = string.concat('<use href="#', assetName ,'" fill="<!--rdColor-->" transform="translate(', x.toStringSigned(), ', ', y.toString(), ') scale(', NDUtils.renderDecimal(int(int(scale) * direction)) , ' ', NDUtils.renderDecimal(int(scale)), ') "/>');
                    assetSvg = NDUtils.setRandomColor(assetSvg, visibleAssetSalt);
                } else {
                    assetSvg = string.concat('<use href="#', assetName ,'" transform="translate(', x.toStringSigned(), ', ', y.toString(), ') scale(', NDUtils.renderDecimal(int(int(scale) * direction)) , ' ', NDUtils.renderDecimal(int(scale)), ') "/>');
                }

                console.log(assetSvg);

                assets = string.concat(assets, assetSvg);
            }
        }
        return assets;
    }

     function renderSun(uint skyHeight, int azimuth, int altitude, uint heading) public pure returns (string memory) {
        
        int sunHeightInDegree = viewingRangeVertical * 1e4 / int(skyHeight)* 95;
        if (altitude > - sunHeightInDegree && altitude <= viewingRangeVertical + sunHeightInDegree) {

            int diffAngle = getDiffAngle(azimuth, int(heading));

     
            if (diffAngle < viewingRangeHorizontal / 2 + sunWidthInDegree && diffAngle > - viewingRangeHorizontal / 2 - sunWidthInDegree) {
                int x = (diffAngle +  viewingRangeHorizontal  / 2) * skyWidth / viewingRangeHorizontal;
                int y = int(skyHeight) - altitude * int(skyHeight)  / viewingRangeVertical;

                x = x / 1e2;
                y = y / 1e2;

                string memory sun =  string.concat(
                "<g> <circle cx='", NDUtils.renderDecimal(x), 
                    "' cy='", NDUtils.renderDecimal(y), 
                    "' r='58' fill='#fff' /> <circle cx='", 
                   NDUtils.renderDecimal(x), "' cy='", 
                    NDUtils.renderDecimal(y), 
                    "' r='95' fill='#fff' opacity='0.26' /></g>"
                );

                return sun;
            }
        }
        return "";
    }

        function renderMoon(MotifType motifType, int heading, int skyHeight, int azimuth, int altitude, int pa, int fraction, int angle ) public pure returns (string memory) {

            int moonWidthInDegree =viewingRangeHorizontal  * 1e4 / skyWidth * 58;
            int moonHeightInDegree = viewingRangeVertical * 1e4 / skyHeight * 58;
             if (altitude > - moonHeightInDegree && altitude <= viewingRangeVertical + moonHeightInDegree) {
            int diffAngle = getDiffAngle(azimuth, heading);
            int moonRadius = 580000;

            if (diffAngle < int(viewingRangeHorizontal) / 2 + moonWidthInDegree && diffAngle > - viewingRangeHorizontal / 2 - moonWidthInDegree) {
                int x = (diffAngle +  viewingRangeHorizontal  / 2) * skyWidth/ viewingRangeHorizontal - moonRadius;
                int y = int(skyHeight) - altitude * int(skyHeight) / viewingRangeVertical;

                x = x / 1e2;
                y = y / 1e2;




                int zenitMoonangle = pa - angle;
                int terminatorRadius = ( 2 * fraction - 1e4 ) * moonRadius / 1e4; 
                bool isCrescent = fraction < 5000;
                bool isGibbos = fraction > 5000;

                moonRadius = moonRadius / 1e2;
                terminatorRadius = terminatorRadius / 1e2;
                zenitMoonangle = zenitMoonangle / 1e2;
                string memory motifTypestring = motifType == MotifType.SIGHT_SEEING ? "S" : "G";
                string memory moon = string.concat('<g mask="url(#moonMask', motifTypestring ,')"><path transform="rotate(', NDUtils.renderDecimal(zenitMoonangle), ' ', NDUtils.renderDecimal(x + moonRadius), ' ', 
                NDUtils.renderDecimal(y), ')" stroke="white" shapeRendering="geometricPrecision" fill="white" d="M ', NDUtils.renderDecimal(x), ' ', NDUtils.renderDecimal(y), ' a ',
                NDUtils.renderDecimal(moonRadius), ' ', NDUtils.renderDecimal(moonRadius), ' 0 0 1 ', NDUtils.renderDecimal(moonRadius * 2), ' 0 a ', NDUtils.renderDecimal(moonRadius), ' ',
                NDUtils.renderDecimal(terminatorRadius), ' 0 ', isCrescent ? '1' : '0', ' ', isGibbos ? '1' : '0', ' ', NDUtils.renderDecimal(-moonRadius * 2), ' 0 z"></path></g>');

                return moon;

            }
        }

        return "";
    }

       function applyNight(int256 altitude, MotifType motifType) public pure returns (string memory) {
        // Konstanten in e18
        int256 altitudeThresholdForFullNight = -180000;
        int256 opacityFactor = 22 * 1e2;

        uint256 opacity;
        if (altitude < altitudeThresholdForFullNight) {
            opacity = 100; 
        } else if (altitude < 0 && altitude > altitudeThresholdForFullNight) {
            opacity =  uint( NDUtils.abs(altitude) / opacityFactor );
        } else {
            opacity = 0; 
        }

       
        string memory opacityString = NDUtils.renderDecimal(int256(opacity));

        string memory motifTypeString = motifType == MotifType.SIGHT_SEEING ? "S" : "G";

        string memory night = string.concat(
            '<rect mask="url(#nightMask', motifTypeString, ')" style="mix-blend-mode:multiply" width="1080" height="1080" fill="#0F3327" opacity="',
            opacityString,
            '"></rect>'
        );

        
        return night;
    }



    function getSkyColor( int altitude) internal pure returns (string memory , string memory) {
        
        
        SkyAndWaterColor[17] memory skyColors = [
        SkyAndWaterColor(-9000, "#ce80ff", "#f9b233"),
        SkyAndWaterColor(-1200, "#ce80ff", "#f9b233"),
        SkyAndWaterColor(-700, "#e780c0", "#e0b439"),
        SkyAndWaterColor(-400, "#ff8080", "#c8b63f"),
        SkyAndWaterColor(0, "#ff9986", "#afb845"),
        SkyAndWaterColor(300, "#ffb28c", "#96b94c"),
        SkyAndWaterColor(700, "#ffd986", "#7dbb52"),
        SkyAndWaterColor(1100, "#ffff80", "#65bd58"),
        SkyAndWaterColor(1500, "#c0eac0", "#4cbf5e"),
        SkyAndWaterColor(2500, "#80d5ff", "#57af6c"),
        SkyAndWaterColor(1800, "#77c7f8", "#639e7a"),
        SkyAndWaterColor(2500, "#6dbaf1", "#6e8e88"),
        SkyAndWaterColor(3500, "#64acea", "#797d95"),
        SkyAndWaterColor(4700, "#5a9ee4", "#846da3"),
        SkyAndWaterColor(6000, "#5190dd", "#905cb1"),
        SkyAndWaterColor(7300, "#4783d6", "#9b4cbf"),
        SkyAndWaterColor(8000, "#3e75cf", "#9b4cbf")
      
        ];
        string memory cColor = "#fff"; 
        string memory wColor = "#fff";
        for (uint i = 0; i < skyColors.length; i++) {
            if (altitude >= skyColors[i].altitude) {
                if (i == skyColors.length - 1) {
                    cColor = skyColors[i].skyColor;
                    wColor = skyColors[i].waterColor;
                    break;
                }
                else if (altitude < skyColors[i + 1].altitude) {
                    cColor = skyColors[i].skyColor;
                    wColor = skyColors[i].waterColor;
                    break;
                }
            }
        }

     
        return (cColor, wColor);
    }

    function getDiffAngle(int256 azimuth, int256 heading) public pure returns (int256) {

        heading = heading % 3600000;
        azimuth = azimuth % 3600000;

        if(azimuth < 0) {
            azimuth += 3600000;
        }
        if(heading < 0) {
            heading += 3600000;
        }

        int256 diffAngle = azimuth - heading;

        if (NDUtils.abs(diffAngle) > 1800000) {
            diffAngle = diffAngle > 0 ? diffAngle - 3600000 : diffAngle + 3600000;
        }

        return diffAngle;
    }

     function renderFlower(string memory svg, int256 azimuth, int256 altitude, int256 heading, FlowerType flowerType, string memory blossom, string memory stick, string memory back, string memory front, bool hasPot) public pure returns (string memory) {
        
        
        altitude = altitude > 8500 ? int(8500) : altitude;
        int256 angle = getDiffAngle(azimuth, heading);
        angle /= 1e2;
        string memory flowerSvg;

        string memory transformContainer = '<g style="transform: rotateY(<!--azi-->) rotateX(<!--alt-->); transform-box:fill-box;transform-origin:center">';


        if (altitude <= 0) {
            flowerSvg = string.concat(stick, transformContainer, blossom, front , '</g>');

            flowerSvg = NDUtils.replaceFirst(flowerSvg, "<!--azi-->", "0");
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "<!--alt-->", "0");

            if(flowerType == FlowerType.GENTIAN) {
                  flowerSvg = NDUtils.replaceFirst(flowerSvg, "<!--aziStick-->", "0");
            }
        } else {
            if (NDUtils.abs(angle) >= 9000) {
                flowerSvg = string.concat(stick, transformContainer, blossom, front, '</g>');

            } else {
                flowerSvg = string.concat(transformContainer, blossom, back, '</g>' ,stick);

            }

            // Angle adjustments
            if (angle > 8500 && angle < 9000) {
                angle = 8500;
            } else if (angle > 9000 && angle < 9500) {
                angle = 9500;
            } else if (angle < -8500 && angle > -9000) {
                angle = -8500;
            } else if (angle < -9000 && angle > -9500) {
                angle = -9500;
            } else if (angle > 2650 && angle < 2700) {
                angle = 2650;
            } else if (angle < -2650 && angle > -2700) {
                angle = -2650;
            }else if (angle > 2700 && angle < 2750) {
                angle = 2750;
            } else if (angle < -2700 && angle > -2750) {
                angle = -2750;
            } 

            flowerSvg = NDUtils.replaceFirst(flowerSvg, "<!--azi-->", string.concat(NDUtils.renderDecimal(angle), "deg"));
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "<!--alt-->", string.concat(NDUtils.renderDecimal(altitude), "deg"));
            if(flowerType == FlowerType.GENTIAN) {
                  flowerSvg = NDUtils.replaceFirst(flowerSvg, "<!--aziStick-->", string.concat(NDUtils.renderDecimal(angle), "deg"));
            }
        }

        if(hasPot) {
            if (flowerType == FlowerType.ROSE) {
                flowerSvg = string.concat('<g transform="translate(0 32)"><polygon fill="#d7e0a7" points="-7 -73 7 -73 19 3 -19 3 -7 -73" />', flowerSvg, '</g>');
            } else {
                flowerSvg = string.concat('<rect y="-15"  fill="#d7e0a7" x="-25"  width="50" height="50" /><rect y="-5" fill="#aa7035" width="30" height="10" x="-15" />', flowerSvg);
            }
             flowerSvg = string.concat('<g id="fg">', flowerSvg, '</g>');
        } else {
            flowerSvg = string.concat('<g id="fs">', flowerSvg, '</g>');
        }


        return flowerSvg;
    }

    function computeStarttime(
        uint timestamp,
        AssetInScene memory asset,
        string memory salt,
        uint sunrise,
        uint sunset,
        bool isMoving
    ) public pure returns (uint[] memory) {

 
         uint visibleCount = 0;
         uint[] memory visibleStartTimes;
        
        {
        uint minStartTime = timestamp - asset.maxDuration - asset.possibleOffset;
        uint maxStartTime = timestamp;
         bool isTimeFrameValid = true;
          if (asset.dayTime != DAYTIME.NIGHT_AND_DAY) {

            sunrise = sunrise / 1e18;
            sunset = sunset / 1e18;

            (minStartTime, maxStartTime, isTimeFrameValid) = adjustTimeStampsForAssetVisibility(minStartTime, maxStartTime, sunrise, sunset, asset.dayTime, 0, asset.maxDuration);
            if (!isTimeFrameValid) {
                return new uint[](0);
            }
        }  
    
        
        uint lastCheckTimestamp = maxStartTime - (maxStartTime % asset.checkInterval);
        uint firstCheckTimestamp = minStartTime - (minStartTime % asset.checkInterval);
        uint checkCount = uint(lastCheckTimestamp - firstCheckTimestamp) / uint(asset.checkInterval) + 1;

        visibleStartTimes = new uint[](checkCount);
       

         
         for (uint i = 0; i < checkCount; i++) {
            uint checkTimestamp = uint(firstCheckTimestamp) + i * uint(asset.checkInterval);
            string memory startTimeSalt = string.concat(salt, checkTimestamp.toString());

            if (NDUtils.randomNum(startTimeSalt, 0, 100) < uint(asset.probability)) {
            
                uint startTime = uint(checkTimestamp) + NDUtils.randomNum(startTimeSalt, 0, uint(asset.possibleOffset));
                uint endTime = startTime + NDUtils.randomNum(startTimeSalt, uint(asset.minDuration), uint(asset.maxDuration));
                if (startTime <= timestamp && endTime +  (isMoving? (asset.minDuration / 3) : 0) >= timestamp && uint(startTime) >= uint(minStartTime)) {
                    visibleStartTimes[visibleCount] = startTime;
                    visibleCount++;
                }
            }
        } 
        }
        uint[] memory actualVisible = new uint[](visibleCount);
        for (uint i = 0; i < visibleCount; i++) {
            actualVisible[i] = visibleStartTimes[i];
        }

        return actualVisible;
    }

    function adjustTimeStampsForAssetVisibility(
        uint256 minStartTime,
        uint256 maxStartTime,
        uint256 sunriseTime,
        uint256 sunsetTime,
        DAYTIME timeOfDayVisibility,
        uint256 tolerance,
        uint256 maxDuration
    ) public pure returns (uint256, uint256, bool) {

  
        bool isTimeFrameValid = true;

        // Anpassung von minStartTime basierend auf dem Asset-Typ
        if (timeOfDayVisibility == DAYTIME.DAY && minStartTime < sunriseTime) {
            minStartTime = sunriseTime;
        } else if (timeOfDayVisibility == DAYTIME.NIGHT && minStartTime > sunsetTime) {
            minStartTime = sunsetTime;
        }

        // Berechnung der Toleranzzeit
        uint256 toleranceTime = maxDuration * tolerance / 100;

        // Anpassung von maxStartTime und Überprüfung der Gültigkeit des Zeitrahmens
        if (timeOfDayVisibility == DAYTIME.DAY) {
            uint256 latestStartTimeForDayAsset = sunsetTime - maxDuration + toleranceTime;
            if (maxStartTime > latestStartTimeForDayAsset) {
                maxStartTime = latestStartTimeForDayAsset;
            }
            if (minStartTime > maxStartTime) {
                isTimeFrameValid = false;
            }
        } else if (timeOfDayVisibility == DAYTIME.NIGHT) {
            uint256 latestStartTimeForNightAsset = sunriseTime - maxDuration + toleranceTime;
            if (maxStartTime > latestStartTimeForNightAsset) {
                maxStartTime = latestStartTimeForNightAsset;
            }
            if (minStartTime > maxStartTime) {
                isTimeFrameValid = false;
            }
        }

        return (minStartTime, maxStartTime, isTimeFrameValid);
    }


        function renderLighthouse(string memory svg, int altitude, uint timestamp) public pure returns ( string memory) {

            if (altitude > 0) {
                return svg;
            }

            uint rotationInSeconds = 40;
            uint progress = timestamp % rotationInSeconds * 100 / rotationInSeconds;
            uint rotation = progress * 2 * 31415926535897932;

            int xValue = Trigonometry.sin(rotation) * 810;

            int yValue = 10 + Trigonometry.cos(rotation) * 68 + (68 * 1e18);

            string memory xDec = NDUtils.renderDecimal(xValue / 1e16);
            string memory yDec = NDUtils.renderDecimal(yValue / 1e16);

 

            string memory lightHouse =  string.concat('<polygon opacity="0.2" fill="#fff" points="' , xDec, ',', yDec, ',0,0,', xDec,',-',yDec, '"/>');
            return NDUtils.replaceFirst(svg, "<!--light-->", lightHouse);


        }

     function renderAirplanes(        
        uint timestamp, 
        uint tokenId, uint horizonInPx) public view returns (string memory) {

            string memory salt = tokenId.toString();

            string memory aeroplanes = renderMovingAsset(timestamp, salt, "aeroplane", false, 0, horizonInPx - 30, false, 100, 100, 120, 120, 50, 60 );
            string memory flock = renderMovingAsset(timestamp, salt, "flock", false, 30, horizonInPx - 30, false, 100, 100, 300, 300, 50, 90 ); 
            string memory assetsSVG = string.concat(aeroplanes, flock);
            return assetsSVG;
        }

    function renderSunclock(string memory svg, int azimuth, int altitude, int heading) public view returns (string memory) {

        if (altitude < 0) {
            svg = NDUtils.replaceFirst(svg, "$s", "");
            return svg;
        }

    
        int256 angle = getDiffAngle(azimuth, heading);

        int angleRad = angle * int(TO_RAD) / 1e4;

        int cosOfAngle = NDUtils.abs(Trigonometry.cos(angleRad) / 1e14 );

        int cosAngleAdjustment = 6000 +  (50000000/cosOfAngle); 

        int shadowLength = cosAngleAdjustment * 30;

        shadowLength = shadowLength > 1000000 ? int(1000000) : shadowLength;
        shadowLength /= 1e2;
        angle /= 1e2;

        string memory shadowSVG = string.concat('<rect x="817" y="664" opacity="0.6" fill="#649624" width="3.6" height="', NDUtils.renderDecimal(shadowLength) ,'" transform="rotate(', NDUtils.renderDecimal(angle), ' 819 664)"/>');
    
        svg = NDUtils.replaceFirst(svg, "$s", shadowSVG);
        return svg;
    }



    function generateClouds(int skyHeight, uint nonce) public pure returns (string memory) {
        uint numClouds = NDUtils.randomNum(nonce++, 1, 5);
        string memory clouds = '';
        for (uint i = 0; i < numClouds; i++) {

            uint layers = NDUtils.randomNum(nonce++, 1, 2);
            uint y = NDUtils.randomNum(nonce++, 0, uint(skyHeight));
            int baseX = int(NDUtils.randomNum(nonce++, 0, 1090)) - 10;
      
            for (uint j = 0; j < layers; j++) {
                int x = int(NDUtils.randomNum(nonce++, 10, 50));
                // shuffle whetver x is positive or negative
                if (NDUtils.randomNum(nonce++, 0, 1) == 1) {
                    x = -x;
                }
                x += baseX;
                uint width = NDUtils.randomNum(nonce++, 80, 100);
                uint height = 30;

                //concat clouds in one string
                clouds = string.concat(clouds, '<path fill="#FFF" d="M', x.toStringSigned(), ' ', y.toString(), 'h', width.toString(), 'v', height.toString(), 'H', x.toStringSigned(), 'z"/>');
                y += height;
            }
        } 
        clouds = string.concat('<g opacity="0.8">', clouds, '</g>');
        return clouds;
    }





}