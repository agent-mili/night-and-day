// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;


enum RenderDataType {

    POSITIONS,POSISTIONSANDSCALE,POSITIONSANDTWOSCALES
}

enum FlowerType {
    SUNFLOWER,GENTIAN,ROSE, MOONFLOWER
}


enum ObjectType {
    USE,RECT,CIRCLE
}


enum BeachColor {
    PINK, GREEN, BLACK, GOLD, WHITE, CREME, RED
}

enum SkylineType {
    MEGA, LARGE, MIDI,MINI
}



enum MotifType {
    SIGHT_SEEING, BEACH, SKYSCRAPER, LANDSCAPE
}

struct FlowerParts {
    string  back;
    string  front;
    string  blossom;
    string  stick;
}




struct Replacement {
    ObjectType tag;
    RenderDataType dataType;
    int[] data;
    string placeholder;
    string ref;
}

enum DAYTIME {
    NIGHT, DAY, NIGHT_AND_DAY
}

struct AssetInScene {
    string name;
    uint minDuration;
    uint maxDuration;
    uint checkInterval;
    uint possibleOffset;
    uint probability;
    DAYTIME dayTime;
    } 

    struct SceneInMotif {
        string placeHolder;
        uint8[] assets;
        int[4] area;
        uint scale;
    }


struct GenericMotif {
    string name;
    int lat;
    int lng;
    int heading;
}

struct Motif {
        string name;
        int lat;
        int lng;
        int heading;
        int horizon;
        string svg;
        SceneInMotif[] scenes;
        Replacement[] replacements;
        MotifType motifType;
    }

struct BeachTraits {
    string attributes;
    string beachColor;
    string skinColor;
    string shortsColor;
    string towelColor;
    uint accessoireType;
    string shortsPattern;
    string towelPattern;
    string shortsSVG;
    string towelSVG;

}

struct CityTraits {
    string attributes;
    address priceFeed;
    string skylineSVG;
    string displaySVG;
    uint displayType;
    uint skyLinetype;
    bool isCoastel;
    uint accessoireType;
    string tableColor;
}


struct LandscapeTraits {
    string attributes;
    string accessoireType;
    string climateZoneColor;
    uint climateZoneIndex;
    string before;
    string front;
    bool hasCity;
    string skinColor;
    string shirtColor;
    string shirtPattern;
    string hat;
    string pantsColor;
    bool hasRiver;
    bool hasMountains;
    bool hasOcean;
    string artistSVG;

}


struct SVGData {

        string sunSVG;
        string skyColor;
        string moonSVG;
        string nightSVG;
        string waterColor;
        string cloudsSVG;
        string skySceneSVG;

     }


interface IMotifData {
    
    // function that returns a motif struct
    function getMotifData(uint index) external view returns (bytes memory);

}