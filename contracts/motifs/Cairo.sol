// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;
import "../BasicMotif.sol";
import "hardhat/console.sol";

bytes constant cairoData = hex"436f6c6f737365756d0000000000000000000000024d9b040213b66200b4015e000100026c032a010e0047ff4502080113006bff79021e017e007bfedb024e017e007bfee101ef017e007bfee1027e017e007bfee702ae017e007bfeed02de017e007bfef3030e017d007bfef9033e017d007bfefe036f017d007bff0400eb016a0092febb021e0215007bfedc024d0214007bfedc01ef0216007bfedc027d0213007bfedc018e0212007bfede015c020f007bfedb01890181007bfeee015c0181007bfeee02ad0210007bfedc02dc020c007bfedb030c0207007bfedb033c0201007bfedb036b01f8007bfedb010a0203008efee600cf01f7008efee6726f756e64000000726f756e640000003c646566733e3c672069643d22726f756e64222066696c6c3d2223393430304533223e3c7061746820643d224d2d31322d31372e3568323456352e36682d32347a222f3e3c636972636c652063793d22352e352220723d223132222f3e3c2f673e3c2f646566733e3c706174682066696c6c3d22234641433135432220643d226d332037323820313131382d3133322d372d3232354c38203335327a222f3e3c672066696c6c3d2223443439394634223e3c7061746820643d224d302033333368393976383748307a222f3e3c7061746820643d224d2d3920333133683431763837482d397a4d3934203336306833327632394839347a4d31343820333436683534763434682d35347a4d38373620333436683935763936682d39357a4d39393820333135683434763735682d34347a4d3130343220333330683434763735682d34347a222f3e3c7061746820643d224d39333320333131683338763432682d33387a4d38353820333034683534763434682d35347a222f3e3c2f673e3c706174682066696c6c3d22234639423233332220643d224d302033383968313038307636393148307a222f3e3c706174682066696c6c3d22234641433135432220643d224d3130383520313033342d37203930367633313168313039327a4d31303938203736312d3230203632396c372d32303820313130362d31397a222f3e3c706174682066696c6c3d22234641433135432220643d226d31373920393732203934322d3138382d34362d33392d393432203138377a222f3e3c706174682066696c6c3d22234434393946342220643d226d373036203738352034203132203130312d31372d342d31327a222f3e3c706174682066696c6c3d22234632384430302220643d226d37383020393133203237392033382d332033312d3238302d33387a222f3e3c706174682066696c6c3d22234644453041442220643d226d32363420383636203236342d353320352032312d3236342035337a222f3e3c706174682066696c6c3d22234639423233332220643d226d2d31393920353630203539382d313232682d3731347a4d31353534203630302039353620343738683731347a222f3e3c672066696c6c3d2223423935394544223e3c7061746820643d226d323936203235332d32302d312036203132366832337a4d323733203138306c2d33352d35763133306833387a222f3e3c7061746820643d226d323532203131372d31362d32763133306832317a222f3e3c2f673e3c672066696c6c3d2223454143434639223e3c7061746820643d224d313739203331386837323176323136483137397a222f3e3c7061746820643d226d313739203534392031333720323820313938203130203234312d3130203134352d3234762d3234483137397a4d323336203332366c39352d32322035303320342036362031307a222f3e3c7061746820643d226d3137392034343420392d3330332034382d323620322036302032312031307636316c32312037763230317a4d3430332034343768343335563230386c2d3132362d32352d3132392d31302d31383020357a222f3e3c7061746820643d224d3331332032363668313238763639483331337a222f3e3c7061746820643d224d33313320323436683335763331682d33357a222f3e3c2f673e3c706174682066696c6c3d22234239353945442220643d224d34363420333534682d34356c3133203233316834357a4d33323620333833682d32336c3134203139356832337a4d34343820333439682d33336c2d372d36316833327a222f3e3c672066696c6c3d2223393430304533223e3c7061746820643d224d34363820313931683139763337682d31397a4d35353120313839683139763337682d31397a4d36333520323135683139763337682d31397a4d36373020323730683139763337682d31397a4d37313220323233683139763337682d31397a4d37353520323339683139763337682d31397a4d31393120333134683132763634682d31327a4d32303420313536683130763236682d31307a4d32303420323037683231763539682d32317a222f3e3c2f673e3c212d2d726f756e642d2d3e3c672069643d2261223e3c672066696c6c3d2223394242323234223e3c7061746820643d224d2d36342038323868333638762d3631482d36347a222f3e3c656c6c697073652063783d22323035222063793d22373637222072783d223939222072793d223631222f3e3c656c6c697073652063783d223334222063793d22373634222072783d223939222072793d223633222f3e3c656c6c697073652063783d22313232222063793d22363839222072783d22313133222072793d223930222f3e3c2f673e3c706174682066696c6c3d22234141373033352220643d224d3832203839366833356c34342d3730682d33357a222f3e3c706174682066696c6c3d22234141373033352220643d224d31323420383534682d31326c2d31392d32376831327a222f3e3c2f673e3c75736520687265663d22236122207472616e73666f726d3d226d6174726978282e363320302030202e3633203331382032363529222f3e3c75736520687265663d22236122207472616e73666f726d3d226d6174726978282e393220302030202e39322039323420343629222f3e";



// implmenets interface IMotif
contract Cairo {
    function getMotif()  public pure  returns (Motif memory) {
        return decodeMotif(cairoData);
    }



    // function which will decode Motif from bytes
    function decodeMotif(bytes memory _data) public pure returns (Motif memory) {
       //decode name from first 20 bytes
         bytes memory motifNameBytes = new bytes(20);
            for(uint i = 0; i < 20; i++){
                motifNameBytes[i] = _data[i];
            }


            // next 4 bytes are lat and 4 for lng, needs to be parsed to int
            bytes memory latBytes = new bytes(4);
            bytes memory lngBytes = new bytes(4);
            for(uint i = 0; i < 4; i++){
                latBytes[i] = _data[i+20];
                lngBytes[i] = _data[i+24];
            }
            int lat = bytesToInt(latBytes);
            int lng = bytesToInt(lngBytes);



            // next 2 bytes are looking direction and 2 for horizon, needs to be parsed to int
            bytes memory lookingDirectionBytes = new bytes(2);
            bytes memory horizonBytes = new bytes(2);
            for(uint i = 0; i < 2; i++){
                lookingDirectionBytes[i] = _data[i+28];
                horizonBytes[i] = _data[i+30];
            }

            int lookingDirection = bytesToInt(lookingDirectionBytes);
            int horizon = bytesToInt(horizonBytes);

   


            // next byte is scene count
            bytes memory sceneCountBytes = new bytes(1);

            // a scene consists of placeHolder - 8 bytes, area 4 * 2 bytes, asset count 1 byte
            // asset consists of name 8 bytes, minDuration 4 bytes, maxDuration 4 bytes, checkInterval 4 bytes, possibleOffset 4 bytes, probability 4 bytes, dayTime
            // dayTime 1 byte
            
            // create sceneCount int and iterate over scenes for decoding
            sceneCountBytes[0] = _data[32];
            uint sceneCount = uint(bytesToInt(sceneCountBytes));
            console.logUint(sceneCount);
            SceneInMotif[] memory scenes = new SceneInMotif[](sceneCount);
            uint currentByte = 33;
            for(uint i = 0; i < sceneCount; i++){
                // decode placeHolder
                bytes memory placeHolderBytes = new bytes(8);
                for(uint j = 0; j < 8; j++){
                    placeHolderBytes[j] = _data[currentByte + j];
                }
                string memory placeHolder = trimNullBytes(placeHolderBytes);
                currentByte += 8;


                // decode area
                int[4] memory area;
                for(uint j = 0; j < 4; j++){
                    bytes memory areaBytes = new bytes(2);
                    for(uint k = 0; k < 2; k++){
                        areaBytes[k] = _data[currentByte + k];
                    }
                    area[j] = bytesToInt(areaBytes);
                    currentByte += 2;
                }


               

                // decode asset count
                bytes memory assetCountBytes = new bytes(1);
                assetCountBytes[0] = _data[currentByte];
                uint assetCount = uint(bytesToInt(assetCountBytes));
                currentByte += 1;

                // decode assets
                AssetInScene[] memory assets = new AssetInScene[](assetCount);
                for(uint j = 0; j < assetCount; j++){
                    // decode name
                    bytes memory assetNameBytes = new bytes(8);
                    for(uint k = 0; k < 8; k++){
                        assetNameBytes[k] = _data[currentByte + k];
                    }
                    string memory assetName = trimNullBytes(assetNameBytes);
                    currentByte += 8;

                    // decode minDuration
                    bytes memory minDurationBytes = new bytes(4);
                    for(uint k = 0; k < 4; k++){
                        minDurationBytes[k] = _data[currentByte + k];
                    }
                    int minDuration = bytesToInt(minDurationBytes);
                    currentByte += 4;

                    // decode maxDuration
                    bytes memory maxDurationBytes = new bytes(4);
                    for(uint k = 0; k < 4; k++){
                        maxDurationBytes[k] = _data[currentByte + k];
                    }
                    int maxDuration = bytesToInt(maxDurationBytes);
                    currentByte += 4;

                    // decode checkInterval
                    bytes memory checkIntervalBytes = new bytes(4);
                    for(uint k = 0; k < 4; k++){
                        checkIntervalBytes[k] = _data[currentByte + k];
                    }
                    int checkInterval = bytesToInt(checkIntervalBytes);
                    currentByte += 4;

                    // decode possibleOffset
                    bytes memory possibleOffsetBytes = new bytes(4);
                    for(uint k = 0; k < 4; k++){
                        possibleOffsetBytes[k] = _data[currentByte + k];
                    }
                    int possibleOffset = bytesToInt(possibleOffsetBytes);
                    currentByte += 4;

                    // decode probability
                    bytes memory probabilityBytes = new bytes(4);
                    for(uint k = 0; k < 4; k++){
                        probabilityBytes[k] = _data[currentByte + k];
                    }
                    int probability = bytesToInt(probabilityBytes);
                    currentByte += 4;

                    // decode dayTime
                    bytes1  dayTimeByte = _data[currentByte];
                    
                    DAYTIME dayTime = DAYTIME(uint(uint8(dayTimeByte)));
                    currentByte += 1;

                    // create asset and add to assets
                    AssetInScene memory asset = AssetInScene(assetName, minDuration, maxDuration, checkInterval, possibleOffset, probability, dayTime);
                    assets[j] = asset;
                }

                    // add assets to scene
                    SceneInMotif memory scene = SceneInMotif(placeHolder, assets, area);
                    scenes[i] = scene;
            }

                    // decode replacements
                    // staring with replacement count
                    // and then iterating over replacements
                    console.logUint(currentByte);
                    uint replacementCount = uint(uint8(_data[currentByte]));
                    currentByte += 1;
                    console.logUint(replacementCount);
                    Replacement[] memory replacements = new Replacement[](replacementCount);
                    for(uint i = 0; i < replacementCount; i++){
                        // decode tag
                        ObjectType tag = ObjectType(uint(uint8(_data[currentByte])));
                        currentByte += 1;

                        // decode dataType
                        RenderDataType dataType = RenderDataType(uint(uint8(_data[currentByte])));
                        currentByte += 1;

                        // decode data length and then decode data ( encoded in int16 )
                        bytes memory dataLengthBytes = new bytes(1);
                        dataLengthBytes[0] = _data[currentByte];
                        uint dataLength = uint(bytesToInt(dataLengthBytes));
                        currentByte += 1;
                        // use bytesToIntArray to decode data
                        // itearte over dataLength and create bytes array
                        bytes memory dataBytes = new bytes(dataLength * 2);
                        for(uint j = 0; j < dataLength * 2; j++){
                            dataBytes[j] = _data[currentByte + j];
                        }
                        int256[] memory data = bytesToIntArray(dataBytes, 2);
                        currentByte += dataLength * 2;

                        // decode placeholder
                        bytes memory placeholderBytes = new bytes(8);
                        for(uint j = 0; j < 8; j++){
                            placeholderBytes[j] = _data[currentByte + j];
                        }
                        string memory placeholder = trimNullBytes(placeholderBytes);

                        // decode ref
                        bytes memory refBytes = new bytes(8);
                        for(uint j = 0; j < 8; j++){
                            refBytes[j] = _data[currentByte + j];
                        }
                        string memory ref = trimNullBytes(refBytes);

                        // create replacement and add to replacements
                        Replacement memory replacement = Replacement(tag, dataType, data, placeholder, ref);
                        replacements[i] = replacement;

                    }

                    // create svg with rest of data
                    bytes memory svgBytes = new bytes(_data.length - currentByte);
                    for(uint i = 0; i < _data.length - currentByte; i++){
                        svgBytes[i] = _data[currentByte + i];
                    }

                    string memory svg = string(svgBytes);

                    // create motif and return
                    Motif memory motif = Motif(trimNullBytes(motifNameBytes), lat, lng, lookingDirection, horizon, svg, scenes, replacements);
                    return motif;

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
            revert("Unsupported number of bytes per integer");
        }

        intArray[i / bytesPerInt] = value;
    }

    return intArray;
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


    function bytesToInt(bytes memory _bytes) public pure returns (int256) {
        uint256 number;
        for(uint i=0;i<_bytes.length;i++){
            number = number + uint256(uint8(_bytes[i]))*(2**(8*(_bytes.length-(i+1))));
        }
        return int256(number);
    }


}