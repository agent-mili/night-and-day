

import "@openzeppelin/contracts/utils/Strings.sol";
import "./SunCalc.sol";

library NDUtils {
using Strings for uint256;
using Strings for int256;

//bytes constant DATA = hex"032a010b00b90208015700f700860174006f00670073006d0063005e0052004b0045003b003800380036003500340033003200310030002f002f002e002d002c002b002a00290028012b00f2011800e7010600d501f400c301ea00b101e000a201d6009301cc008401c2007501b8006601ae005800a4004b009e003e0098003300920028008c001d0086001200800007007a00fb007500f4006f00ed006900e6006300df005d00d8005700d1005100ca004b00c4004500bd003f00b7003900b1003300ab002d00a50027009f00";

 struct SkyColor {
        int altitude;
        string color;
    }

    
     function randomNum(uint256 nonce, uint256 min, uint256 max) public view returns (uint) {


        require(min < max, "Min should be less than max");
        uint randomValue = uint(keccak256(abi.encodePacked(block.timestamp, nonce)));
        return min + (randomValue % (max - min + 1));
    }

     function setUseTags(string memory svgTemplate, string memory ref, int16[] memory positions, bool hasScale, string memory placeholder)
        public
        pure
        returns (string memory)
    {
        string memory useTags = "";
        uint256 iterationStep = hasScale ? 3 : 2;

        for (uint256 i = 0; i < positions.length; i += iterationStep) {
            string memory x = (int256(positions[i]).toStringSigned());
            string memory y = (int256(positions[i + 1]).toStringSigned());
            string memory scale = hasScale ? (int256(positions[i + 2])).toStringSigned() : "1";
            
            useTags = string(abi.encodePacked(
                useTags,
                '<use href="#', ref, '" transform="translate(', x, ', ', y, ') scale(', scale, ')" />'
            ));
        }

        return replace(svgTemplate, string(abi.encodePacked("<!--", placeholder, "-->")), useTags);
    } 


    function setUseRotations(string memory svg, string memory ref, uint16[] memory rotations, int16[2] memory rotationAnchor) public pure returns (string memory) {
        string memory useTags = "";

        for (uint256 i = 0; i < rotations.length; i++) {
            useTags = string.concat(
                useTags,
                '<use href="#',
                ref,
                '" transform="rotate(',
                uint256(rotations[i]).toString(),
                ' ',
                int256(rotationAnchor[0]).toStringSigned(),
                ' ',
                int256(rotationAnchor[1]).toStringSigned(),
                ')"/>'
            );
        }

        return replace(svg, string.concat('<!--', ref, '-->'), useTags);
    }



    // Funktion, um eine zufällige Farbe im SVG-String zu setzen
    function setRandomColor(string memory svg, uint256 salt) public view returns (string memory) {
        /* if (bytes(svg).length == 0 || !contains(svg, "<!--rdColor-->")) {
            return svg;
        } */

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

        return '#000000'; 
    }

     function renderSunFlower(string memory svg, int256 azimuth, int256 altitude, int256 lookingDirection) public pure returns (string memory) {
        
        string memory fullBlossom;
        string memory fullFlowerStick;
        {

             // Dynamisches Array für petalRotationAnchor
        int16[2] memory petalRotationAnchor = [int16(0), int16(-75)];
        // SVG-Vorlagen
        string memory flowerStick = '<g fill="#9bb224"><rect x="-4" y="-74" width="8" height="74"/><!--leaf--></g>';

        string memory blossom = ''; //'<g style="transform: rotateY(<!--azi-->) rotateX(<!--alt-->); transform-box:fill-box; transform-origin:center"><g fill="gold"><path d="M21-85C28-91 28-102 28-102C28-102 18-102 11-95C5-89 5-78 5-78C5-78 15-79 21-85Z" id="sunPetal"/><!--sunPetal--></g><circle fill="<!--fcolor-->" cx="0" cy="-75" r="<!--fradius-->"></circle></g>';


       /* uint256 length = DATA.length / 2;
        uint16[] memory petalRotations = new uint16[](length);

        for (uint256 i = 0; i < length; i++) {
            uint16 value = (uint16(uint8(DATA[i * 2])) << 8) + uint16(uint8(DATA[i * 2 + 1]));
            petalRotations[i] = value;
        } */


         uint16[11] memory fixedPetalRotations = [30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330 ];


        // Dynamisches Array erstellen
        // uint16[] memory petalRotations = new uint16[](fixedPetalRotations.length);

        // // Elemente aus dem festen Array in das dynamische Array kopieren
        // for (uint i = 0; i < fixedPetalRotations.length; i++) {
        //     petalRotations[i] = fixedPetalRotations[i];
        // }
        

        // int16[] memory leafPos = new int16[](2);
        // //[-3, 71]
        // leafPos[0] = -3;
        // leafPos[1] = 71;


        // Petals und Flower Stick generieren
     //   fullBlossom = setUseRotations(blossom, "sunPetal", petalRotations, petalRotationAnchor);
      //  fullFlowerStick = setUseTags(flowerStick, "sunPetal", leafPos , false, "leaf");

        }

        
        
        // Konstanten definieren
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
        uint salt,
        uint dayNight,
        int lat,
        int lng
    ) public view returns (uint[] memory) {

        uint minStartTime = timestamp - maxDuration - possibleOffset;
        uint maxStartTime = timestamp;
        bool isTimeFrameValid = true;
        
        {
        // Anpassung der Zeitstempel basierend auf Sonnenauf- und -untergang
      /*   if (dayNight == 0) {
            (uint sunrise, uint sunset) = SunCalc.getSunRiseSet(timestamp, lat, lng);
            (minStartTime, maxStartTime, isTimeFrameValid) = adjustTimeStampsForAssetVisibility(minStartTime, maxStartTime, sunrise, sunset, dayNight, 0, maxDuration);
            if (!isTimeFrameValid) {
                return new uint[](0);
            }
        } */
        }
        uint lastCheckTimestamp = maxStartTime - (maxStartTime % checkInterval);
        uint firstCheckTimestamp = minStartTime - (minStartTime % checkInterval);
        uint checkCount = (lastCheckTimestamp - firstCheckTimestamp) / checkInterval + 1;

        uint[] memory visibleStartTimes = new uint[](checkCount);
        uint visibleCount = 0;

        /* for (uint i = 0; i < checkCount; i++) {
            uint checkTimestamp = firstCheckTimestamp + i * checkInterval;
            if (randomNum(checkTimestamp + salt, 0, 100) < appearanceProbability) {
                uint startTime = checkTimestamp + randomNum(checkTimestamp + salt, 0, possibleOffset);
                uint endTime = startTime + randomNum(startTime, minDuration, maxDuration);
                if (startTime <= timestamp && endTime >= timestamp && startTime >= minStartTime) {
                    visibleStartTimes[visibleCount] = startTime;
                    visibleCount++;
                }
            }
        } */
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
        uint256 timeOfDayVisibility,
        uint256 tolerance,
        uint256 maxDuration
    ) public pure returns (uint256, uint256, bool) {

        uint256  NIGHT_ONLY = 1;
        uint256  DAY_ONLY = 2;
        bool isTimeFrameValid = true;

        // Anpassung von minStartTime basierend auf dem Asset-Typ
        if (timeOfDayVisibility == DAY_ONLY && minStartTime < sunriseTime) {
            minStartTime = sunriseTime;
        } else if (timeOfDayVisibility == NIGHT_ONLY && minStartTime > sunsetTime) {
            minStartTime = sunsetTime;
        }

        // Berechnung der Toleranzzeit
        uint256 toleranceTime = maxDuration * tolerance / 100;

        // Anpassung von maxStartTime und Überprüfung der Gültigkeit des Zeitrahmens
        if (timeOfDayVisibility == DAY_ONLY) {
            uint256 latestStartTimeForDayAsset = sunsetTime - maxDuration + toleranceTime;
            if (maxStartTime > latestStartTimeForDayAsset) {
                maxStartTime = latestStartTimeForDayAsset;
            }
            if (minStartTime > maxStartTime) {
                isTimeFrameValid = false;
            }
        } else if (timeOfDayVisibility == NIGHT_ONLY) {
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

   
}