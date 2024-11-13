// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

enum ColorRenderType {
    HUMAN,BIRD,SHIP
}


enum RenderDataType {

    POSITIONS,POSISTIONSANDSCALE,POSITIONSANDTWOSCALES
}

enum FlowerType {
    SUNFLOWER,ROSE,ICEFLOWER, MOONFLOWER
}


enum ObjectType {
    USE,RECT,CIRCLE
}


enum BeachColor {
    PINK, GREEN, BLACK, GOLD, WHITE, CREME, RED
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

struct MovingScene {
    string placeholder ;
    bool horizonUp ;
    MovingSceneAsset[] assets ;

}

struct MovingSceneAsset {

    string assetName ;
    uint minScale;
    uint maxScale ;
    uint minY ;
    uint maxY ;
    uint duration ;
    uint probability ;
    uint checkInterval ;
    uint possibleOffset ;
    DAYTIME dayTime ;

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
        Scene[] sceneDetails;
    }

struct Scene {

    int[4] area;
    uint[] assets;
    uint scale;
}



struct Motif {
        string name;
        int lat;
        int lng;
        int heading;
        uint horizon;
        string svg;
        SceneInMotif[] scenes;
        Replacement[] replacements;
        MovingScene[] movingScenes;
        MotifType motifType;
    }

struct BeachTraits {
    string attributes;
    string beachColor;
    string skinColor;
    string shortsColor;
    string shortsColorAttribute;
    string beverageAttribute;
    string towelColor;
    string towelColorAttribute;
    string shortsPattern;
    string towelPattern;
    string shortsSVG;
    string towelSVG;
    uint jellyTypeId;
    string jellyColor;
    string beverage;

}

struct CityTraits {
    string attributes;
    address priceFeed;
    string skylineSVG;
    string displaySVG;
    string beverageAttribute;
    string tableSVG;
    uint displayType;
    uint skyLinetype;
    bool isCoastel;
    string tableColor;
    uint catTypeId;
    string catColor;
    string beverage;
}


struct LandscapeTraits {
    string attributes;
    uint climateZoneIndex;
    string before;
    bool hasCity;
    string skinColor;
    string shirtColor;
    string shirtColorAttribute;
    string beverageAttribute;
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
    string beverage;

}


struct SVGData {

        string sunSVG;
        string skyColor;
        string moonSVG;
        string nightSVG;
        string replacements;
        string waterColor;
        string cloudsSVG;
        string skySceneSVG;
        string flowerSVG;

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