

import "@openzeppelin/contracts/utils/Strings.sol";
import "./SunCalc.sol";
import "./BasicMotif.sol";
import "./Assets.sol";

library NDUtils {
using Strings for uint256;
using Strings for int256;
using Strings for int16;

int constant viewingRangeHorizontal = 120;
int constant viewingRangeVertical = 60;
int constant skyWidth = 1080;

 struct SkyColor {
        int altitude;
        string color;
    }

    struct SceneElement {
        uint y;
        string svg;
    }

    function renderNFT(Motif memory motif, uint256 timestamp) public pure returns (string memory) {
        string memory svg = motif.svg;
        (int256 azimuth, int256 altitude) = SunCalc.getPosition(motif.lat, motif.lng, timestamp);
        return svg;   
    }

    function renderReplacements(string memory svg, Replacement[] memory replacements) public pure returns (string memory) {
        for (uint i = 0; i < replacements.length; i++) {
        Replacement memory replacement = replacements[i];
        bytes memory data = replacement.data;
        string memory replacementSvg = "";
        int16[] memory positions = bytesToInt16Array(data);
        if (replacement.tag == ObjectType.USE) {
            uint iterationStep = (replacement.dataType == RenderDataType.POSITIONS) ? 2 : 
                                  (replacement.dataType == RenderDataType.POSISTIONSANDSCALE) ? 3 : 4;

            for (uint j = 0; j < positions.length; j += iterationStep) {
                int x = positions[j];
                int y = positions[j + 1];
                string memory scaleX = replacement.dataType == RenderDataType.POSITIONS ? "1" : renderDecimal(int(positions[j + 2]));
                string memory scaleY = replacement.dataType == RenderDataType.POSITIONSANDTWOSCALES ? renderDecimal(int(positions[j + 3])) : scaleX;

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
            (string memory sceneSvg, string memory sceneMaskSvg) = renderSceneAssets(scene.assets, timestamp, tokenID, scene.viewingRange, lat, lng);
            svg = replace(svg, string.concat("<!--", scene.name, "-->"), sceneSvg);
            nightMaskSvg = string.concat(nightMaskSvg, sceneMaskSvg);
        }

        svg = replace(svg, "<!--maskedassets-->", nightMaskSvg);
        return svg;
    }

    function renderSceneAssets(AssetInScene[] memory assets, uint256 timestamp, uint256 tokenID, uint256[4] memory area, int lat, int lng) public pure returns (string memory sceneSvg, string memory sceneMaskSvg) {
         
        SceneElement [] memory elements = new SceneElement[](assets.length);
        sceneMaskSvg = "";

        for (uint i = 0; i < assets.length; i++) {
            AssetInScene memory asset = assets[i];

            string memory assetSalt = string(abi.encodePacked(tokenID.toString(), asset.name));
            uint[] memory visibleStartTimes = computeStarttime(timestamp, asset.checkInterval , asset.minDuration, asset.maxDuration, asset.possibleOffset, asset.probability, assetSalt, asset.daytime , lat,lng);

            for (uint i2 = 0; i < visibleStartTimes.length; i2++) {
                uint startTime = (visibleStartTimes[i2]);

                string memory assetSvg = Assets.getAsset(asset.name);
                {
                string memory posSalt = string(abi.encodePacked(startTime.toString(), asset.name));
                uint256 y = area[1] + randomNum(posSalt, 0, area[3]);
                uint256 x = area[0] + randomNum(posSalt, 0, area[2]);

                assetSvg = setRandomColor(assetSvg, posSalt);
                assetSvg = string.concat('<g transform="translate(", x.toString(), ", ", y.toString(), ") scale(1, 1) \">", assetSvg, "</g>');
                

                elements[i] = SceneElement(y, assetSvg);

                if (Assets.hasNightMask(asset.name)) {
                    string memory maskName = Assets.getNightMask(asset.name);
                    sceneMaskSvg = string.concat(sceneMaskSvg, "<use href=\"#", maskName, "\" transform=\"translate(", x.toString(), ", ", y.toString(), ") scale(1, 1)\"/>");
                }
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
        string memory assetIndex, 
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
        string memory assetSalt = string(abi.encodePacked(salt, assetIndex));
        uint[] memory visibleStartTimes = computeStarttime(timestamp, checkInterval, duration, duration, possibleOffset, appearanceProbability, assetSalt, DAYTIME.NIGHT_AND_DAY , 0, 0);

        string memory assets;
        for (uint i = 0; i < visibleStartTimes.length; i++) {
            uint startTime = (visibleStartTimes[i]);
            int progress = int(timestamp - startTime) / int(duration);

            if (progress >= -30 && progress <= 130) {
                string memory visibleAssetSalt = string(abi.encodePacked(salt, startTime.toString()));
                string memory assetSvg = Assets.getAsset(assetIndex);
                uint y = randomNum(visibleAssetSalt, minY, maxY);
                int8 direction = int8(randomNum(visibleAssetSalt, 0, 1) == 0 ? -1 : int8(1));
                uint maxX = 1080;
                int x = direction == -1 ? int(maxX) * progress : int(maxX) * (1 - progress);
                uint scaleFac = maxScale - minScale;
                uint relativeY = (y - minY) / (maxY - minY);
                uint scale = horizontUp ? (relativeY + minScale) * maxScale : (1 - relativeY + minScale) * scaleFac;
                 assetSvg = setRandomColor(assetSvg, visibleAssetSalt);
                assetSvg = string.concat('<g transform="translate(', x.toStringSigned(), ', ', y.toString(), ') scale(', scale.toString() ,') \">', assetSvg, '</g>');
                assets = string.concat(assets, assetSvg);
            }
        }
        return assets;
    }



     function renderSun(string memory svg, uint skyHeight, int16 azimuth, int16 altitude, uint lookingDirection) public pure returns (string memory) {
        if (altitude > -12 && altitude <= viewingRangeVertical + 12) {
            int diffAngle = int(azimuth) - int(lookingDirection) + 180;
            diffAngle = (diffAngle % 360) - 180;

            if (diffAngle < int(viewingRangeHorizontal) / 2 && diffAngle > - viewingRangeHorizontal / 2) {
                int x = diffAngle +  viewingRangeHorizontal  / 2 * skyWidth / viewingRangeHorizontal;
                int y = int(skyHeight) - altitude * int(skyHeight) / viewingRangeVertical;

                return string.concat(
                    svg, 
                    "<g> <circle cx='", x.toStringSigned(), 
                    "' cy='", y.toStringSigned(), 
                    "' r='58' fill='#fff' /> <circle cx='", 
                    x.toStringSigned(), "' cy='", 
                    y.toStringSigned(), 
                    "' r='95' fill='#fff' opacity='0.26' /></g>"
                );
            }
        }
        return svg;
    }

       function applyNight(string memory svg, int256 altitude) public pure returns (string memory) {
        // Konstanten in e18
        int256 altitudeThresholdForFullNight = -18 * 10**18;
        int256 opacityFactor = 22 * 10**18;

        uint256 opacity;
        if (altitude < altitudeThresholdForFullNight) {
            opacity = 100; // Vollständige Opazität, entspricht 1.00
        } else if (altitude < 0 && altitude > altitudeThresholdForFullNight) {
            opacity = uint256(-altitude * 100 / opacityFactor); // Anpassung der Opazität
        } else {
            opacity = 0; // Keine Opazität
        }

        // Umwandeln der Opazität in einen String mit zwei Dezimalstellen
        string memory opacityString = renderDecimal(int256(opacity));

        // Erstellen des Nacht-Strings mit Opazität
        string memory night = string.concat(
            '<rect mask="url(#nightMask)" style="mix-blend-mode:multiply" width="100%" height="100%" fill="#0F3327" opacity=',
            opacityString,
            '></rect>'
        );

        // Ersetzen des Platzhalters <!--night--> im SVG
        return replace(svg, "<!--night-->", night);
    }

     function randomNum(string memory nonce, uint256 min, uint256 max) public pure returns (uint) {
        require(min < max, "min>max");
        uint randomValue = uint(keccak256(abi.encodePacked( nonce)));
        return min + (randomValue % (max - min + 1));
    }

    function randomNum(uint256 nonce, uint256 min, uint256 max) public pure returns (uint) {
        return randomNum(nonce.toString(), min, max);
    }

     function setUseTags(string memory svgTemplate, string memory ref, int16[] memory positions, bool hasScale, bytes5 placeholder)
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
            
            useTags = string(abi.encodePacked(
                useTags,
                '<use href="#', ref, '" transform="translate(', x, ', ', y, ') scale(', scale, ')" />'
            ));
        }

        return replace(svgTemplate, string(abi.encodePacked("<!--", bytes5ToString(placeholder), "-->")), useTags);
    } 


    // is used for flowers and few plants
    function setUseRotations(string memory svg, bytes5 ref, int16[] memory rotations, int16[2] memory rotationAnchor) public pure returns (string memory) {
        string memory useTags = "";

        for (uint256 i = 0; i < rotations.length; i++) {
            useTags = string.concat(
                useTags,
                '<use href="#',
                bytes5ToString(ref),
                '" transform="rotate(',
                int256(rotations[i]).toStringSigned(),
                ' ',
                int256(rotationAnchor[0]).toStringSigned(),
                ' ',
                int256(rotationAnchor[1]).toStringSigned(),
                ')"/>'
            );
        }

        return replace(svg, string.concat('<!--', bytes5ToString(ref), '-->'), useTags);
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

    function getSkyColor(int altitude) internal pure returns (string memory) {
        
        SkyColor[10] memory skyColors = [
            SkyColor(-90, '#ce80ff'),
            SkyColor(-12, '#ce80ff'),
            SkyColor(-7, '#e780c0'),
            SkyColor(-4, '#ff8080'),
            SkyColor(0, '#ff9986'),
            SkyColor(3, '#ffb28c'),
            SkyColor(7, '#ffd986'),
            SkyColor(11, '#ffff80'),
            SkyColor(15, '#c0eac0'),
            SkyColor(25, '#80d5ff')
      
        ];

        for (uint i = 0; i < skyColors.length; i++) {
            if (altitude >= skyColors[i].altitude) {
                // Wenn es der letzte Eintrag im Array ist oder wenn die nächste Höhe größer als die aktuelle ist
                if (i == skyColors.length - 1 || altitude < skyColors[i + 1].altitude) {
                    return skyColors[i].color;
                }
            }
        }

        //can never happen        
        return '#000000'; 
    }

     function renderSunFlower(string memory svg, int256 azimuth, int256 altitude, int256 lookingDirection) public pure returns (string memory) {
        
        string memory fullBlossom;
        string memory fullFlowerStick;
        {

        int16[2] memory petalRotationAnchor = [int16(0), int16(-75)];
        string memory flowerStick = '<g fill="#9bb224"><rect x="-4" y="-74" width="8" height="74"/><!--leaf--></g>';
        string memory blossom = '<g style="transform: rotateY(<!--azi-->) rotateX(<!--alt-->); transform-box:fill-box; transform-origin:center"><g fill="gold"><path d="M21-85C28-91 28-102 28-102C28-102 18-102 11-95C5-89 5-78 5-78C5-78 15-79 21-85Z" id="sunPetal"/><!--petal--></g><circle fill="<!--fcolor-->" cx="0" cy="-75" r="<!--fradius-->"></circle></g>';
        int16[] memory petalRotations = bytesToInt16Array(hex"001E003C005A0078009600B400D200F0010E012C014A");
        int16[] memory leafPos = new int16[](2);
        // //[-3, 71]
        leafPos[0] = -3;
        leafPos[1] = 71;


        // Petals und Flower Stick generieren
        fullBlossom = setUseRotations(blossom, "petal", petalRotations, petalRotationAnchor);
        fullFlowerStick = setUseTags(flowerStick, "petal", leafPos , false, "leaf");

        }

        uint256 frontRadius = 18;
        string memory frontColor = "#aa7035";
        uint256 backRadius = 26;
        string memory backColor = "#9bb224";
       

        int256 angle = azimuth - lookingDirection;
        string memory flowerSvg;

        if (altitude <= 0) {
            flowerSvg = string(abi.encodePacked(fullFlowerStick, fullBlossom));
            flowerSvg = replace(flowerSvg, "<!--fradius-->", frontRadius.toString());
            flowerSvg = replace(flowerSvg, "<!--fcolor-->", frontColor);
            flowerSvg = replace(flowerSvg, "<!--azi-->", "0");
            flowerSvg = replace(flowerSvg, "<!--alt-->", "0");
        } else {
            if (abs(angle) >= 90) {
                flowerSvg = string(abi.encodePacked(fullFlowerStick, fullBlossom));
                flowerSvg = replace(flowerSvg, "<!--fradius-->", frontRadius.toString());
                flowerSvg = replace(flowerSvg, "<!--fcolor-->", frontColor);
            } else {
                flowerSvg = string(abi.encodePacked(fullBlossom, fullFlowerStick));
                flowerSvg = replace(flowerSvg, "<!--fradius-->", backRadius.toString());
                flowerSvg = replace(flowerSvg, "<!--fcolor-->", backColor);
            }

            // Angle adjustments
            if (angle > 85 && angle < 90) {
                angle = 85;
            } else if (angle > 90 && angle < 95) {
                angle = 95;
            } else if (angle < -85 && angle > -90) {
                angle = -85;
            } else if (angle < -90 && angle > -95) {
                angle = -95;
            }

            flowerSvg = replace(flowerSvg, "<!--azi-->", string.concat(angle.toStringSigned(), "deg"));
            flowerSvg = replace(flowerSvg, "<!--alt-->", string.concat(altitude.toStringSigned(), "deg"));
        }

        return replace(svg, "<!--flower-->", flowerSvg);
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
        int lat,
        int lng
    ) public pure returns (uint[] memory) {

        uint minStartTime = timestamp - maxDuration - possibleOffset;
        uint maxStartTime = timestamp;
        bool isTimeFrameValid = true;
        
        {
        // Anpassung der Zeitstempel basierend auf Sonnenauf- und -untergang
         if (dayNight != DAYTIME.NIGHT_AND_DAY) {
            (uint sunrise, uint sunset) = SunCalc.getSunRiseSet(timestamp, lat, lng);
            (minStartTime, maxStartTime, isTimeFrameValid) = adjustTimeStampsForAssetVisibility(minStartTime, maxStartTime, sunrise, sunset, dayNight, 0, maxDuration);
            if (!isTimeFrameValid) {
                return new uint[](0);
            }
        } 
        }
        uint lastCheckTimestamp = maxStartTime - (maxStartTime % checkInterval);
        uint firstCheckTimestamp = minStartTime - (minStartTime % checkInterval);
        uint checkCount = (lastCheckTimestamp - firstCheckTimestamp) / checkInterval + 1;

        uint[] memory visibleStartTimes = new uint[](checkCount);
        uint visibleCount = 0;
         
         for (uint i = 0; i < checkCount; i++) {
            uint checkTimestamp = firstCheckTimestamp + i * checkInterval;
            string memory startTimeSalt = string(abi.encodePacked(salt, checkTimestamp.toString()));

            if (randomNum(startTimeSalt, 0, 100) < appearanceProbability) {
                uint startTime = checkTimestamp + randomNum(startTimeSalt, 0, possibleOffset);
                uint endTime = startTime + randomNum(startTimeSalt, minDuration, maxDuration);
                if (startTime <= timestamp && endTime >= timestamp && startTime >= minStartTime) {
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

     function bytes5ToString(bytes5 _bytes) public pure returns (string memory) {
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
    }

    function bytesToInt16Array(bytes memory data) public pure returns (int16[] memory) {
        require(data.length % 2 == 0, "bytes length not even");

        int16[] memory intArray = new int16[](data.length / 2);
        for (uint i = 0; i < data.length; i += 2) {
            uint16 uValue = (uint16(uint8(data[i])) << 8) | uint16(uint8(data[i + 1]));
            int16 value = int16(uValue);
            intArray[i / 2] = value;
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