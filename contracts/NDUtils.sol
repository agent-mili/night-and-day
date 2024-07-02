// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./BasicMotif.sol";


library NDUtils {

using Strings for uint256;
using Strings for int256;
using Strings for int16;




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



    function setRandomColor(string memory svg, string memory salt) public pure returns (string memory) {


        uint256 rdIndex = randomNum(salt, 0,  16);
        string memory rdColor = getColorByIndex(rdIndex);
        return replaceFirst(svg, "<!--rdColor-->", rdColor);
    }

     function getColorByIndex(uint256 index) internal pure returns (string memory) {
        bytes6[17] memory rdColors = [
            bytes6('ffffff'), 'dbd8e0', '684193', 'e3cce5', 'fff6cc', 
            '649624', '9bb221', 'c3d17c', 'ffd700', 'ffe766', 
            'fcd899', 'f29104', 'e6342a', 'e94f1c', 'be1823', 
            'aa7034', 'e94e1b'
        ];

        require(index < rdColors.length, "out of index");
        return string(abi.encodePacked("#", rdColors[index]));
    }




    function padZeroes(string memory number, uint256 length) private pure returns (string memory) {
        while(bytes(number).length < length) {
            number = string.concat("0", number);
        }
        return number;
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


    function createStandardAttributes(Motif memory motif, FlowerType flowerType) public pure returns (string memory) {
        string memory attributes;
        
        attributes = string.concat('"attributes": [{"trait_type":"Flower","value":"', flowerType == FlowerType.ROSE ? "Rose" : flowerType == FlowerType.SUNFLOWER ? "Sunflower" :flowerType == FlowerType.GENTIAN  ? "Gentian": "Moonflower", '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Latitude","value":"', renderDecimal(motif.lat, 6), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Longitude","value":"', renderDecimal(motif.lng, 6), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Heading","value":"', motif.heading.toStringSigned(), '"}');
        attributes = string.concat(attributes, ',{"trait_type":"Motif Type","value":"', motif.motifType == MotifType.SIGHT_SEEING ? "Attraction" : motif.motifType == MotifType.BEACH ? "Beach" : motif.motifType == 
        MotifType.SKYSCRAPER ? "City" : "Landscape", '"}');

        return attributes;
    }



 function formatChartNumber(uint256 number) public pure returns (string memory) {
          if (number < 1e6) {
            // Keine Kürzung, nur die Zahl mit drei Nachkommastellen anzeigen
            return number.toString();
         
          }
        else if (number < 1e9) {
            // Kürzung auf Millionen
            return string.concat(
                (number / 1e6).toString(),
                ".",
                padZeroes(((number % 1e6) / 1e3).toString(), 3),
                "M"
            );
        } else if (number < 1e12) {
            // Kürzung auf Milliarden
            return string.concat(
                (number / 1e9).toString(),
                ".",
                padZeroes(((number % 1e9) / 1e6).toString(), 3),
                "B"
            );
        } else {
            // Kürzung auf Billionen
            return string.concat(
                (number / 1e12).toString(),
                ".",
                padZeroes(((number % 1e12) / 1e9).toString(), 3),
                "T"
            );
        }
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

        svg = replaceFirst(svg, string.concat("$", replacement.placeholder), replacementSvg);
    }
    return svg;
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

      function renderFinalNFT(string memory assetsSVG, uint tokenId, string memory motifSVG, SVGData memory svgData,  string memory maskedAssetsSVG) public view returns (string memory) {


        string memory topSVG = 
        string.concat(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 1080 1080">'
        '<filter id="makeBlack">'
        '<feColorMatrix type="matrix"'
        ' values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0" /></filter>'
        '<filter id="silh', tokenId.toString() ,'" x="0" y="0" width="200%" height="200%">'
        '<feFlood flood-color="', svgData.waterColor,'" result="flood" />'
        '<feComposite in="flood" in2="SourceAlpha" operator="in"/>'
        '</filter>');




        string memory skyBGSVG = string.concat('<rect fill="', svgData.skyColor, '" width="1080" height="1080"/>');
        string memory skyBehind = string.concat(topSVG, skyBGSVG , svgData.sunSVG, svgData.cloudsSVG, svgData.skySceneSVG, assetsSVG);

        string memory moonMask = string.concat('<mask id="moonMask', tokenId.toString(), '"><rect fill="#fff" width="1080" height="1080"/>','<use href="#motif', tokenId.toString(), '" filter="url(#makeBlack)"/></mask>', svgData.nightSVG , svgData.moonSVG ,'</svg>');
        string memory lightHouse = '<use href="#lighthouse" filter="url(#makeBlack)"/>';
        string memory nightMask = string.concat('</g><mask id="nightMask', tokenId.toString(), '">','<rect fill="#fff" width="1080" height="1080"/>', tokenId == 1 ? lightHouse : '', maskedAssetsSVG ,'</mask>');

        string memory outputSVG = string.concat(skyBehind, '<g id="motif', tokenId.toString(), '">', motifSVG, nightMask, moonMask );

        return outputSVG;


    }





}