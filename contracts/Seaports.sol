pragma solidity ^0.8.0;


contract Seaports {
    // Definieren Sie eine Struktur, die der von 'victoria' entspricht
    struct Location {
        string code;
        int lat;
        int lng;
        int heading;
        bool isLeftSided;
        uint[] neighbours;
    }

 bytes[] public locationData;

 constructor() {
        locationData.push(hex"5343504f56ffb966c0034e50750137010124");
        locationData.push(hex"4d5a4d4e43ff2220c8026c82690031000002");
        locationData.push(hex"4d47544c45fe9b46f2029a430a014b000103");
        locationData.push(hex"5a41445552fe382a0001d9a725013b000204");
        locationData.push(hex"5a41504c5afdf9d49d0187347a0052010305");
        locationData.push(hex"5a41435054fdfa8fd6011982a9008601040806");
        locationData.push(hex"4e414e5642fea1ca8a00dd083f001601050708090a");
        locationData.push(hex"4252524543ff851c55fdebf59e0163010609080a");
        locationData.push(hex"4253535341ff3a46befdb4691d0012000705060a");
        locationData.push(hex"42524e4154ffa7d0c8fde6dc8c016301070a");
        locationData.push(hex"534853484eff0d1ec9ffa8ced7000f0107090806050b");
        locationData.push(hex"4c524d4c570060c0baff5b3fa700cb010a0c");
        locationData.push(hex"475947454f0067f96efc886c450008000b0d");
        locationData.push(hex"424242474900c7fccbfc721cfb0155000c0e");
        locationData.push(hex"4a4d4b494e01125343fb6ba9430084000d0f");
        locationData.push(hex"434f435447009ec526fb7f6fde0114000e10");
        locationData.push(hex"5041434f4c008ed659fb3d0ea30150000f11");
        locationData.push(hex"504150434e0088b9b5fb41e66f013e001012");
        locationData.push(hex"45434d4543fff1c33efb304fbd0051011113");
        locationData.push(hex"5553484e4c01452c0ef69702ac007d011214");
        locationData.push(hex"434e53484101de028b074099640132011315");
        locationData.push(hex"434e4e474201c8f370074306cc0072001416");
        locationData.push(hex"54574b454c017f9efc0741cf5700f0011517");
        locationData.push(hex"434e584d4e0174f3620708f458005e011618");
        locationData.push(hex"54574b4848015839a5072bc02c00f0011917");
        locationData.push(hex"484b484b470154c41f06cd4bde015701181a");
        locationData.push(hex"564e44414400f5efb606733d8c008d01191b");
        locationData.push(hex"50484d4e4c00de89c10735c348002d011a1c");
        locationData.push(hex"564e53474e00a0505d0660cd050032001b1d");
        locationData.push(hex"534753494e001379e1062f3321012d001c1e");
        locationData.push(hex"4d59504b47002e0d1d060a94650002001d1f");
        locationData.push(hex"4944424c570039f9de05e25db1002f001e20");
        locationData.push(hex"5448484b540077568e05dd8cbd009f001f21");
        locationData.push(hex"494e49585a00b24afb0586ccb90026002022");
        locationData.push(hex"494e4d414100c7d61904c9520d0026002123");
        locationData.push(hex"4c4b434d42006a0f4304c275a7000c002224");
        locationData.push(hex"4d564d4c45003fcb9e04619bf70017002100");
 }

// returns a map of all locations, mapped to an index 0,1,2,3
function getAllLocations() public view returns (Location[] memory) {
    // decodes all location data entries and returns as an array
    Location[] memory locations = new Location[](locationData.length);
    for (uint i = 0; i < locationData.length; i++) {
        locations[i] = decodeLocation(locationData[i]);
    }
    return locations;
}

 function decodeLocation(bytes memory data) public pure returns (Location memory) {
        require(data.length >= 17, "Data is too short"); // Grundlegende Validierung

        string memory code;
        bytes5 codeBytes;
        int lat;
        int lng;
        int heading;
        bool isLeftSided;
        
        // Extrahieren und Konvertieren der Daten
        for (uint i = 0; i < 5; i++) {
            codeBytes |= bytes5(data[i]) >> (i * 8);
        }

        code = string(abi.encodePacked(codeBytes));

        lat = toInt32(data[5], data[6], data[7], data[8]);
        lng = toInt32(data[9], data[10], data[11], data[12]);
        heading = int (uint(uint8(data[14])) | (uint16(uint8(data[13])) << 8));
        isLeftSided = data[15] == 0x01;

        // Die Anzahl der Nachbarn und ihre Indizes müssen bekannt sein, um sie zu dekodieren
        uint8 neighboursCount = uint8(data.length) -16; // Angenommen, das nächste Byte gibt die Anzahl der Nachbarn an
        uint[] memory neighbours = new uint[](neighboursCount);
        for(uint i = 0; i < neighboursCount; i++) {
            neighbours[i] = uint(uint8(data[16 + i])); // Jeder Nachbar isst 1 Byte
        }

        return Location(code, lat, lng, heading, isLeftSided, neighbours);
    }

    // Hilfsfunktion zur Konvertierung von 4 Bytes zu int32
    function toInt32(bytes1 b1, bytes1 b2, bytes1 b3, bytes1 b4) private pure returns (int) {
    return int(uint(uint32(uint8(b4)) | (uint32(uint8(b3)) << 8) | (uint32(uint8(b2)) << 16) | (uint32(uint8(b1)) << 24)));
    }
}
