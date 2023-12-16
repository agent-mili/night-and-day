// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;


enum RenderDataType {

    POSITIONS,POSISTIONSANDSCALE,POSITIONSANDTWOSCALES
}

enum ObjectType {
    USE,RECT,CIRCLE
}

enum MotifType{
    SightSeeing, Beach, Parc, Cockpit, Cargo, Skyscraper
}


struct Replacement {
    ObjectType tag;
    RenderDataType dataType;
    bytes data;
    bytes5 placeholder;
    bytes5 ref;
}

enum DAYTIME {
    DAY, NIGHT, NIGHT_AND_DAY
}

struct AssetInScene {
    string name;
    uint256 minDuration;
    uint256 maxDuration;
    uint256 checkInterval;
    uint256 possibleOffset;
    uint256 probability;
    DAYTIME daytime;
    } 

    struct SceneInMotif {
        string name;
        AssetInScene[] assets;
        uint256[4] viewingRange;
    }



struct Motif {
        uint256 tokenId;
        string name;
        uint256 lat;
        uint256 lng;
        uint16 lookingDirection;
        uint16 horizon;
        string svg;
        SceneInMotif[] scenes;
        Replacement[] replacements;
        MotifType motifType;
    }
interface IMotif {
    
    // function that returns a motif struct
    function getMotif() external view returns (Motif memory);

}