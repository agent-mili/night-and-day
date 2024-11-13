// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./BasicMotif.sol";

import "./solidity-trigonometry/Trigonometry.sol";




library NDUtils {

using Strings for uint256;
using Strings for int256;
using Strings for int16;

 struct SkyAndWaterColor {
        int altitude;
        bytes6 skyColor;
        bytes6 waterColor;
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

function abs(int x) public pure returns (int) {
    return x >= 0 ? x : -x;
}

function renderDecimal(int256 value, uint decimals) public pure returns (string memory) {
        bool isNegative = value < 0;
        int256 integerPart = value / int(10 ** decimals);
        int256 decimalPart = abs(value % int(10**decimals));

        if (isNegative && integerPart == 0) {
            return string.concat(
                "-0.",
                padZeroes(decimalPart.toStringSigned(), decimals)
            );
        }

        return string.concat(
            integerPart.toStringSigned(),
            ".",
            padZeroes(decimalPart.toStringSigned(), decimals)
        );
    }

    function renderDecimal(int256 value) public pure returns (string memory) {
        return renderDecimal(value, 2);
    }

     function applyNight(int256 altitude, uint tokenId) public pure returns (string memory) {

        if (altitude > 0) {
            return "";
        }

        int256 altitudeThresholdForFullNight = -180000;
        int256 opacityFactor = 19 * 1e2;
        string memory tokenIdtoString = tokenId.toString();
        int starOpacicity = 0;
        int opacity = 0;
        if (altitude < altitudeThresholdForFullNight) {
            opacity = 100; 
            starOpacicity = 100;
        } else  {
            opacity =   abs(altitude) / opacityFactor ;
            starOpacicity = (altitude < -120000) ? (abs(altitude) - 120000) / 600 : int(0);
        } 
       


        string memory night = string.concat(
            '<rect mask="url(#nightMask', tokenIdtoString, ')" style="mix-blend-mode:multiply" width="1080" height="1080" fill="#0F3327" opacity="',
            renderDecimal(int256(opacity)),
            '"></rect><rect opacity="', renderDecimal(starOpacicity) ,'" filter="url(#star-filter', tokenIdtoString, ')" width="100%" height="100%" mask="url(#moonMask',tokenIdtoString, ')"/>'
        );

        
        return night;
    }



    function createElementAndSetColor(SceneElement memory sceneElement, string memory assetName, uint timestamp) public pure returns (string memory) {

        bool isPerson = Strings.equal(assetName, "person") || Strings.equal(assetName, "person-f");
        bool isYacht = Strings.equal(assetName, "yacht") || Strings.equal(assetName, "ball");
        bool isBird = Strings.equal(assetName, "bird") || Strings.equal(assetName, "bird-f");
        bool isBigShip = Strings.equal(assetName, "fisher") || Strings.equal(assetName, "cruise");
        string memory colorStr = " ";

        if(isBird) {
            uint rdIndex = randomNum(sceneElement.posSalt, 23, 25);
            colorStr = string.concat(' fill="', getColorByIndex(rdIndex), '" ');
        }
        else if (isYacht) {
            uint rdIndex = randomNum(sceneElement.posSalt, 0, 16);
            colorStr = string.concat(' fill="', getColorByIndex(rdIndex), '" ');
        }
        else if (isPerson) {
            uint rdIndex1 = randomNum(sceneElement.posSalt, 0, 16);
            uint rdIndex2 = randomNum(sceneElement.posSalt, 17, 22);
            colorStr = string.concat(' fill="', getColorByIndex(rdIndex1), '"', ' stroke="', getColorByIndex(rdIndex2), '" ');
            
        }
        else if (isBigShip) {
            uint rdIndex = randomNum(sceneElement.posSalt, 11, 14);
            colorStr = string.concat(' fill="', getColorByIndex(rdIndex), '" ');
        }
     
        if (Strings.equal(assetName, "dolphin")) {
            assetName = string.concat(assetName, (timestamp % 5).toString());
        }

        string memory asset  = string.concat('<use href="#',assetName, '"', colorStr,  'transform="translate(', sceneElement.x.toStringSigned(), ',', sceneElement.y.toString(), ') scale(', sceneElement.decimalScaleX, ' '  , sceneElement.decimalScaleY, ')"/>');

        return asset;
    }

      function getSkyColor( int altitude) public pure returns (string memory , string memory) {
        
        
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

     function getColorByIndex(uint256 index) public pure returns (string memory) {
        bytes6[26] memory rdColors = [
            bytes6('ffffff'), 'dbd8e0', '684193', 'e3cce5', 'fff6cc', 
            '649624', '9bb221', 'c3d17c', 'ffd700', 'ffe766', 
            'fcd899', 'f29104', 'e6342a', 'e94f1c', 'be1823', 
            'aa7034', 'e94e1b', bytes6("ffcabf"),bytes6("ffcc99"),bytes6("cc8f52"),bytes6("7a4625"),bytes6("ffcc4d"),bytes6("966329"),
            'f37c00', 'ff5d6a', 'cb0fe0' ];

        require(index < rdColors.length, "out of index");
        return string(abi.encodePacked("#", rdColors[index]));
    }

    

     function renderLighthouse(string memory svg, int altitude, uint timestamp, uint tokenId) public pure returns ( string memory) {

            if (tokenId != 3 || altitude > 0) {
                return svg;
            }

            uint rotationInSeconds = 40;
            uint progress = timestamp % rotationInSeconds * 100 / rotationInSeconds;
            uint rotation = progress * 2 * 31415926535897932;

            int xValue = Trigonometry.sin(rotation) * 810;

            int yValue = (10 * 1e18) + Trigonometry.cos(rotation) * 68 + (68 * 1e18);

            string memory xDec = renderDecimal(xValue / 1e16);
            string memory yDec = renderDecimal(yValue / 1e16);

 

            string memory lightHouse =  string.concat('<polygon opacity="0.3" fill="#fff" points="' , xDec, ',', yDec, ',0,0,', xDec,',-',yDec, '"/>');
            return NDUtils.replaceFirst(svg, "$li", lightHouse);


        }


    




    function padZeroes(string memory number, uint256 length) private pure returns (string memory) {
        while(bytes(number).length < length) {
            number = string.concat("0", number);
        }
        return number;
    }

    function randomNum(string memory nonce, uint256 min, uint256 max) public pure returns (uint) {
        require(min <= max, string.concat("min>max ", nonce, " ", min.toString(), ">", max.toString()));
        uint randomValue = uint(keccak256(abi.encodePacked( nonce)));
        uint result =  min + (randomValue % (max - min + 1));

        return result;
    }

    function randomNum(uint256 nonce, uint256 min, uint256 max) public pure returns (uint) {
        return randomNum(nonce.toString(), min, max);
    }


    function createStandardAttributes(Motif memory motif, FlowerType flowerType, int altitude) public pure returns (string memory, string memory) {
        
        //convert lat/lng to DD
        string memory dd = string.concat(renderDecimal(motif.lat, 6), ",",  renderDecimal(motif.lng, 6));

        string memory attributes = string.concat('"attributes": [{"trait_type":"Flower","value":"', flowerType == FlowerType.ROSE ? "Rose" : flowerType == FlowerType.SUNFLOWER ? "Sunflower" :flowerType == FlowerType.ICEFLOWER  ? "Iceflower": "Moonflower", '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Position","value":"', dd, '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Heading","value":"', motif.heading.toStringSigned(), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Motif Type","value":"', motif.motifType == MotifType.SIGHT_SEEING ? "Attraction" : motif.motifType == MotifType.BEACH ? "Beach" : motif.motifType == 
        MotifType.SKYSCRAPER ? "City" : "Landscape", '"}');


        string memory description = string.concat(' at ', altitude < -180000 ? 'night' : altitude > 0 ? 'day': 'twilight');
        return (attributes, description);
    
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

            if (randomNum(startTimeSalt, 0, 100) < uint(asset.probability)) {
            
                uint startTime = uint(checkTimestamp) +randomNum(startTimeSalt, 0, uint(asset.possibleOffset));
                uint endTime = startTime + randomNum(startTimeSalt, uint(asset.minDuration), uint(asset.maxDuration));
                if (startTime <= timestamp && endTime +  (isMoving? (asset.minDuration / 2) : 0) >= timestamp && uint(startTime) >= uint(minStartTime)) {
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

        if (timeOfDayVisibility == DAYTIME.DAY && minStartTime < sunriseTime) {
            minStartTime = sunriseTime;
        } else if (timeOfDayVisibility == DAYTIME.NIGHT && minStartTime < sunsetTime) {
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


    function generateClouds(uint skyHeight, uint tokenId, uint timestamp) public pure returns (string memory) {

       // we add ann offset by token to cloud movement
       timestamp = timestamp + randomNum(tokenId.toString(), 0, 8 hours);
       uint timeForCloud = 80 minutes;
       uint timeBetweenClouds = 20 minutes;
       uint cloudDistance = 140;
       string memory clouds;
       uint i;
       uint startTime;
       string memory cloudNonce;
       uint cloudIndex;
       int cloudX;
       int cloudY;
       uint offset;
       bool mirrored;
       bool leftToRight;
       uint cloudType;
       uint passedDistance;

       for ( i = 0; i < 4; i++) {
            startTime = timestamp - (timestamp % timeBetweenClouds) - i * timeBetweenClouds;
            cloudNonce = string.concat(tokenId.toString(), "cloud", startTime.toString());
            cloudIndex = randomNum(cloudNonce, 0, 4);
            if (cloudIndex > 2) continue;

            cloudType = cloudIndex + 1;
            mirrored = randomNum(string.concat("mir", cloudNonce), 0, 100) > 50;
            leftToRight = randomNum(string.concat("ltr", cloudNonce), 0, 100) > 50;
            offset = randomNum(cloudNonce, 0, 20);
            passedDistance = (timestamp - startTime) * cloudDistance * 1e4 / (timeForCloud * 1e4);
            cloudX = leftToRight ? -10 + int(passedDistance) - int(offset) : 100 + 10 - int(passedDistance) + int(offset);
            cloudX = cloudX * 1080;
            cloudY = int(randomNum(cloudNonce, 7000, skyHeight * 1e2 / 2));
            clouds = string.concat(clouds, '<use href="#cloud', cloudType.toString(), '" transform="translate(', renderDecimal(cloudX), ', ', renderDecimal(cloudY), ') scale(', mirrored ? "-1" : "1", ' 1)"/>');
       }


        // horizon clouds


        timeForCloud = 8 hours;
        timeBetweenClouds = 4 hours;
        cloudDistance = 200;

        for (i = 0; i <2; i++) {
            startTime = timestamp - (timestamp % timeBetweenClouds) - i * timeBetweenClouds;
            cloudNonce = string.concat(tokenId.toString(), "cloud", startTime.toString());
            cloudIndex = randomNum(cloudNonce, 0, 7);
            if (cloudIndex > 4) continue;

            cloudType = cloudIndex + 4;
            mirrored = randomNum(string.concat("mir", cloudNonce), 0, 100) > 50;
            leftToRight = randomNum(string.concat("ltr", cloudNonce), 0, 100) > 50;
            passedDistance = (timestamp - startTime) * cloudDistance * 1e4 / (timeForCloud * 1e4);
            cloudX = leftToRight ? -50 + int(passedDistance) : int(cloudDistance) - 50 - int(passedDistance);
            cloudX = cloudX * 1080;
            cloudY = int(randomNum(cloudNonce, (skyHeight - 20) * 1e2  , uint(skyHeight * 1e2)));
            clouds = string.concat(clouds, '<use href="#cloud', cloudType.toString(), '" transform="translate(', renderDecimal(cloudX), ', ', renderDecimal(cloudY), ') scale(', mirrored ? "-1" : "1", ' 1)"/>');
        }

        clouds = string.concat("<g opacity='.8'>", clouds, "</g>");
        return clouds;
   
    }


 function formatChartNumber(uint256 number) public pure returns (string memory) {
          if (number < 1e5) {
            return renderDecimal(int(number), 2);
          }
          number = number / 1e2;
          if (number < 1e6) {
            return number.toString();
          }
        else if (number < 1e9) {
            return string.concat(
                (number / 1e6).toString(),
                ".",
                padZeroes(((number % 1e6) / 1e3).toString(), 3),
                "M"
            );
        } else if (number < 1e12) {
            return string.concat(
                (number / 1e9).toString(),
                ".",
                padZeroes(((number % 1e9) / 1e6).toString(), 3),
                "B"
            );
        } else {
            return string.concat(
                (number / 1e12).toString(),
                ".",
                padZeroes(((number % 1e12) / 1e9).toString(), 3),
                "T"
            );
        }
    }




    function renderReplacements(Replacement[] memory replacements, uint tokenId) public pure returns (string memory) {
        string memory allReplacements;
        string memory tokenIdStr = tokenId.toString();
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

        allReplacements = string.concat(allReplacements, '<g id="', replacement.placeholder,"-",tokenIdStr, '">', replacementSvg, '</g>');
    }
    return allReplacements;
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

        return replaceFirst(svgTemplate,placeholder, useTags);
    } 

    


    // is used for flowers and few plants
    function setUseRotations(string memory svg, string memory ref, string memory placeHolder, int[] memory rotations, int16[2] memory rotationAnchor) public pure returns (string memory) {
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

        return replaceFirst(svg, placeHolder, useTags);
    }

      function renderFinalNFT(string memory assetsSVG, uint tokenId, string memory motifSVG, SVGData memory svgData,  string memory maskedAssetsSVG, MotifType  motifType, uint timestamp) public pure returns (string memory) {


        string memory waves = generateWaves(tokenId, timestamp);

        string memory tokenIdStr = tokenId.toString();
        string memory topSVG = 
        string.concat(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1080 1080">'
        '<filter id="star-filter', tokenIdStr,'">'
        '<feTurbulence seed="', tokenIdStr, '" baseFrequency=".08" result="turbulence"/>'
        '<feColorMatrix type="matrix" values="0 0 0 9 -4 '
                                             '0 0 0 9 -4 '
                                             '0 0 0 9 -4 '
                                             '0 0 0 1 0" result="boosted"/>'
        '<feComponentTransfer>'
            '<feFuncA type="table" tableValues="0 0 0 1 0"/>'
        '</feComponentTransfer>'
        '</filter>'
         '<filter id="makeWhite">'
        '<feColorMatrix type="matrix"'
        ' values="1 1 1 1 0 '
                '1 1 1 1 0 '
                '1 1 1 1 0 '
                '1 1 1 1 0" />'
        '</filter>'
        '<filter id="makeBlack">'
        '<feColorMatrix type="matrix"'
        ' values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0" /></filter>'
        '<filter id="silh', tokenIdStr,'" x="0" y="0" width="200%" height="200%">'
        '<feFlood flood-color="', svgData.waterColor,'" result="flood" />'
        '<feComposite in="flood" in2="SourceAlpha" operator="in"/>'
        '</filter>');




        string memory skyBGSVG = string.concat('<rect fill="', svgData.skyColor, '" width="1080" height="1080"/>');
        string memory skyBehind = string.concat(topSVG, skyBGSVG , svgData.sunSVG, assetsSVG);

        string memory moonMask = string.concat('<mask id="moonMask', tokenIdStr, '"><rect fill="#fff" width="1080" height="1080"/>','<use href="#motif',tokenIdStr, '" filter="url(#makeBlack)"/></mask>', svgData.nightSVG , svgData.moonSVG ,'</svg>');
        string memory lightHouse =  tokenId == 3 ? '<use href="#lighthouse" filter="url(#makeBlack)"/>' : '';
        string memory cityLights = motifType == MotifType.SKYSCRAPER ? string.concat('<use href="#s-light', tokenIdStr,'" filter="url(#makeBlack)"/>') : '';
        string memory nightMask = string.concat('</g><mask id="nightMask', tokenIdStr, '">','<rect fill="#fff" width="1080" height="1080"/>', lightHouse, maskedAssetsSVG , cityLights,'<use href="#bird-group',tokenIdStr,'" filter="url(#makeWhite)"/></mask>');

        string memory outputSVG = string.concat(skyBehind, '<g id="motif',tokenIdStr, '">',svgData.cloudsSVG, svgData.skySceneSVG,  motifSVG, nightMask, '<defs>', waves ,svgData.flowerSVG, svgData.replacements, '</defs>',  moonMask  );

        return outputSVG;


    }


    function generateWaves(uint tokenId, uint timestamp) public pure returns (string memory) {
        string memory tokenIdstr = tokenId.toString();
        int y = int(randomNum(string.concat(tokenIdstr, timestamp.toString()),0,60  )) - 30;
        if (y > -5 && y < 5){
            y = y < 0 ? -5 : int(5);
        }
        return string.concat(
'<g id="crest', tokenIdstr,'"><rect fill="#FCD899" id="first-c', tokenIdstr ,'" width="300" x="0" height="4" y="', y.toStringSigned() ,'" /><use href="#first-c', tokenIdstr, '" transform="translate(400) scale(1,-1)" /></g>'
'<pattern viewBox="-20 -20 800 800" id="crestA', tokenIdstr ,'" width=".7" height="1"><use href="#crest', tokenIdstr, '"  /></pattern>'
'<pattern viewBox="-50 -20 800 800" id="crestB', tokenIdstr,'" width=".5" height="1"><use href="#crest', tokenIdstr ,'" /></pattern>'
'<pattern viewBox="20 -20 800 800" id="crestC', tokenIdstr ,'" width=".375" height="1"><use href="#crest',tokenIdstr ,'"  /></pattern>'
'<pattern viewBox="20 -20 800 800" id="crestD',tokenIdstr, '" width=".25" height="1"><use href="#crest',tokenIdstr ,'"  /></pattern>'
'<pattern viewBox="20 -20 800 800" id="crestE', tokenIdstr, '" width=".15" height="1"><use href="#crest', tokenIdstr,'" /></pattern>'
'<g id="crests', tokenIdstr ,'"  transform="translate(0,800) scale(1,-1)">'
'<rect width="100%" height="100%" fill="url(#crestA', tokenIdstr, ')" />'
'<rect width="100%" height="100%" fill="url(#crestB', tokenIdstr,')" />'
'<rect width="100%" height="100%" fill="url(#crestC',tokenIdstr,')" />'
'<rect width="100%" height="100%" fill="url(#crestD',tokenIdstr,')" />'
'<rect width="100%" height="100%" fill="url(#crestE',tokenIdstr,')" />'
'</g>');

    }





}