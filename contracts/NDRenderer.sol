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
        bytes6 skyColor;
        bytes6 waterColor;
    }


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

    function renderSceneAssets(SceneInMotif memory scene,  AssetInScene[] memory assets, SceneUtils memory sceneUtils) public pure returns (RenderedScene memory) {
        
        SceneIndexes memory indexes;

        SceneElement [] memory elements = new SceneElement[](assets.length);
        RenderedScene memory renderedScene;
        
        indexes.allAssetIndex = 0;

        
          
        for (indexes.i = 0; indexes.i < scene.assets.length; indexes.i++) {

            AssetInScene memory asset = assets[scene.assets[indexes.i]];


            string memory assetSalt = string.concat(sceneUtils.tokenId.toString(), asset.name, scene.placeHolder);
            uint[] memory visibleStartTimes = NDUtils.computeStarttime(sceneUtils.timestamp, asset, assetSalt , sceneUtils.sunrise, sceneUtils.sunset, false);
          
        
            for (indexes.i2 = 0; indexes.i2 < visibleStartTimes.length; indexes.i2++) {
                

                 SceneElement memory sceneElement;
                 sceneElement.posSalt = string(abi.encodePacked(visibleStartTimes[indexes.i2].toString(), asset.name));
                 sceneElement.y = uint(scene.area[1]) + NDUtils.randomNum(sceneElement.posSalt, 0, uint(scene.area[3]));
                 sceneElement.x = int(scene.area[0]) + int(NDUtils.randomNum(sceneElement.posSalt, 0, uint(scene.area[2])));
                 sceneElement.xScale = NDUtils.randomNum(sceneElement.posSalt, 0,1)  == 0 ? int(1): int(-1);
                 sceneElement.decimalScaleX = NDUtils.renderDecimal(int(sceneElement.xScale * int(scene.scale)));
                sceneElement.decimalScaleY = NDUtils.renderDecimal(int(scene.scale));

                 sceneElement.svg = NDUtils.createElementAndSetColor(sceneElement, sceneElement.posSalt, asset.name);

                 elements[indexes.allAssetIndex] = sceneElement;
                 indexes.allAssetIndex = indexes.allAssetIndex + 1;
                

                 renderedScene.nightMaskSvg = string.concat(renderedScene.nightMaskSvg, '<use href="#', string.concat(asset.name, "-mask"), '" filter="url(#makeBlack)" transform="translate( ', sceneElement.x.toStringSigned(),',', sceneElement.y.toString(), ') scale(', sceneElement.decimalScaleX, ' ' , sceneElement.decimalScaleY,')"/>');
                
                
        }
            
         
        }
        
  

        elements = sortElements(elements);
        
        
               



       

        for (indexes.i = 0; indexes.i < elements.length; indexes.i++) {
            renderedScene.sceneSvg = string.concat(renderedScene.sceneSvg, elements[indexes.i].svg);
        }


        return renderedScene;
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
        AssetInScene memory assetInScene = AssetInScene(assetName, duration, duration, checkInterval, possibleOffset, appearanceProbability, DAYTIME.NIGHT_AND_DAY);
        uint[] memory visibleStartTimes = NDUtils.computeStarttime(timestamp, assetInScene, assetSalt , 0, 0, true);

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
                SceneElement memory sceneElement;
                sceneElement.x = x;
                sceneElement.y = y;
                sceneElement.decimalScaleX = NDUtils.renderDecimal(int(int(scale) * direction));
                sceneElement.decimalScaleY = NDUtils.renderDecimal(int(scale));


                string memory assetSvg = NDUtils.createElementAndSetColor(sceneElement, visibleAssetSalt, assetName);



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

        function renderMoon(uint tokenId, int heading, int skyHeight, int azimuth, int altitude, int pa, int fraction, int angle ) public pure returns (string memory) {

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

       function applyNight(int256 altitude, uint tokenId) public pure returns (string memory) {
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


        string memory night = string.concat(
            '<rect mask="url(#nightMask', tokenId.toString(), ')" style="mix-blend-mode:multiply" width="1080" height="1080" fill="#0F3327" opacity="',
            opacityString,
            '"></rect>'
        );

        
        return night;
    }



    function getSkyColor( int altitude) internal pure returns (string memory , string memory) {
        
        
        SkyAndWaterColor[17] memory  skyColors = [
        SkyAndWaterColor(-9000, "ce80ff", "f9b233"),
        SkyAndWaterColor(-1200, "ce80ff", "f9b233"),
        SkyAndWaterColor(-700, "e780c0", "e0b439"),
        SkyAndWaterColor(-400, "ff8080", "c8b63f"),
        SkyAndWaterColor(0, "ff9986", "afb845"),
        SkyAndWaterColor(300, "ffb28c", "96b94c"),
        SkyAndWaterColor(700, "ffd986", "7dbb52"),
        SkyAndWaterColor(1100, "ffff80", "65bd58"),
        SkyAndWaterColor(1500, "c0eac0", "4cbf5e"),
        SkyAndWaterColor(2500, "80d5ff", "57af6c"),
        SkyAndWaterColor(1800, "77c7f8", "639e7a"),
        SkyAndWaterColor(2500, "6dbaf1", "6e8e88"),
        SkyAndWaterColor(3500, "64acea", "797d95"),
        SkyAndWaterColor(4700, "5a9ee4", "846da3"),
        SkyAndWaterColor(6000, "5190dd", "905cb1"),
        SkyAndWaterColor(7300, "4783d6", "9b4cbf"),
        SkyAndWaterColor(8000, "3e75cf", "9b4cbf")
      
        ];
        bytes6  cColor = bytes6("ffffff"); 
        bytes6  wColor = bytes6("ffffff");
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

     
        return (string(abi.encodePacked("#",cColor)), string(abi.encodePacked("#",wColor)));
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

     function renderFlower(string memory svg, SunMoon memory sunMoon, int256 heading, FlowerType flowerType, FlowerParts memory flowerParts, bool hasPot) public pure returns (string memory) {
        
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

            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azi", "0");
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$alt", "0");

            if(flowerType == FlowerType.GENTIAN) {
                  flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azis", "0");
            }
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

            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azi", string.concat(NDUtils.renderDecimal(angle), "deg"));
            flowerSvg = NDUtils.replaceFirst(flowerSvg, "$alt", string.concat(NDUtils.renderDecimal(altitude), "deg"));
            if(flowerType == FlowerType.GENTIAN) {
                  flowerSvg = NDUtils.replaceFirst(flowerSvg, "$azis", string.concat(NDUtils.renderDecimal(angle), "deg"));
            }
        }

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


        return NDUtils.replaceFirst(svg, "$fl", flowerSvg);
    }

   

        function renderLighthouse(string memory svg, int altitude, uint timestamp, uint tokenId) public pure returns ( string memory) {

            if (tokenId != 3) {
                return svg;
            }

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
            return NDUtils.replaceFirst(svg, "$li", lightHouse);


        }

     function renderAirplanes(     
        string memory svg,   
        uint timestamp, 
        uint tokenId, uint horizonInPx) public pure returns (string memory, string memory) {

            string memory salt = tokenId.toString();

            string memory aeroplanes = renderMovingAsset(timestamp, salt, "aeroplane", 0, horizonInPx - 30, false, 100, 100, 120, 120, 50, 60 );
            string memory flock = renderMovingAsset(timestamp, salt, "flock", 30, horizonInPx - 30, false, 100, 100, 300, 300, 50, 90 ); 
            string memory foreground = renderMovingAsset(timestamp, salt, "bird-f", 0, horizonInPx + 200, false, 100, 100, 120, 120, 50, 60 );
            string memory horizon = string.concat(aeroplanes, flock);
            svg = NDUtils.replaceFirst(svg, "$bi", foreground);
            return (horizon, svg);
        }

    function renderSunclock(string memory svg, int azimuth, int altitude, int heading) public pure returns (string memory) {

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
    
        svg = NDUtils.replaceFirst(svg, "$sh", shadowSVG);
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