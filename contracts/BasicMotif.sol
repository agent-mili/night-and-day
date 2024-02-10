// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;


enum RenderDataType {

    POSITIONS,POSISTIONSANDSCALE,POSITIONSANDTWOSCALES
}

enum ObjectType {
    USE,RECT,CIRCLE
}

enum MotifType{
    SightSeeing, Beach, Parc, Skyscraper
}


struct Replacement {
    ObjectType tag;
    RenderDataType dataType;
    int[] data;
    string placeholder;
    string ref;
}

enum DAYTIME {
    DAY, NIGHT, NIGHT_AND_DAY
}

struct AssetInScene {
    string name;
    int minDuration;
    int maxDuration;
    int checkInterval;
    int possibleOffset;
    int probability;
    DAYTIME dayTime;
    } 

    struct SceneInMotif {
        string placeHolder;
        AssetInScene[] assets;
        int[4] area;
    }



struct Motif {
        string name;
        int lat;
        int lng;
        int lookingDirection;
        int horizon;
        string svg;
        SceneInMotif[] scenes;
        Replacement[] replacements;
    }


interface IMotif {
    
    // function that returns a motif struct
    function getMotif() external view returns (Motif memory);

}