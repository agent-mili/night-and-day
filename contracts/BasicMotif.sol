// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

enum ColorRenderType {
    HUMAN,BIRD,SHIP
}


enum RenderDataType {

    POSITIONS,POSISTIONSANDSCALE,POSITIONSANDTWOSCALES
}

enum FlowerType {
    SUNFLOWER,ROSE,GENTIAN, MOONFLOWER
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
    string shortsColorAttribute;
    string towelColor;
    string towelColorAttribute;
    uint accessoireType;
    string shortsPattern;
    string towelPattern;
    string shortsSVG;
    string towelSVG;
    uint jellyTypeId;
    string jellyColor;

}

struct CityTraits {
    string attributes;
    address priceFeed;
    string skylineSVG;
    string displaySVG;
    string tableSVG;
    uint displayType;
    uint skyLinetype;
    bool isCoastel;
    uint accessoireType;
    string tableColor;
    uint catTypeId;
    string catColor;
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
    string shirtColorAttribute;
    string shirtPattern;
    string hat;
    string pantsColor;
    string furnitureColor;
    string furnitureSVG;
    bool hasRiver;
    bool hasMountains;
    bool hasOcean;
    string artistSVG;
    uint catTypeId;
    string catColor;

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

          struct SunMoon {
        uint sunrise;
        uint sunset;
        int altitude;
        int azimuth;
        int moonAzimuth;
        int moonAltitude;
        int parallacticAngle;
        int fraction;
        int angle;
     }


    struct SceneElement {
        uint y;
        int x;
        int xScale;
        string svg;
        string posSalt;
        string decimalScaleX;
        string decimalScaleY;
    }


interface IMotifData {
    
    // function that returns a motif struct
    function getMotifData(uint index) external view returns (bytes memory);

}