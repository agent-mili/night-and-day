pragma solidity ^0.8.25;

import "./BasicMotif.sol";



library NDDecoder {


function decodeGenericMotif(bytes memory _data) public pure returns (GenericMotif memory) {
    //decode name from first 20 bytes
    uint index = 0;
 

    int lat = bytesToInt(extractBytes(_data, index, 4 ));
    index += 4;
    int lng = bytesToInt(extractBytes(_data, index, 4 ));
    index += 4;

    int heading = bytesToInt(extractBytes(_data, index, 2));
    index += 2;

    string memory motifName = string(trimNullBytes(extractBytes(_data, index, _data.length - index)));

    GenericMotif memory motif = GenericMotif(motifName, lat, lng, heading);
    return motif;
}


 function decodeMotif(bytes memory _data) public pure returns (Motif memory) {
       //decode name from first 20 bytes
            uint index = 0;
            string memory motifName = string(trimNullBytes(extractBytes(_data, index, 20)));
            index += 20;

            int lat = bytesToInt(extractBytes(_data, index, 4 ));
            index += 4;
            int lng = bytesToInt(extractBytes(_data, index, 4 ));
            index += 4;


            int heading = bytesToInt(extractBytes(_data, index, 2));
            index += 2;
            int horizon = bytesToInt(extractBytes(_data, index, 2));
            index += 2;

            (SceneInMotif[] memory scenes, uint sceneInMotifEndIndex) = decodeSceneIMotif(_data, index);
            index = sceneInMotifEndIndex ;            

            // decode replacements
            (Replacement[] memory replacements, uint replacementEndIndex) = decodeReplacements(_data, index);
            index = replacementEndIndex ;

            // create svg with rest of data
            string memory svg = string(extractBytes(_data, index, _data.length - index));

            // create motif and return
            Motif memory motif = Motif( motifName, lat, lng, heading, horizon, svg, scenes, replacements,MotifType(0));
            return motif;

    }

    function decodeAssetsForScenes (bytes memory _data) public pure returns (AssetInScene[] memory){
        // decode asset count
                    
                    uint index = 0;
                    uint assetCount = uint(uint8(_data[index]));
                    index += 1;

                    // decode assets
                    AssetInScene[] memory assets = new AssetInScene[](assetCount);
                    for(uint j = 0; j < assetCount; j++){
                        // decode asset name
                        string memory assetName = trimNullBytes(extractBytes(_data, index, 8));
                        index += 8;

                        uint minDuration = uint(bytesToInt(extractBytes(_data, index, 4)));
                        index += 4;

                        uint maxDuration = uint(bytesToInt(extractBytes(_data, index, 4)));
                        index += 4;

                        // decode checkInterval
                        uint checkInterval = uint(bytesToInt(extractBytes(_data, index, 4)));
                        index += 4;

                        // decode possibleOffset
                        uint possibleOffset = uint(bytesToInt(extractBytes(_data, index, 4)));
                        index += 4;

                        // decode probability
                        uint probability = uint(bytesToInt(extractBytes(_data, index, 4)));
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
            
                string memory placeHolder = trimNullBytes(extractBytes(_data, index, 8));

                index += 8;
                // decode area
                int[4] memory area;
                for(uint j = 0; j < 4; j++){
                    area[j] = bytesToInt(extractBytes(_data, index, 2));
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


                uint scale =  uint(bytesToInt(extractBytes(_data, index, 2)));
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
                        int256[] memory data = bytesToIntArray(extractBytes(_data, index, dataLength * 2), 2);
                        index += dataLength * 2;

                        // decode placeholder
  
                        string memory placeholder = trimNullBytes(extractBytes(_data, index, 8));
                        index += 8;

                        // decode ref
                        string memory ref = trimNullBytes(extractBytes(_data, index, 8));
                        index += 8;

                        // create replacement and add to replacements
                        Replacement memory replacement = Replacement(tag, dataType, data, placeholder, ref);
                        replacements[i] = replacement;

                    }
                    return (replacements, index);
    }

    function trimNullBytes(bytes memory data) public pure returns (string memory) {
        uint256 length = data.length;

        // Bestimmen der Länge des getrimmten Arrays
        while (length > 0 && data[length - 1] == 0) {
            length--;
        }

        // Konvertieren in einen String, ohne Null-Bytes am Ende
        bytes memory trimmedData = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            trimmedData[i] = data[i];
        }

        return string(trimmedData);
    }



    function extractBytes(bytes memory _data, uint _index, uint _byteCount) public pure returns (bytes memory) {
        bytes memory extractedBytes = new bytes(_byteCount);
        for(uint i = 0; i < _byteCount; i++){
            extractedBytes[i] = _data[i + _index];
        }
        return extractedBytes;
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



}