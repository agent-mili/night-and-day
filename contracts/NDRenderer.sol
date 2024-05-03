pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Strings.sol";

//import "./NDAlgos.sol";
import "./BasicMotif.sol";
//import "./Assets.sol";

import "./SunCalc.sol";




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


    function renderReplacements(string memory svg, Replacement[] memory replacements) public pure returns (string memory) {
        for (uint i = 0; i < replacements.length; i++) {
        Replacement memory replacement = replacements[i];
        string memory replacementSvg;
        if (replacement.tag == ObjectType.USE) {
            uint iterationStep = (replacement.dataType == RenderDataType.POSITIONS) ? 2 : 
                                  (replacement.dataType == RenderDataType.POSISTIONSANDSCALE) ? 3 : 4;

            for (uint j = 0; j < replacement.data.length; j += iterationStep) {
                int x = replacement.data[j];
                int y = replacement.data[j + 1];
                string memory scaleX = replacement.dataType == RenderDataType.POSITIONS ? "1" : renderDecimal(int(replacement.data[j + 2]));
                string memory scaleY = replacement.dataType == RenderDataType.POSITIONSANDTWOSCALES ? renderDecimal(int(replacement.data[j + 3])) : scaleX;

                replacementSvg = string.concat(replacementSvg, '<use href="#',
                        replacement.ref,'" transform="translate(',
                        x.toStringSigned(), ', ', y.toStringSigned(), ') scale(', scaleX, ', ', scaleY, ')" />');
                
            }
        }

        svg = replaceFirst(svg, string.concat("<!--", replacement.placeholder, "-->"), replacementSvg);
    }
    return svg;
}




    function renderMainScene(string memory svg, uint256 timestamp, uint256 tokenID, SceneInMotif[] memory scenes, AssetInScene[] memory assetsInScene, uint sunrise, uint sunset) public pure returns (string memory, string memory) {
        string memory nightMaskSvg = "";

        for (uint i = 0; i < scenes.length; i++) {
            SceneInMotif memory scene = scenes[i];
  

            (string memory sceneSvg, string memory sceneMaskSvg) = renderSceneAssets(scene.assets,assetsInScene, timestamp, tokenID, scene.area, scene.scale, sunrise, sunset);
   
            svg = replaceFirst(svg,string.concat("<!--", scene.placeHolder, "-->" ), sceneSvg);
            nightMaskSvg = string.concat(nightMaskSvg, sceneMaskSvg);
        }

        return (svg, nightMaskSvg);
    }

    function renderSceneAssets(uint8[] memory assetIds,  AssetInScene[] memory assets, uint256 timestamp, uint256 tokenID, int256[4] memory area,uint scale,uint sunrise, uint sunset) public pure returns (string memory sceneSvg, string memory sceneMaskSvg) {
         
        SceneElement [] memory elements = new SceneElement[](assets.length);
        sceneMaskSvg = "";

            
        for (uint i = 0; i < assetIds.length; i++) {
            uint allAssetIndex = 0;
            uint8 assetId = assetIds[i];
            AssetInScene memory asset = assets[assetId];


            string memory assetSalt = string.concat(tokenID.toString(), asset.name);
            uint[] memory visibleStartTimes = computeStarttime(timestamp, asset.checkInterval , asset.minDuration, asset.maxDuration, asset.possibleOffset, asset.probability, assetSalt, asset.dayTime , sunrise, sunset);

            for (uint i2 = 0; i2 < visibleStartTimes.length; i2++) {

                uint startTime = visibleStartTimes[i2];
                string memory assetSvg = "";
                {
                string memory posSalt = string(abi.encodePacked(startTime.toString(), asset.name));
                uint256 y = uint(area[1]) + randomNum(posSalt, 0, uint(area[3]));
                uint256 x = uint(area[0]) + randomNum(posSalt, 0, uint(area[2]));
                int xScale = randomNum(posSalt, 0,1)  == 0 ? int(1): int(-1);
                assetSvg = string.concat('<use fill="<!--rdColor-->" href="#',asset.name, '" transform="translate(', x.toString(), ',', y.toString(), ') scale(', renderDecimal(int(xScale *  int(scale))), ' '  , renderDecimal(int(scale)), ')"/>');

                assetSvg = setRandomColor(assetSvg, posSalt);

                elements[allAssetIndex] = SceneElement(y, assetSvg);
                allAssetIndex++;
                

                string memory maskName = string.concat(asset.name, "-mask");
                sceneMaskSvg = string.concat(sceneMaskSvg, '<use href="#', maskName, '" filter="url(#makeBlack)" transform="translate( ', x.toString(),',', y.toString(), ') scale(', renderDecimal(int(xScale * int(scale))), ' ' , renderDecimal(int(scale)),')"/>');
                }
        }
        }

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

       

        for (uint i = 0; i < elements.length; i++) {
            sceneSvg = string.concat(sceneSvg, elements[i].svg);
        }


        return (sceneSvg, sceneMaskSvg);
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
    ) public pure returns (string memory) {
        string memory assetSalt = string(abi.encodePacked(salt, assetName));
        uint[] memory visibleStartTimes = computeStarttime(timestamp, checkInterval, duration, duration, possibleOffset, appearanceProbability, assetSalt, DAYTIME.NIGHT_AND_DAY , 0, 0);

        string memory assets;
        for (uint i = 0; i < visibleStartTimes.length; i++) {
            uint startTime = (visibleStartTimes[i]);

            int progress = int(timestamp - startTime) * 100 / int(duration);

       

            if (progress >= -30 && progress <= 130) {
                string memory visibleAssetSalt = string(abi.encodePacked(salt, startTime.toString()));
                uint y = randomNum(visibleAssetSalt, minY, maxY);
                int direction = int8(randomNum(visibleAssetSalt, 0, 1) == 0 ? -1 : int8(1));
                uint maxX = 1080;
                int x = direction == -1 ? int(maxX) * progress / 100 : int(maxX) * (100 - progress) / 100;

                uint scaleFac = maxScale - minScale;
                uint relativeY = (y - minY) * 100 / (maxY - minY);
                uint scale = horizontUp ? (relativeY + minScale ) * maxScale / 100 : (100 - relativeY + minScale) * scaleFac / 100;
               
                string memory assetSvg;
                if (hasRandomColor)
                {
                    assetSvg = string.concat('<use href="#', assetName ,'" fill="<!--rdColor-->" transform="translate(', x.toStringSigned(), ', ', y.toString(), ') scale(', renderDecimal(int(int(scale) * direction)) , ' ', renderDecimal(int(scale)), ') "/>');
                    assetSvg = setRandomColor(assetSvg, visibleAssetSalt);
                } else {
                    assetSvg = string.concat('<use href="#', assetName ,'" transform="translate(', x.toStringSigned(), ', ', y.toString(), ') scale(', renderDecimal(int(int(scale) * direction)) , ' ', renderDecimal(int(scale)), ') "/>');
                }

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
                "<g> <circle cx='", renderDecimal(x), 
                    "' cy='", renderDecimal(y), 
                    "' r='58' fill='#fff' /> <circle cx='", 
                   renderDecimal(x), "' cy='", 
                    renderDecimal(y), 
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
                string memory moon = string.concat('<g mask="url(#moonMask', motifTypestring ,')"><path transform="rotate(', renderDecimal(zenitMoonangle), ' ', renderDecimal(x + moonRadius), ' ', 
                renderDecimal(y), ')" stroke="white" shapeRendering="geometricPrecision" fill="white" d="M ', renderDecimal(x), ' ', renderDecimal(y), ' a ',
                renderDecimal(moonRadius), ' ', renderDecimal(moonRadius), ' 0 0 1 ', renderDecimal(moonRadius * 2), ' 0 a ', renderDecimal(moonRadius), ' ',
                renderDecimal(terminatorRadius), ' 0 ', isCrescent ? '1' : '0', ' ', isGibbos ? '1' : '0', ' ', renderDecimal(-moonRadius * 2), ' 0 z"></path></g>');

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
            opacity =  uint( abs(altitude) / opacityFactor );
        } else {
            opacity = 0; 
        }

       
        string memory opacityString = renderDecimal(int256(opacity));

        string memory motifTypeString = motifType == MotifType.SIGHT_SEEING ? "S" : "G";

        string memory night = string.concat(
            '<rect mask="url(#nightMask', motifTypeString, ')" style="mix-blend-mode:multiply" width="1080" height="1080" fill="#0F3327" opacity="',
            opacityString,
            '"></rect>'
        );

        
        return night;
    }

    function createStandardAttributes(Motif memory motif, FlowerType flowerType) public pure returns (string memory) {
        string memory attributes;
        
        attributes = string.concat('"attributes": [{"trait_type":"Flower","value":"', flowerType == FlowerType.ROSE ? "Rose" : flowerType == FlowerType.SUNFLOWER ? "Sunflower" : "Gentian", '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Latitude","value":"', renderDecimal(motif.lat, 6), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Longitude","value":"', renderDecimal(motif.lng, 6), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Heading","value":"', motif.heading.toStringSigned(), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Motif Type","value":"', motif.motifType == MotifType.SIGHT_SEEING ? "Sight Seeing" : motif.motifType == MotifType.BEACH ? "Beach" : motif.motifType == 
        MotifType.SKYSCRAPER ? "Sky Scraper" : "Landscape", '"}');

        return attributes;
    }




     function randomNum(string memory nonce, uint256 min, uint256 max) public pure returns (uint) {
        require(min <= max, "min>max");
        uint randomValue = uint(keccak256(abi.encodePacked( nonce)));
        uint result =  min + (randomValue % (max - min + 1));

        return result;
    }

    function randomNum(uint256 nonce, uint256 min, uint256 max) public pure returns (uint) {
        return randomNum(nonce.toString(), min, max);
    }

     function setUseTags(string memory svgTemplate, string memory ref, int16[] memory positions, bool hasScale, string memory placeholder)
        public
        pure
        returns (string memory)
    {
        string memory useTags = "";
        uint256 iterationStep = hasScale ? 3 : 2;

        for (uint256 i = 0; i < positions.length; i += iterationStep) {
            string memory x = positions[i].toStringSigned();
            string memory y = positions[i + 1].toStringSigned();
            string memory scale = hasScale ? positions[i + 2].toStringSigned() : "1";
            
            useTags = string.concat(
                useTags,
                '<use href="#', ref, '" transform="translate(', x, ', ', y, ') scale(', scale, ')" />'
            );
        }

        return replaceFirst(svgTemplate, string.concat("<!--", placeholder, "-->"), useTags);
    } 


    // is used for flowers and few plants
    function setUseRotations(string memory svg, string memory ref, int[] memory rotations, int16[2] memory rotationAnchor) public pure returns (string memory) {
        string memory useTags = "";

        for (uint256 i = 0; i < rotations.length; i++) {
            useTags = string.concat(
                useTags,
                '<use href="#',
               ref,
                '" transform="rotate(',
                int256(rotations[i]).toStringSigned(),
                ' ',
                int256(rotationAnchor[0]).toStringSigned(),
                ' ',
                int256(rotationAnchor[1]).toStringSigned(),
                ')"/>'
            );
        }

        return replaceFirst(svg, string.concat('<!--', ref, '-->'), useTags);
    }



    function setRandomColor(string memory svg, string memory salt) public pure returns (string memory) {


        uint256 rdIndex = randomNum(salt, 0,  16);
        string memory rdColor = getColorByIndex(rdIndex);
        return replaceFirst(svg, "<!--rdColor-->", rdColor);
    }

     function getColorByIndex(uint256 index) internal pure returns (string memory) {
        string[17] memory rdColors = [
            '#fff', '#dbd8e0', '#684193', '#e3cce5', '#fff6cc', 
            '#649624', '#9bb221', '#c3d17c', '#ffd700', '#ffe766', 
            '#fcd899', '#f29104', '#e6342a', '#e94f1c', '#be1823', 
            '#aa7034', '#e94e1b'
        ];

        require(index < rdColors.length, "out of index");
        return rdColors[index];
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

        if (abs(diffAngle) > 1800000) {
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

            flowerSvg = replaceFirst(flowerSvg, "<!--azi-->", "0");
            flowerSvg = replaceFirst(flowerSvg, "<!--alt-->", "0");

            if(flowerType == FlowerType.GENTIAN) {
                  flowerSvg = replaceFirst(flowerSvg, "<!--aziStick-->", "0");
            }
        } else {
            if (abs(angle) >= 9000) {
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

            flowerSvg = replaceFirst(flowerSvg, "<!--azi-->", string.concat(renderDecimal(angle), "deg"));
            flowerSvg = replaceFirst(flowerSvg, "<!--alt-->", string.concat(renderDecimal(altitude), "deg"));
            if(flowerType == FlowerType.GENTIAN) {
                  flowerSvg = replaceFirst(flowerSvg, "<!--aziStick-->", string.concat(renderDecimal(angle), "deg"));
            }
        }

        if(hasPot) {
            if (flowerType == FlowerType.ROSE) {
                flowerSvg = string.concat('<g transform="translate(0 32)"><polygon fill="#fde0ad" points="-7 -73 7 -73 19 3 -19 3 -7 -73" />', flowerSvg, '</g>');
            } else {
                flowerSvg = string.concat('<rect y="-15"  fill="#fde0ad" x="-25"  width="50" height="50" /><rect y="-5" fill="#aa7035" width="30" height="10" x="-15" />', flowerSvg);
            }
        }

        return replaceFirst(svg, "<!--flower-->", flowerSvg);
        //return svg;
    }

    function computeStarttime(
        uint timestamp,
        uint checkInterval,
        uint minDuration,
        uint maxDuration,
        uint possibleOffset,
        uint appearanceProbability,
        string memory salt,
        DAYTIME dayNight,
        uint sunrise,
        uint sunset
    ) public pure returns (uint[] memory) {

        uint minStartTime = timestamp - maxDuration - possibleOffset;
        uint maxStartTime = timestamp;
        bool isTimeFrameValid = true;
        
        {
          if (dayNight != DAYTIME.NIGHT_AND_DAY) {

            sunrise = sunrise / 1e18;
            sunset = sunset / 1e18;

            (minStartTime, maxStartTime, isTimeFrameValid) = adjustTimeStampsForAssetVisibility(minStartTime, maxStartTime, sunrise, sunset, dayNight, 0, maxDuration);
            if (!isTimeFrameValid) {
                return new uint[](0);
            }
        }  
        }
        uint lastCheckTimestamp = maxStartTime - (maxStartTime % checkInterval);
        uint firstCheckTimestamp = minStartTime - (minStartTime % checkInterval);
        uint checkCount = uint(lastCheckTimestamp - firstCheckTimestamp) / uint(checkInterval) + 1;

        uint[] memory visibleStartTimes = new uint[](checkCount);
        uint visibleCount = 0;

         
         for (uint i = 0; i < checkCount; i++) {
            uint checkTimestamp = uint(firstCheckTimestamp) + i * uint(checkInterval);
            string memory startTimeSalt = string(abi.encodePacked(salt, checkTimestamp.toString()));

            if (randomNum(startTimeSalt, 0, 100) < uint(appearanceProbability)) {
            
                uint startTime = uint(checkTimestamp) + randomNum(startTimeSalt, 0, uint(possibleOffset));
                uint endTime = startTime + randomNum(startTimeSalt, uint(minDuration), uint(maxDuration));
                if (startTime <= timestamp && endTime >= timestamp && uint(startTime) >= uint(minStartTime)) {
                    visibleStartTimes[visibleCount] = startTime;
                    visibleCount++;
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

    function generateClouds(int skyHeight, uint nonce) public pure returns (string memory) {
        uint numClouds = randomNum(nonce++, 1, 5);
        string memory clouds = '';
        for (uint i = 0; i < numClouds; i++) {

            uint layers = randomNum(nonce++, 1, 2);
            uint y = randomNum(nonce++, 0, uint(skyHeight));
            int baseX = int(randomNum(nonce++, 0, 1090)) - 10;
      
            for (uint j = 0; j < layers; j++) {
                int x = int(randomNum(nonce++, 10, 50));
                // shuffle whetver x is positive or negative
                if (randomNum(nonce++, 0, 1) == 1) {
                    x = -x;
                }
                x += baseX;
                uint width = randomNum(nonce++, 80, 100);
                uint height = 30;

                //concat clouds in one string
                clouds = string.concat(clouds, '<path fill="#FFF" d="M', x.toStringSigned(), ' ', y.toString(), 'h', width.toString(), 'v', height.toString(), 'H', x.toStringSigned(), 'z"/>');
                y += height;
            }
        } 
        clouds = string.concat('<g opacity="0.8">', clouds, '</g>');
        return clouds;
    }





    /// @notice ATAN2(Y,X) FUNCTION (MORE PRECISE MORE GAS)
    /// @param y y
    /// @param x x
    /// @return T T
    function p_atan2(int256 y, int256 x) public pure returns (int256 T) {
        int256 c1 = 3141592653589793300 / 4;
        int256 c2 = 3 * c1;
        int256 abs_y = y >= 0 ? y : -y;
        abs_y += 1e8;

        if (x >= 0) {
            int256 r = ((x - abs_y) * 1e18) / (x + abs_y);
            T = (1963e14 * r**3) / 1e54 - (9817e14 * r) / 1e18 + c1;
        } else {
            int256 r = ((x + abs_y) * 1e18) / (abs_y - x);
            T = (1963e14 * r**3) / 1e54 - (9817e14 * r) / 1e18 + c2;
        }
        if (y < 0) {
            return -T;
        } else {
            return T;
        }
    }




     /// @dev Returns `subject` with the first occurrence of `search` replaced with `replacement`.
    function replaceFirst(string memory subject, string memory search, string memory replacement)
        internal
        pure
        returns (string memory result)
    {
        /// @solidity memory-safe-assembly
        assembly {
            let subjectLength := mload(subject)
            let searchLength := mload(search)
            let replacementLength := mload(replacement)

            subject := add(subject, 0x20)
            search := add(search, 0x20)
            replacement := add(replacement, 0x20)
            result := add(mload(0x40), 0x20)

            let subjectEnd := add(subject, subjectLength)
            if iszero(gt(searchLength, subjectLength)) {
                let subjectSearchEnd := add(sub(subjectEnd, searchLength), 1)
                let h := 0
                if iszero(lt(searchLength, 32)) { h := keccak256(search, searchLength) }
                let m := shl(3, sub(32, and(searchLength, 31)))
                let s := mload(search)
                for {} 1 {} {
                    let t := mload(subject)
                    if iszero(shr(m, xor(t, s))) {
                        if h {
                            if iszero(eq(keccak256(subject, searchLength), h)) {
                                mstore(result, t)
                                result := add(result, 1)
                                subject := add(subject, 1)
                                if iszero(lt(subject, subjectSearchEnd)) { break }
                                continue
                            }
                        }
                        // Copy the `replacement` one word at a time.
                        for { let o := 0 } 1 {} {
                            mstore(add(result, o), mload(add(replacement, o)))
                            o := add(o, 0x20)
                            if iszero(lt(o, replacementLength)) { break }
                        }
                        result := add(result, replacementLength)
                        subject := add(subject, searchLength)
                        // Break after the first replacement
                        break
                    }
                    mstore(result, t)
                    result := add(result, 1)
                    subject := add(subject, 1)
                    if iszero(lt(subject, subjectSearchEnd)) { break }
                }
            }

            let resultRemainder := result
            result := add(mload(0x40), 0x20)
            let k := add(sub(resultRemainder, result), sub(subjectEnd, subject))
            // Copy the rest of the string one word at a time.
            for {} lt(subject, subjectEnd) {} {
                mstore(resultRemainder, mload(subject))
                resultRemainder := add(resultRemainder, 0x20)
                subject := add(subject, 0x20)
            }
            result := sub(result, 0x20)
            // Zeroize the slot after the string.
            let last := add(add(result, 0x20), k)
            mstore(last, 0)
            // Allocate memory for the length and the bytes,
            // rounded up to a multiple of 32.
            mstore(0x40, and(add(last, 31), not(31)))
            // Store the length of the result.
            mstore(result, k)
        }
    }

    function abs(int x) private pure returns (int) {
    return x >= 0 ? x : -x;
}

function renderDecimal(int256 value, uint decimals) public pure returns (string memory) {
        int256 integerPart = value / int(10 ** decimals);
        int256 decimalPart = abs(value % int(10**decimals));

        return string.concat(
            integerPart.toStringSigned(),
            ".",
            padZeroes(decimalPart.toStringSigned(), 2)
        );
    }

    function renderDecimal(int256 value) public pure returns (string memory) {
        return renderDecimal(value, 2);
    }



    function padZeroes(string memory number, uint256 length) private pure returns (string memory) {
        while(bytes(number).length < length) {
            number = string.concat("0", number);
        }
        return number;
    }

}