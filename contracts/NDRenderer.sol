

import "@openzeppelin/contracts/utils/Strings.sol";

//import "./NDAlgos.sol";
import "./BasicMotif.sol";
//import "./Assets.sol";

import "hardhat/console.sol";


library NDRenderer {
using Strings for uint256;
using Strings for int256;
using Strings for int16;

int constant viewingRangeHorizontal = 120 * 1e4;
int constant viewingRangeVertical = 60 * 1e4;
int constant skyWidth = 1080 * 1e4;

uint256 constant TO_RAD = 17453292519943296;
uint256 constant TO_DEG = 57295779513224454144;

 struct SkyColor {
        int altitude;
        string color;
    }

    struct SceneElement {
        uint y;
        string svg;
    }

    struct BestPath {
        uint[] path;
        uint distance;
        uint[] distances;
    }



    function renderReplacements(string memory svg, Replacement[] memory replacements) public pure returns (string memory) {
        for (uint i = 0; i < replacements.length; i++) {
        Replacement memory replacement = replacements[i];
        string memory replacementSvg = "";
        if (replacement.tag == ObjectType.USE) {
            uint iterationStep = (replacement.dataType == RenderDataType.POSITIONS) ? 2 : 
                                  (replacement.dataType == RenderDataType.POSISTIONSANDSCALE) ? 3 : 4;

            for (uint j = 0; j < replacement.data.length; j += iterationStep) {
                int x = replacement.data[j];
                int y = replacement.data[j + 1];
                string memory scaleX = replacement.dataType == RenderDataType.POSITIONS ? "1" : renderDecimal(int(replacement.data[j + 2]));
                string memory scaleY = replacement.dataType == RenderDataType.POSITIONSANDTWOSCALES ? renderDecimal(int(replacement.data[j + 3])) : scaleX;

                replacementSvg = string.concat(replacementSvg, '<use href="#',
                        string(abi.encodePacked(replacement.ref)), '" transform="translate(',
                        x.toStringSigned(), ', ', y.toStringSigned(), ') scale(', scaleX, ', ', scaleY, ')" />');
                
            }
        }

        svg = replace(svg, string(abi.encodePacked("<!--", replacement.placeholder, "-->")), replacementSvg);
    }
    return svg;
}




    function renderMainScene(string memory svg, int lat, int lng, uint256 timestamp, uint256 tokenID, SceneInMotif[] memory scenes) public pure returns (string memory) {
        string memory nightMaskSvg = "";

        for (uint i = 0; i < scenes.length; i++) {
            SceneInMotif memory scene = scenes[i];
  

            (string memory sceneSvg, string memory sceneMaskSvg) = renderSceneAssets(scene.assets, timestamp, tokenID, scene.area, lat, lng);
   
            svg = replaceFirst(svg,string.concat("<!--", scene.placeHolder, "-->" ), sceneSvg);
            nightMaskSvg = string.concat(nightMaskSvg, sceneMaskSvg);
        }

        svg = replaceFirst(svg, "<!--maskedassets-->", nightMaskSvg);
        return svg;
    }

    function renderSceneAssets(AssetInScene[] memory assets, uint256 timestamp, uint256 tokenID, int256[4] memory area, int lat, int lng) public pure returns (string memory sceneSvg, string memory sceneMaskSvg) {
         
        SceneElement [] memory elements = new SceneElement[](assets.length);
        sceneMaskSvg = "";

             

        for (uint i = 0; i < assets.length; i++) {
            AssetInScene memory asset = assets[i];

            string memory assetSalt = string(abi.encodePacked(tokenID.toString(), asset.name));
            uint[] memory visibleStartTimes = computeStarttime(timestamp, asset.checkInterval , asset.minDuration, asset.maxDuration, asset.possibleOffset, asset.probability, assetSalt, asset.dayTime , lat,lng);

            console.logUint(visibleStartTimes.length);
            for (uint i2 = 0; i2 < visibleStartTimes.length; i2++) {



                
                uint startTime = visibleStartTimes[i2];
               


                string memory assetSvg = "";
                {
                string memory posSalt = string(abi.encodePacked(startTime.toString(), asset.name));
                uint256 y = uint(area[1]) + randomNum(posSalt, 0, uint(area[3]));
                uint256 x = uint(area[0]) + randomNum(posSalt, 0, uint(area[2]));

                assetSvg = string.concat('<use fill="<!--rdColor-->" href="#',asset.name, '" transform="translate(', x.toString(), ',', y.toString(), ') scale(1, 1)"/>');

                assetSvg = setRandomColor(assetSvg, posSalt);

                elements[i] = SceneElement(y, assetSvg);

                string memory maskName = string.concat(asset.name, "Mask");
                sceneMaskSvg = string.concat(sceneMaskSvg, '<use href="#', maskName, '" transform="translate( ', x.toString(),',', y.toString(), ') scale(1, 1)"/>');
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
        uint[] memory visibleStartTimes = computeStarttime(timestamp, int(checkInterval), int(duration), int(duration), int(possibleOffset), int(appearanceProbability), assetSalt, DAYTIME.NIGHT_AND_DAY , 0, 0);

        string memory assets;
        for (uint i = 0; i < visibleStartTimes.length; i++) {
            uint startTime = (visibleStartTimes[i]);
            int progress = int(timestamp - startTime) / int(duration);

            if (progress >= -30 && progress <= 130) {
                string memory visibleAssetSalt = string(abi.encodePacked(salt, startTime.toString()));
                uint y = randomNum(visibleAssetSalt, minY, maxY);
                int8 direction = int8(randomNum(visibleAssetSalt, 0, 1) == 0 ? -1 : int8(1));
                uint maxX = 1080;
                int x = direction == -1 ? int(maxX) * progress : int(maxX) * (1 - progress);
                uint scaleFac = maxScale - minScale;
                uint relativeY = (y - minY) / (maxY - minY);
                uint scale = horizontUp ? (relativeY + minScale) * maxScale : (1 - relativeY + minScale) * scaleFac;
                string memory assetSvg = string.concat('<use href="#', assetName ,'"fill="<!--rdColor-->" transform="translate(', x.toStringSigned(), ', ', y.toString(), ') scale(', scale.toString() ,') "/>');
                assetSvg = setRandomColor(assetSvg, visibleAssetSalt);

                assets = string.concat(assets, assetSvg);
            }
        }
        return assets;
    }

 
    // function prepareContainerShipSVG(uint timestamp, uint tokenId, Motif memory motif, Seaports.Location [] memory ports) public view returns (string memory) {
    //     uint currentLng;
    //     uint currentLat;
    //     uint currentLookingDirection;
    //     string memory sceneSVG;

    //     //first second of a 30 days interval
    //     uint256 firstSecond = timestamp - (timestamp % 2592000);
    //     //first second of 30 days interval before
    //     uint256 firstSecondLastMonth = firstSecond - 2592000;

    //     uint256 speed = 40;

    //     uint firstPortIndex = randomNum(firstSecondLastMonth + tokenId,0,36);
    //     uint secondPortIndex = randomNum(firstSecond + tokenId,0,36);

    //   //  NDAlgos.BestPath memory bestPath = NDAlgos.findClosestPathToDistance(ports, firstPortIndex, secondPortIndex, 2000000);

    //     return "";

        

    // } 






     function renderSun(string memory svg, uint skyHeight, int azimuth, int altitude, uint lookingDirection) public pure returns (string memory) {
        if (altitude > -120000 && altitude <= viewingRangeVertical + 120000) {
            int diffAngle = int(azimuth) - int(lookingDirection) + 1800000;
            diffAngle = (diffAngle % 3600000) - 1800000;
            console.logInt(diffAngle);
            if (diffAngle < int(viewingRangeHorizontal) / 2 && diffAngle > - viewingRangeHorizontal / 2) {
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

                return replaceFirst(svg, "<!--sun-->", sun);
            }
        }
        return svg;
    }

        function renderMoon(string memory svg, int lookingDirection, int skyHeight, int azimuth, int altitude, int pa, int fraction, int angle) public pure returns (string memory) {


             if (altitude > -120000 && altitude <= viewingRangeVertical + 120000) {
            int diffAngle = int(azimuth) - int(lookingDirection) + 1800000;
            diffAngle = (diffAngle % 3600000) - 1800000;
            int moonRadius = 580000;

            if (diffAngle < int(viewingRangeHorizontal) / 2 && diffAngle > - viewingRangeHorizontal / 2) {
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

                string memory moon = string.concat('<g><path transform="rotate(', renderDecimal(zenitMoonangle), ' ', renderDecimal(x + moonRadius), ' ', 
                renderDecimal(y), ')" stroke="white" shapeRendering="geometricPrecision" fill="white" d="M ', renderDecimal(x), ' ', renderDecimal(y), ' a ',
                renderDecimal(moonRadius), ' ', renderDecimal(moonRadius), ' 0 0 1 ', renderDecimal(moonRadius * 2), ' 0 a ', renderDecimal(moonRadius), ' ',
                renderDecimal(terminatorRadius), ' 0 ', isCrescent ? '1' : '0', ' ', isGibbos ? '1' : '0', ' ', renderDecimal(-moonRadius * 2), ' 0 z"></path></g>');

                return replaceFirst(svg, "<!--moon-->", moon);

            }
        }

        return svg;
    }

       function applyNight(string memory svg, int256 altitude) public pure returns (string memory) {
        // Konstanten in e18
        int256 altitudeThresholdForFullNight = -180000;
        int256 opacityFactor = 22 * 1e18;

        uint256 opacity;
        if (altitude < altitudeThresholdForFullNight) {
            opacity = 100; 
        } else if (altitude < 0 && altitude > altitudeThresholdForFullNight) {
            opacity =  uint(altitude *  - opacityFactor / 1e16);
        } else {
            opacity = 0; 
        }

       
        string memory opacityString = renderDecimal(int256(opacity));

        string memory night = string.concat(
            '<rect mask="url(#nightMask)" style="mix-blend-mode:multiply" width="100%" height="100%" fill="#0F3327" opacity=',
            opacityString,
            '></rect>'
        );

        return replaceFirst(svg, "<!--night-->", night);
    }




     function randomNum(string memory nonce, uint256 min, uint256 max) public pure returns (uint) {
        require(min <= max, "min>max");
        uint randomValue = uint(keccak256(abi.encodePacked( nonce)));
        return min + (randomValue % (max - min + 1));
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

        return replace(svgTemplate, string.concat("<!--", placeholder, "-->"), useTags);
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
        return replace(svg, "<!--rdColor-->", rdColor);
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

    function setSkyColor(string memory svg, int altitude) internal pure returns (string memory) {
        
        string memory cColor = '#000000'; 
        SkyColor[10] memory skyColors = [
            SkyColor(-9000, '#ce80ff'),
            SkyColor(-1200, '#ce80ff'),
            SkyColor(-700, '#e780c0'),
            SkyColor(-400, '#ff8080'),
            SkyColor(0, '#ff9986'),
            SkyColor(300, '#ffb28c'),
            SkyColor(700, '#ffd986'),
            SkyColor(1100, '#ffff80'),
            SkyColor(1500, '#c0eac0'),
            SkyColor(2500, '#80d5ff')
      
        ];

        for (uint i = 0; i < skyColors.length; i++) {
            if (altitude >= skyColors[i].altitude) {
                if (i == skyColors.length - 1) {
                    cColor = skyColors[i].color;
                    break;
                }
                else if (altitude < skyColors[i + 1].altitude) {
                    cColor = skyColors[i].color;
                    break;
                }
            }
        }

        //can never happen        
        return replace(svg, "<!--skycolor-->", cColor);
    }

     function renderSunFlower(string memory svg, int256 azimuth, int256 altitude, int256 lookingDirection) public pure returns (string memory) {
        
        string memory fullBlossom;
        string memory fullFlowerStick;
        {

        int16[2] memory petalRotationAnchor = [int16(0), int16(-75)];
        string memory flowerStick = '<g fill="#9bb224"><rect x="-4" y="-74" width="8" height="74"/><!--leaf--></g>';
        string memory blossom = '<g style="transform: rotateY(<!--azi-->) rotateX(<!--alt-->); transform-box:fill-box; transform-origin:center"><g fill="gold"><path d="M21-85C28-91 28-102 28-102C28-102 18-102 11-95C5-89 5-78 5-78C5-78 15-79 21-85Z" id="sunPetal"/><!--sunPetal--></g><circle fill="<!--fcolor-->" cx="0" cy="-75" r="<!--fradius-->"></circle></g>';
        int[] memory petalRotations = bytesToIntArray(hex"001E003C005A0078009600B400D200F0010E012C014A", 2);
        int16[] memory leafPos = new int16[](2);
        // //[-3, 71]
        leafPos[0] = -3;
        leafPos[1] = 71;


        // Petals und Flower Stick generieren
        fullBlossom = setUseRotations(blossom, "sunPetal", petalRotations, petalRotationAnchor);
        fullFlowerStick = setUseTags(flowerStick, "sunPetal", leafPos , false, "leaf");

        }

        uint256 frontRadius = 18;
        string memory frontColor = "#aa7035";
        uint256 backRadius = 26;
        string memory backColor = "#9bb224";
       
        altitude = altitude > 8500 ? int(8500) : altitude;
        int256 angle = azimuth - lookingDirection;
        string memory flowerSvg;

        if (altitude <= 0) {
            flowerSvg = string(abi.encodePacked(fullFlowerStick, fullBlossom));
            flowerSvg = replace(flowerSvg, "<!--fradius-->", frontRadius.toString());
            flowerSvg = replace(flowerSvg, "<!--fcolor-->", frontColor);
            flowerSvg = replace(flowerSvg, "<!--azi-->", "0");
            flowerSvg = replace(flowerSvg, "<!--alt-->", "0");
        } else {
            if (abs(angle) >= 9000) {
                flowerSvg = string(abi.encodePacked(fullFlowerStick, fullBlossom));
                flowerSvg = replace(flowerSvg, "<!--fradius-->", frontRadius.toString());
                flowerSvg = replace(flowerSvg, "<!--fcolor-->", frontColor);
            } else {
                flowerSvg = string(abi.encodePacked(fullBlossom, fullFlowerStick));
                flowerSvg = replace(flowerSvg, "<!--fradius-->", backRadius.toString());
                flowerSvg = replace(flowerSvg, "<!--fcolor-->", backColor);
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
            }

            flowerSvg = replaceFirst(flowerSvg, "<!--azi-->", string.concat(renderDecimal(angle), "deg"));
            flowerSvg = replaceFirst(flowerSvg, "<!--alt-->", string.concat(renderDecimal(altitude), "deg"));
        }

        return replaceFirst(svg, "<!--flower-->", flowerSvg);
    }

    function computeStarttime(
        uint timestamp,
        int checkInterval,
        int minDuration,
        int maxDuration,
        int possibleOffset,
        int appearanceProbability,
        string memory salt,
        DAYTIME dayNight,
        int lat,
        int lng
   //     uint sunrise,
     //   uint sunset
    ) public pure returns (uint[] memory) {

        int minStartTime = int(timestamp) -(maxDuration - possibleOffset);
        int maxStartTime = int(timestamp);
        bool isTimeFrameValid = true;
        
        {
        // Anpassung der Zeitstempel basierend auf Sonnenauf- und -untergang
        /*  if (dayNight != DAYTIME.NIGHT_AND_DAY) {
            (minStartTime, maxStartTime, isTimeFrameValid) = adjustTimeStampsForAssetVisibility(minStartTime, maxStartTime, sunrise, sunset, dayNight, 0, maxDuration);
            if (!isTimeFrameValid) {
                return new uint[](0);
            }
        }  */
        }
        int lastCheckTimestamp = maxStartTime - (maxStartTime % checkInterval);
        int firstCheckTimestamp = minStartTime - (minStartTime % checkInterval);
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

    function generateClouds(string memory svg, int skyHeight, uint nonce) public pure returns (string memory) {
        uint numClouds = randomNum(nonce++, 1, 10);
        string memory clouds = '';
        for (uint i = 0; i < numClouds; i++) {

            uint layers = randomNum(nonce++, 1, 2);
            uint y = randomNum(nonce++, 0, uint(skyHeight));
            int baseX = int(randomNum(nonce++, 0, 1090) - 10);
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
                clouds = string.concat(clouds, '<g><path fill="#FFF" d="M', x.toStringSigned(), ' ', y.toString(), 'h', width.toString(), 'v', height.toString(), 'H', x.toStringSigned(), 'z"/></g>');
                y += height;
            }
        } 

        return replaceFirst(svg, "<!--clouds-->", clouds);
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


/*      function bytes5ToString(bytes5 _bytes) public pure returns (string memory) {
        // Bestimmen der tatsächlichen Länge des bytes5 (Null-Bytes am Ende ignorieren)
        uint8 actualLength = 0;
        for (uint8 i = 0; i < 5; i++) {
            if (_bytes[i] == 0) {
                break;
            }
            actualLength++;
        }

        // Erstellen eines neuen bytes-Arrays der tatsächlichen Länge und Konvertieren
        bytes memory buffer = new bytes(actualLength);
        for (uint8 i = 0; i < actualLength; i++) {
            buffer[i] = _bytes[i];
        }

        return string(buffer);
    } */

function bytesToIntArray(bytes memory data, uint8 bytesPerInt) public pure returns (int256[] memory) {
    require(data.length % bytesPerInt == 0, "Invalid data length");

    uint256 intArrayLength = data.length / bytesPerInt;
    int256[] memory intArray = new int256[](intArrayLength);

    for (uint256 i = 0; i < data.length; i += bytesPerInt) {
        int256 value;
        if (bytesPerInt == 2) {
            value = int256(uint(uint16(uint8(data[i])) << 8 | uint16(uint8(data[i + 1]))));
        } else if (bytesPerInt == 4) {
            value = int256(uint(uint32(uint8(data[i])) << 24 | uint32(uint8(data[i + 1])) << 16 | uint32(uint8(data[i + 2])) << 8 | uint32(uint8(data[i + 3]))));
        } else {
            revert("Unsupported number of bytes per integer");
        }

        intArray[i / bytesPerInt] = value;
    }

    return intArray;
}



        /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   BYTE STRING OPERATIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    // For performance and bytecode compactness, all indices of the following operations
    // are byte (ASCII) offsets, not UTF character offsets.

    /// @dev Returns `subject` all occurrences of `search` replaced with `replacement`.
    function replace(string memory subject, string memory search, string memory replacement)
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
                    // Whether the first `searchLength % 32` bytes of
                    // `subject` and `search` matches.
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
                        if searchLength {
                            if iszero(lt(subject, subjectSearchEnd)) { break }
                            continue
                        }
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

function renderDecimal(int256 value) public pure returns (string memory) {
        int256 integerPart = value / 100;
        int256 decimalPart = abs(value % 100);

        return string.concat(
            integerPart.toStringSigned(),
            ".",
            padZeroes(decimalPart.toStringSigned(), 2)
        );
    }



    function padZeroes(string memory number, uint256 length) private pure returns (string memory) {
        while(bytes(number).length < length) {
            number = string.concat("0", number);
        }
        return number;
    }

   
}