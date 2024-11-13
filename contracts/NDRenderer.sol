// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Strings.sol";

//import "./NDAlgos.sol";
import "./BasicMotif.sol";
//import "./Assets.sol";
import "./NDUtils.sol";

import "./solidity-trigonometry/Trigonometry.sol";

import { sqrt} from "@prb/math/src/Common.sol";





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




    struct RenderedScene {
        string sceneSvg;
        string nightMaskSvg;
    }

    struct SceneUtils {
        uint sunrise;
        uint sunset;
        uint timestamp;
        uint tokenId;
    }

    struct SceneIndexes {
        uint i;
        uint i2;
        uint i3;
        uint allAssetIndex;
    }







    function renderMainScene(string memory svg, uint256 timestamp, uint256 tokenID, SceneInMotif[] memory scenes, AssetInScene[] memory assetsInScene, uint sunrise, uint sunset) public pure returns (string memory, string memory) {
        string memory nightMaskSvg = "";
        SceneUtils memory sceneUtils = SceneUtils(sunrise, sunset, timestamp, tokenID);

        for (uint i = 0; i < scenes.length; i++) {
            SceneInMotif memory scene = scenes[i];
  

            RenderedScene memory renderedScene = renderSceneAssets(scene,assetsInScene, sceneUtils);
   
            svg = NDUtils.replaceFirst(svg,string.concat("$", scene.placeHolder ), renderedScene.sceneSvg);
            nightMaskSvg = string.concat(nightMaskSvg, renderedScene.nightMaskSvg);
        }

        return (svg, nightMaskSvg);
    }

    function renderExtraMovingAssets(string memory svg, MovingScene[] memory movingScenes, uint timestamp, uint tokenId, SunMoon memory sunMoon)  public pure returns (string memory, string memory) {


            string memory salt = tokenId.toString();
            string memory skySceneSVG;

            for(uint i = 0; i < movingScenes.length; i++) {
                MovingScene memory movingScene = movingScenes[i];
                string memory assetsSVG;

                assetsSVG =  renderMovingAsset(timestamp, string.concat(salt, movingScene.placeholder) , movingScene, sunMoon);
                if (Strings.equal(movingScene.placeholder, "$")) {
                    skySceneSVG = assetsSVG;
                    continue;
                }
                if (Strings.equal(movingScene.placeholder, "bi")) {
                    assetsSVG = string.concat("<g id='bird-group", salt, "'>", assetsSVG, "</g>");
                }
                svg = NDUtils.replaceFirst(svg,string.concat("$", movingScene.placeholder), assetsSVG);

            }

 
           return (skySceneSVG, svg);
        }




        

    function renderSceneAssets(SceneInMotif memory sceneInMotif,  AssetInScene[] memory assets, SceneUtils memory sceneUtils) public pure returns (RenderedScene memory) {
        
        SceneIndexes memory indexes;

        SceneElement [] memory elements = new SceneElement[](20);
        RenderedScene memory renderedScene;
        

        for (indexes.i3 = 0; indexes.i3 < sceneInMotif.sceneDetails.length; indexes.i3++) {
            Scene memory scene = sceneInMotif.sceneDetails[indexes.i3];
            
          
        for (indexes.i = 0; indexes.i < scene.assets.length; indexes.i++) {

            AssetInScene memory asset = assets[scene.assets[indexes.i]];


            string memory assetSalt = string.concat(sceneUtils.tokenId.toString(), asset.name, sceneInMotif.placeHolder, scene.area[0].toStringSigned(), scene.area[1].toStringSigned());
            uint[] memory visibleStartTimes = NDUtils.computeStarttime(sceneUtils.timestamp, asset, assetSalt , sceneUtils.sunrise, sceneUtils.sunset, false);
          
        
            for (indexes.i2 = 0; indexes.i2 < visibleStartTimes.length; indexes.i2++) {
                
                
                 SceneElement memory sceneElement;
                 sceneElement.posSalt = string.concat(visibleStartTimes[indexes.i2].toString(), asset.name, scene.area[0].toStringSigned());
                 sceneElement.y = uint(scene.area[1]) + NDUtils.randomNum(sceneElement.posSalt, 0, uint(scene.area[3]));
                 sceneElement.x = int(scene.area[0]) + int(NDUtils.randomNum(sceneElement.posSalt, 0, uint(scene.area[2])));
                 sceneElement.xScale = NDUtils.randomNum(sceneElement.posSalt, 0,1)  == 0 ? int(1): int(-1);
                 sceneElement.decimalScaleX = NDUtils.renderDecimal(int(sceneElement.xScale * int(scene.scale)));
                sceneElement.decimalScaleY = NDUtils.renderDecimal(int(scene.scale));

                 sceneElement.svg = NDUtils.createElementAndSetColor(sceneElement, asset.name,0);

                 if (indexes.allAssetIndex >= elements.length) {
                    elements = pushElement(elements, indexes.allAssetIndex, sceneElement);
                 } else {
                    elements[indexes.allAssetIndex] = sceneElement;
                    }
                 indexes.allAssetIndex = indexes.allAssetIndex + 1;
                
                
                 asset.dayTime == DAYTIME.DAY ? '' :  renderedScene.nightMaskSvg = string.concat(renderedScene.nightMaskSvg, '<use href="#', string.concat(asset.name, "-mask"), '" filter="url(#makeBlack)" transform="translate( ', sceneElement.x.toStringSigned(),',', sceneElement.y.toString(), ') scale(', sceneElement.decimalScaleX, ' ' , sceneElement.decimalScaleY,')"/>');
                
                
        }
            
         
        }
        }
        
  

        elements = sortElements(elements, true);
        
        
            

        for (indexes.i = 0; indexes.i < elements.length; indexes.i++) {
            renderedScene.sceneSvg = string.concat(renderedScene.sceneSvg, elements[indexes.i].svg);
        }


        return renderedScene;
    }

    function sortElements(SceneElement[] memory elements, bool isAscending) public pure returns (SceneElement[] memory) {
        uint n = elements.length;

        uint validCount = n;
        for (uint i = 0; i < n; i++) {
            if (bytes(elements[i].svg).length == 0) {  
                validCount = i;
                break;
            }
        }

        SceneElement[] memory validElements = new SceneElement[](validCount);
        for (uint i = 0; i < validCount; i++) {
            validElements[i] = elements[i];
        }

        for (uint i = 0; i < validCount; i++) {
            for (uint j = 0; j < validCount - i - 1; j++) {
                if (isAscending ? (validElements[j].y > validElements[j + 1].y) : (validElements[j].y < validElements[j + 1].y)) {
                    SceneElement memory temp = validElements[j];
                    validElements[j] = validElements[j + 1];
                    validElements[j + 1] = temp;
                }
            }
        }

        return validElements;
    }
    function renderMovingAsset(
        uint timestamp, 
        string memory salt, 
        MovingScene memory movingScene,
        SunMoon memory sunMoon
    ) public pure returns (string memory) {

        string memory assets;
        SceneElement [] memory elements = new SceneElement[](20);
        uint allIndex = 0;

    for (uint j = 0; j < movingScene.assets.length; j++) {
        MovingSceneAsset memory movingAsset = movingScene.assets[j];
        string memory assetSalt = string.concat(salt, movingAsset.assetName);

        uint maxDuration = movingAsset.duration * 100 / movingAsset.minScale;

        AssetInScene memory assetInScene = AssetInScene(movingAsset.assetName, maxDuration, maxDuration, movingAsset.checkInterval, movingAsset.possibleOffset, movingAsset.probability, movingAsset.dayTime);
        uint[] memory visibleStartTimes = NDUtils.computeStarttime(timestamp, assetInScene, assetSalt , sunMoon.sunrise, sunMoon.sunset, true);


        for (uint i = 0; i < visibleStartTimes.length; i++) {
            uint startTime = (visibleStartTimes[i]);

                SceneElement memory sceneElement;

                sceneElement.posSalt = string.concat(assetSalt, startTime.toString());
                sceneElement.y = NDUtils.randomNum( sceneElement.posSalt, movingAsset.minY, movingAsset.maxY);

                uint scale;
                if (movingAsset.minScale == movingAsset.maxScale) {
                    scale = movingAsset.minScale;
                } else {
                   uint proportion = (movingAsset.maxScale - movingAsset.minScale) * (sceneElement.y - movingAsset.minY) * 1e18 / (movingAsset.maxY - movingAsset.minY); 
                if (movingScene.horizonUp) {
                    scale = movingAsset.minScale + proportion / 1e18; 
                } else {
                    scale = movingAsset.maxScale - proportion / 1e18; 
                }
                }

            uint duration = movingAsset.duration * 100 / scale;

            int progress = int(timestamp - startTime) * 100 / int(duration);

            if (progress >= -30 && progress <= 160) {
                

                sceneElement.xScale = int8(NDUtils.randomNum( sceneElement.posSalt, 0, 1) == 0 ? -1 : int8(1));
                sceneElement.x = sceneElement.xScale == -1 ? int(1080) * progress / 100 : int(1080) * (100 - progress) / 100;
                sceneElement.decimalScaleX = NDUtils.renderDecimal(int(scale) * sceneElement.xScale);
                sceneElement.decimalScaleY = NDUtils.renderDecimal(int(scale));


                sceneElement.svg = NDUtils.createElementAndSetColor(sceneElement, movingAsset.assetName, timestamp);

                elements = pushElement(elements, allIndex, sceneElement);
                allIndex ++;
            }
        }
    }
        elements = sortElements(elements, movingScene.horizonUp);
        for (uint i = 0; i < elements.length; i++) {
            assets = string.concat(assets, elements[i].svg);
        }
        return assets;
    }

     function renderSun(uint skyHeight, int azimuth, int altitude, uint heading) public pure returns (string memory) {
        
        int sunHeightInDegree = viewingRangeVertical * 1e4 / int(skyHeight)* 95;
        if (altitude > - (sunHeightInDegree * 2) && altitude <= viewingRangeVertical + sunHeightInDegree) {

            int diffAngle = getDiffAngle(azimuth, int(heading));

     
            if (diffAngle < viewingRangeHorizontal / 2 + sunWidthInDegree && diffAngle > - viewingRangeHorizontal / 2 - sunWidthInDegree) {
                int x = (diffAngle +  viewingRangeHorizontal  / 2) * skyWidth / viewingRangeHorizontal;
                int y = int(skyHeight) - altitude * int(skyHeight)  / viewingRangeVertical;

                x = x / 1e2;
                y = y / 1e2;

                string memory decimalX = NDUtils.renderDecimal(x);
                string memory decimalY = NDUtils.renderDecimal(y);

                string memory sun =  string.concat(
                "<g> <circle cx='", decimalX, 
                    "' cy='", decimalY, 
                    "' r='58' fill='#fff' /> <circle cx='", 
                  decimalX, "' cy='", 
                    decimalY, 
                    "' r='95' fill='#fff' opacity='0.26' /></g>"
                );

                return sun;
            }
        }
        return "";
    }

        function renderMoon(uint tokenId, int heading, uint skyHeight, int azimuth, int altitude, int pa, int fraction, int angle ) public pure returns (string memory) {

            int moonWidthInDegree =viewingRangeHorizontal  * 1e4 / skyWidth * 58;
            int moonHeightInDegree = viewingRangeVertical * 1e4 / int(skyHeight) * 58;
                                //fix moonrise in landscape
            if (altitude > -  (moonHeightInDegree *2 ) && altitude <= viewingRangeVertical + moonHeightInDegree) {
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
                string memory decimalMoonRadius = NDUtils.renderDecimal(moonRadius);

                string memory moon = string.concat('<g mask="url(#moonMask', tokenId.toString() ,')"><path transform="rotate(', NDUtils.renderDecimal(zenitMoonangle), ' ', NDUtils.renderDecimal(x + moonRadius), ' ', 
                NDUtils.renderDecimal(y), ')" stroke="white" shapeRendering="geometricPrecision" fill="white" d="M ', NDUtils.renderDecimal(x), ' ', NDUtils.renderDecimal(y), ' a ',
                decimalMoonRadius, ' ', decimalMoonRadius, ' 0 0 1 ', NDUtils.renderDecimal(moonRadius * 2), ' 0 a ', decimalMoonRadius, ' ',
                NDUtils.renderDecimal(terminatorRadius), ' 0 ', isCrescent ? '1' : '0', ' ', isGibbos ? '1' : '0', ' ', NDUtils.renderDecimal(-moonRadius * 2), ' 0 z"></path></g>');

                return moon;

            }
        }

        return "";
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

     function renderFlower(SunMoon memory sunMoon, int256 heading, FlowerType flowerType, FlowerParts memory flowerParts, bool hasPot, uint tokenId) public pure returns (string memory) {
        
        int256 azimuth = flowerType == FlowerType.MOONFLOWER ? sunMoon.moonAzimuth : sunMoon.azimuth;
        int256 altitude = flowerType == FlowerType.MOONFLOWER ? sunMoon.moonAltitude : sunMoon.altitude;

        altitude /= 1e16;
        azimuth /= 1e14;

        
        altitude = altitude > 8500 ? int(8500) : altitude;
        int256 angle = getDiffAngle(azimuth, heading);
        angle /= 1e2;
        string memory flowerSvg;

        string memory transformContainer = '<g style="transform: rotateY($azi) rotateX($alt); transform-box:fill-box;transform-origin:center">';


        if (altitude <= 0) {
            flowerSvg = string.concat(flowerParts.stick, transformContainer, flowerParts.blossom, flowerParts.front , '</g>');

     if(flowerType == FlowerType.ICEFLOWER) {
                  flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azis", "0");
            }
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azi", "0");
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$alt", "0");

       
        } else {
            if (NDUtils.abs(angle) >= 9000) {
                flowerSvg = string.concat(flowerParts.stick, transformContainer, flowerParts.blossom, flowerParts.front, '</g>');

            } else {
                flowerSvg = string.concat(transformContainer, flowerParts.blossom, flowerParts.back, '</g>' ,flowerParts.stick);

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

                 if(flowerType == FlowerType.ICEFLOWER) {
                  flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azis", string.concat(NDUtils.renderDecimal(angle), "deg"));
            }
        }

            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azi", string.concat(NDUtils.renderDecimal(angle), "deg"));
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$alt", string.concat(NDUtils.renderDecimal(altitude), "deg"));
       

        if(hasPot) {
            if (flowerType == FlowerType.ROSE) {
                flowerSvg = string.concat('<g transform="translate(0 32)"><polygon fill="#d7e0a7" points="-7 -73 7 -73 19 3 -19 3 -7 -73" />', flowerSvg, '</g>');
            } else if(flowerType == FlowerType.MOONFLOWER) {
                 flowerSvg = string.concat('<g transform="translate(0 32)">', flowerSvg, '</g>');
            } 
            else {
                flowerSvg = string.concat('<rect y="-15"  fill="#d7e0a7" x="-25"  width="50" height="50" /><rect y="-5" fill="#aa7035" width="30" height="10" x="-15" />', flowerSvg);
            }
        } 
        flowerSvg = string.concat('<g id="fl_',tokenId.toString(),'">', flowerSvg, '</g>');

        return flowerSvg;
    }

        function renderSunclock(string memory svg, int azimuth, int altitude, int heading) public pure returns (string memory) {

        if (altitude < 0) {
            svg = NDUtils.replaceFirst(svg, "$sh", "");
            return svg;
        }
        int256 angle = getDiffAngle(azimuth, heading);
        int radiusX = 100e4;
        int radiusY = 40e4;
        int angleInRadian = (angle + 90e4) * int(TO_RAD) / 1e4; 
        int radiusAtAngle = (radiusX * radiusY) / int(sqrt(uint( radiusX * radiusX /1e4 * Trigonometry.sin(angleInRadian) * Trigonometry.sin(angleInRadian) / 1e36 + radiusY * radiusY / 1e4 * Trigonometry.cos(angleInRadian) * Trigonometry.cos(angleInRadian) / 1e36)));
        int altitudeInRadian = altitude * int(TO_RAD) / 1e2;
        int finalLength = (radiusAtAngle * Trigonometry.cos(altitudeInRadian) / 1e14) / ((Trigonometry.cos(altitudeInRadian) + Trigonometry.sin(altitudeInRadian))/1e14);
        finalLength = finalLength / 1e4;
        angle = angle / 1e2;
        string memory shadowSVG = string.concat('<rect x="817" y="664" opacity="0.6" fill="#649624" width="3.6" height="', NDUtils.renderDecimal(int(finalLength)) ,'" transform="rotate(', NDUtils.renderDecimal(angle), ' 819 664)"/>');
    
        svg = NDUtils.replaceFirst(svg, "$sh", shadowSVG);
        return svg;
    }

    function pushElement(
        SceneElement[] memory array,  
        uint index,             
        SceneElement memory newElement 
    ) public pure returns (SceneElement[] memory) {
        
        if (index >= array.length) {
            SceneElement[] memory newArray = new SceneElement[](index + 1);
                        for (uint i = 0; i < array.length; i++) {
                newArray[i] = array[i];
            }
            newArray[index] = newElement;
            
            return newArray;
        } else {
            array[index] = newElement;
            return array;
        }
    }

    
}