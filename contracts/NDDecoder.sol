pragma solidity ^0.8.25;

import "./BasicMotif.sol";
import "forge-std/console.sol";




library NDDecoder {


function decodeGenericMotif(bytes memory _data) public pure returns (GenericMotif memory) {
    //decode name from first 20 bytes
    uint index = 0;
 

    int lat = bytesToInt(slice(_data, index, 4 ));
    index += 4;
    int lng = bytesToInt(slice(_data, index, 4 ));
    index += 4;

    int heading = bytesToInt(slice(_data, index, 2));
    index += 2;

    string memory motifName = string(trimNullBytes(slice(_data, index, _data.length - index)));

    GenericMotif memory motif = GenericMotif(motifName, lat, lng, heading);
    return motif;
}


 function decodeMotif(bytes memory _data) public pure returns (Motif memory) {
       //decode name from first 20 bytes
            _data = flzDecompress(_data);
            uint index = 0;
            string memory motifName = string(trimNullBytes(slice(_data, index, 20)));
            index += 20;

            int lat = bytesToInt(slice(_data, index, 4 ));
            index += 4;
            int lng = bytesToInt(slice(_data, index, 4 ));
            index += 4;


            int heading = bytesToInt(slice(_data, index, 2));
            index += 2;
            int horizon = bytesToInt(slice(_data, index, 2));
            index += 2;

            (SceneInMotif[] memory scenes, uint sceneInMotifEndIndex) = decodeSceneIMotif(_data, index);
            index = sceneInMotifEndIndex ;            

            // decode replacements
            (Replacement[] memory replacements, uint replacementEndIndex) = decodeReplacements(_data, index);
            index = replacementEndIndex ;

            // create svg with rest of data
            string memory svg = string(slice(_data, index, _data.length - index));

            // create motif and return
            Motif memory motif = Motif( motifName, lat, lng, heading, horizon, svg, scenes, replacements,MotifType(0));
            return motif;

    }

    function decodeAssetsForScenes (bytes memory _data) public view returns (AssetInScene[] memory){
        // decode asset count
                    
                    uint index = 0;
                    uint assetCount = uint(uint8(_data[index]));
                    index += 1;

                    // decode assets
                    AssetInScene[] memory assets = new AssetInScene[](assetCount);
                    for(uint j = 0; j < assetCount; j++){
                        // decode asset name
                        string memory assetName = trimNullBytes(slice(_data, index, 8));
                        index += 8;

                        uint minDuration = uint(bytesToInt(slice(_data, index, 4)));
                        index += 4;

                        uint maxDuration = uint(bytesToInt(slice(_data, index, 4)));
                        index += 4;

                        // decode checkInterval
                        uint checkInterval = uint(bytesToInt(slice(_data, index, 4)));
                        index += 4;

                        // decode possibleOffset
                        uint possibleOffset = uint(bytesToInt(slice(_data, index, 4)));
                        index += 4;

                        // decode probability
                        uint probability = uint(bytesToInt(slice(_data, index, 4)));
                        index += 4;

                        // decode dayTime
                        
                        DAYTIME dayTime = DAYTIME(uint(uint8(_data[index])));
                        index += 1;

            
                 

                        // create asset and add to assets
                        AssetInScene memory asset = AssetInScene(assetName, minDuration, maxDuration, checkInterval, possibleOffset, probability, dayTime);
                        assets[j] = asset;
                    }
                    return assets;
    }

    function decodeSceneIMotif (bytes memory _data, uint index) public pure returns (SceneInMotif[] memory, uint){
        

             // create sceneCount int and iterate over scenes for decoding
            uint sceneCount = uint(uint8(_data[index]));
            index += 1;

            SceneInMotif[] memory scenes = new SceneInMotif[](sceneCount);
            for(uint i = 0; i < sceneCount; i++){
                // decode placeHolder
            
                string memory placeHolder = trimNullBytes(slice(_data, index, 8));

                index += 8;
                // decode area
                int[4] memory area;
                for(uint j = 0; j < 4; j++){
                    area[j] = bytesToInt(slice(_data, index, 2));
                    index += 2;
                }

                // decode asset count
                uint assetCount = uint(uint8(_data[index]));
                index += 1;

                  uint8[] memory assets = new uint8[](assetCount);
             for(uint j = 0; j < assetCount; j++){
                    // decode asset name
                    uint8 asset = uint8(_data[index]);
                    assets[j] = asset;
                    index += 1;


                }


                uint scale =  uint(bytesToInt(slice(_data, index, 2)));
                index +=2;

                 SceneInMotif memory scene = SceneInMotif(placeHolder, assets, area, scale);
                
                scenes[i] = scene;

            }

            return (scenes, index);
        
        
    }

    function decodeReplacements (bytes memory _data, uint index) public pure returns (Replacement[] memory, uint){
         // decode replacements
                    // staring with replacement count
                    // and then iterating over replacements
                    uint replacementCount = uint(uint8(_data[index]));

                    index += 1;
                    Replacement[] memory replacements = new Replacement[](replacementCount);
                    for(uint i = 0; i < replacementCount; i++){
                        // decode tag
                        ObjectType tag = ObjectType(uint(uint8(_data[index])));
                        index += 1;

                        // decode dataType
                        RenderDataType dataType = RenderDataType(uint(uint8(_data[index])));
                        index += 1;

                        // decode data length and then decode data ( encoded in int16 )
                        bytes memory dataLengthBytes = new bytes(1);
                        dataLengthBytes[0] = _data[index];
                        uint dataLength = uint(bytesToInt(dataLengthBytes));
                        index += 1;
                        // use bytesToIntArray to decode data
                        // itearte over dataLength and create bytes array
                        int256[] memory data = bytesToIntArray(slice(_data, index, dataLength * 2), 2);
                        index += dataLength * 2;

                        // decode placeholder
  
                        string memory placeholder = trimNullBytes(slice(_data, index, 8));
                        index += 8;

                        // decode ref
                        string memory ref = trimNullBytes(slice(_data, index, 8));
                        index += 8;

                        // create replacement and add to replacements
                        Replacement memory replacement = Replacement(tag, dataType, data, placeholder, ref);
                        replacements[i] = replacement;

                    }
                    return (replacements, index);
    }

    function trimNullBytes(bytes memory data) public pure returns (string memory) {
        uint256 length = data.length;

        while (length > 0 && data[length - 1] == 0) {
            length--;
        }

        bytes memory trimmedData = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            trimmedData[i] = data[i];
        }

        return string(trimmedData);
    }




    function bytesToInt(bytes memory _bytes) public pure returns (int256) {
        require(_bytes.length <= 32, "Input too long.");
        uint256 number = 0;
        for (uint i = 0; i < _bytes.length; i++) {
            number = number + (uint256(uint8(_bytes[i])) << (8 * (_bytes.length - 1 - i)));
        }

        // Wenn das erste Bit des resultierenden Wertes gesetzt ist, betrachten wir es als negatives im Zweierkomplement
        if (_bytes.length < 32 && (number >> (8 * _bytes.length - 1) & 1 == 0)) {
            // Positive Zahl oder Zahl, die nicht das Vorzeichenbit im Kontext von 256 Bit gesetzt hat
            return int256(number);
        } else {
            // Negative Zahl, passt das Vorzeichen für int256 an
            uint256 comp = 2**(8 * _bytes.length) - number;
            return -int256(comp);
        }
    }

    function bytesToIntArray(bytes memory data, uint8 bytesPerInt) public pure returns (int256[] memory) {
    require(data.length % bytesPerInt == 0, "Invalid data length");

    uint256 intArrayLength = data.length / bytesPerInt;
    int256[] memory intArray = new int256[](intArrayLength);

    for (uint256 i = 0; i < data.length; i += bytesPerInt) {
        int256 value;
        if (bytesPerInt == 2) {
            value = int16(uint16(uint8(data[i])) << 8 | uint16(uint8(data[i + 1])));
        } else if (bytesPerInt == 4) {
            value = int32(uint32(uint8(data[i])) << 24 | uint32(uint8(data[i + 1])) << 16 | uint32(uint8(data[i + 2])) << 8 | uint32(uint8(data[i + 3])));
        } else {
            revert("Unsupported number of bytes");
        }

        intArray[i / bytesPerInt] = value;
    }

    return intArray;
}

 /// @dev Returns the decompressed `data`.
    function flzDecompress(bytes memory data) public pure returns (bytes memory result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := mload(0x40)
            let op := add(result, 0x20)
            let end := add(add(data, 0x20), mload(data))
            for { data := add(data, 0x20) } lt(data, end) {} {
                let w := mload(data)
                let c := byte(0, w)
                let t := shr(5, c)
                if iszero(t) {
                    mstore(op, mload(add(data, 1)))
                    data := add(data, add(2, c))
                    op := add(op, add(1, c))
                    continue
                }
                for {
                    let g := eq(t, 7)
                    let l := add(2, xor(t, mul(g, xor(t, add(7, byte(1, w)))))) // M
                    let s := add(add(shl(8, and(0x1f, c)), byte(add(1, g), w)), 1) // R
                    let r := sub(op, s)
                    let f := xor(s, mul(gt(s, 0x20), xor(s, 0x20)))
                    let j := 0
                } 1 {} {
                    mstore(add(op, j), mload(add(r, j)))
                    j := add(j, f)
                    if lt(j, l) { continue }
                    data := add(data, add(2, g))
                    op := add(op, l)
                    break
                }
            }
            mstore(result, sub(op, add(result, 0x20))) // Store the length.
            mstore(op, 0) // Zeroize the slot after the string.
            mstore(0x40, add(op, 0x20)) // Allocate the memory.
        }
    }

    function slice(
        bytes memory _bytes,
        uint256 _start,
        uint256 _length
    )
        internal
        pure
        returns (bytes memory)
    {
        require(_length + 31 >= _length, "slice_overflow");
        require(_bytes.length >= _start + _length, "slice_outOfBounds");

        bytes memory tempBytes;

        // Check length is 0. `iszero` return 1 for `true` and 0 for `false`.
        assembly {
            switch iszero(_length)
            case 0 {
                // Get a location of some free memory and store it in tempBytes as
                // Solidity does for memory variables.
                tempBytes := mload(0x40)

                // Calculate length mod 32 to handle slices that are not a multiple of 32 in size.
                let lengthmod := and(_length, 31)

                // tempBytes will have the following format in memory: <length><data>
                // When copying data we will offset the start forward to avoid allocating additional memory
                // Therefore part of the length area will be written, but this will be overwritten later anyways.
                // In case no offset is require, the start is set to the data region (0x20 from the tempBytes)
                // mc will be used to keep track where to copy the data to.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    // Same logic as for mc is applied and additionally the start offset specified for the method is added
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    // increase `mc` and `cc` to read the next word from memory
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    // Copy the data from source (cc location) to the slice data (mc location)
                    mstore(mc, mload(cc))
                }

                // Store the length of the slice. This will overwrite any partial data that 
                // was copied when having slices that are not a multiple of 32.
                mstore(tempBytes, _length)

                // update free-memory pointer
                // allocating the array padded to 32 bytes like the compiler does now
                // To set the used memory as a multiple of 32, add 31 to the actual memory usage (mc) 
                // and remove the modulo 32 (the `and` with `not(31)`)
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            // if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)
                // zero out the 32 bytes slice we are about to return
                // we need to do it because Solidity does not garbage collect
                mstore(tempBytes, 0)

                // update free-memory pointer
                // tempBytes uses 32 bytes in memory (even when empty) for the length.
                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }



}