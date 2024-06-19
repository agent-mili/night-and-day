pragma solidity ^0.8.25;

import "./motifs/Motifs0.sol";
import "./motifs/Motifs1.sol";
import "./motifs/Motifs2.sol";
import "./motifs/GenericMotifs.sol";
import "./motifs/GenericMotifsSVG.sol";
import "./motifs/Assets.sol";


import"./NDDecoder.sol";
import "./NDUtils.sol";


import "./BasicMotif.sol";
contract NDMotifDataManager {


    

    uint constant GENERICS_COUNT = 100;
    uint constant GENERICS_START_INDEX = 19;
    uint constant BEACHES_START_INDEX = GENERICS_START_INDEX;
    uint constant SKYSCRAPERS_START_INDEX = GENERICS_START_INDEX + GENERICS_COUNT;
    uint constant LANDSCAPE_START_INDEX = GENERICS_START_INDEX + GENERICS_COUNT + GENERICS_COUNT;

    string constant MOTIF_TYPE_SIGHT_SEEING = "Sightseeing";
    string constant MOTIF_TYPE_BEACH = "Beach";
    string constant MOTIF_TYPE_SKYSCRAPER = "Skyscraper";
    string constant MOTIF_TYPE_LANDSCAPE = "Landscape";


      string public assets = Assets.getAssets();

     



    IMotifData public sightSeeing1;
    IMotifData public sightSeeing2;
    IMotifData public seightSeeing3;
    GenericMotifs public genericMotifs;
    GenericMotifsSVG public genericMotifsSVG;




     constructor(address _genericMotifAddress, address  _genericMotifSVGAddress ,address _motifAdress1, address _motifAdress2,  address _motifAdress3)  {

        genericMotifs =  GenericMotifs(_genericMotifAddress);
        genericMotifsSVG =  GenericMotifsSVG(_genericMotifSVGAddress);
        sightSeeing1 =  Motifs0(_motifAdress1);
        sightSeeing2 =  Motifs1(_motifAdress2);
        seightSeeing3 =  Motifs2(_motifAdress3);
     }

    function getMotifByTokenId(uint256 tokenId) public view returns (Motif memory) {
        
        require(tokenId < 320, "Token ID out of range");
        bytes memory motifData;

        Motif memory motif;
        MotifType motifType;


        if (tokenId < 19) {
            // handle sight seeing motifs
            motifType = MotifType.SIGHT_SEEING;

           if (tokenId < 7) {
               motifData = sightSeeing1.getMotifData(tokenId);
              }     
           else if (tokenId < 14) {

               motifData =  sightSeeing2.getMotifData(tokenId -7);
           }
           else {
                motifData = seightSeeing3.getMotifData(tokenId -14);
           }

           motif = NDDecoder.decodeMotif(motifData);
           motif.motifType = motifType;
        }
        else {
            motif = getGenericMotif(tokenId);
        }


 
        return motif;
    }


    function getGenericMotif(uint256 tokenId) public view returns (Motif memory) {

        GenericMotif memory genericMotif;

        bytes memory motifData;

        Motif memory motif;
        MotifType motifType;
        string memory svg;



        if (tokenId < 119) {

            motifType = MotifType.BEACH;
            //handle generic motifs
            motifData = genericMotifs.getBeach(tokenId - GENERICS_START_INDEX);
            svg = genericMotifsSVG.getBeachSVG();
        

        }
        else if (tokenId < 219) {

            motifType = MotifType.SKYSCRAPER;

            motifData = genericMotifs.getSkyscraper(tokenId - SKYSCRAPERS_START_INDEX);
            svg = genericMotifsSVG.getSkyscraperSVG();
        }
        else if (tokenId < 319) {

            motifType = MotifType.LANDSCAPE;

            motifData = genericMotifs.getLandscape(tokenId - LANDSCAPE_START_INDEX);
            svg = genericMotifsSVG.getLandscapeSVG();
        }


        genericMotif = NDDecoder.decodeGenericMotif(motifData);
        motif.name = genericMotif.name;
        motif.lat = genericMotif.lat;
        motif.lng = genericMotif.lng;
        motif.heading = genericMotif.heading;
        motif.svg = svg;
        motif.scenes = genericMotifsSVG.getScene(motifType);

        motif.horizon = int(genericMotifsSVG.getHorizon(motifType));
        motif.motifType = motifType;
        return motif;

    }

    function getBeachTraits(uint256 tokenId) public view returns (BeachTraits memory) {

        return genericMotifs.getBeachTraits(tokenId - BEACHES_START_INDEX);
    }

    function getSkinColor(uint256 tokenId) public view returns (string memory, string memory) {
        return genericMotifs.getSkinColor(tokenId - BEACHES_START_INDEX);
    }

    function getCityTraits(uint256 tokenId) public view returns (CityTraits memory) {
        return genericMotifs.getCityTraits(tokenId - SKYSCRAPERS_START_INDEX);
    }


    function getLandScapeTraits(uint tokenId) public view returns (LandscapeTraits memory) {
        return genericMotifs.getLandscapeTraits(tokenId - LANDSCAPE_START_INDEX);
    }

    //
    function getAssetInScene() public pure returns (AssetInScene[]  memory) {
        bytes memory assetsInScene = Assets.getAssetsInScene();

        return NDDecoder.decodeAssetsForScenes(assetsInScene);
    }


    function getSunflower() public pure returns (string memory, string memory, string memory, string memory) {


        string memory fullBlossom;
        string memory fullFlowerStick;
        int16[2] memory petalRotationAnchor = [int16(0), int16(-75)];
        string memory flowerStick = '<g fill="#9bb224"><rect x="-4" y="-74" width="8" height="74"/><!--leaf--></g>';
        string memory blossom = '<g fill="gold"><path d="M21-85C28-91 28-102 28-102C28-102 18-102 11-95C5-89 5-78 5-78C5-78 15-79 21-85Z" id="sunP"/><!--sunP--></g>';
        int[] memory petalRotations = NDDecoder.bytesToIntArray(hex"001E003C005A0078009600B400D200F0010E012C014A", 2);
        int16[] memory leafPos = new int16[](2);
        leafPos[0] = -3;
        leafPos[1] = 71;
        fullBlossom = NDUtils.setUseRotations(blossom, "sunP", petalRotations, petalRotationAnchor);
        fullFlowerStick = NDUtils.setUseTags(flowerStick, "sunP", leafPos , false, "leaf");
        string memory back = '<circle fill="#9bb224" cx="0" cy="-75" r="26"/>';
        string memory front = '<circle fill="#aa7035" cx="0" cy="-75" r="18"/>';

        return (fullBlossom, fullFlowerStick, back, front);

}


function getGentian() public pure returns (string memory, string memory, string memory, string memory) {

    int[] memory petalRotations = NDDecoder.bytesToIntArray(hex"001e003c005a0078009600b400d200f0010e012c014a", 2);

    string memory flowerStick = '<g style="transform:rotateY(<!--aziStick-->); transform-box:fill-box;  transform-origin:center"><polygon fill="#9BB224" points="-7.5,-52 8,-52 3,-3 -2.6,-3"/></g><path fill="#9BB224" d="M15.6,-6.3c5.9-5.8,6.2-15.2,6.2-15.2s-9.4,0.1-15.3,5.9c-5.9,5.8-6.2,15.2-6.2,15.2S9.6,-0.5,15.6,-6.3z"/><path fill="#9BB224" d="M-15,-6.3c-5.9-5.8-6.2-15.2-6.2-15.2s9.4,0.1,15.3,5.9c5.9,5.8,6.2,15.2,6.2,15.2S-9.6,-0.5,-15,-6.3z"/>';


    string memory back = '<circle fill="#9BB224" cx="0.2" cy="-52" r="7.8" />';
    string memory front = '<circle  stroke-width="3.5" stroke="#B959ED" fill="#9300E2" cy="-52" r="12.5" /><circle fill="#FFFFFF" cx="-4" cy="-55" r="2.2"/><circle fill="#FFFFFF" cx="4" cy="-55" r="2.2"/><circle fill="#FFFFFF" cx="0" cy="-48" r="2.2"/>';

    int16 [2] memory petalRotationAnchor = [int16(0), int16(-52)];
    string memory petal = '<path id="epetal" fill="#EACCF9" d="M0.8,-68.8c-1.8-6.2-7.9-9.9-7.9-9.9s-3.4,6.4-1.8,12.5c1.7,6.2,7.9,9.8,7.9,9.8S2.5,-62.6,0.8,-68.8z"/>';
    string memory blossom = NDUtils.setUseRotations(string.concat('<g>', petal , '<!--epetal--></g>'), "epetal", petalRotations, petalRotationAnchor);

    return (blossom, flowerStick, back, front);

}


function getRose() public pure returns (string memory, string memory, string memory, string memory) {

    string memory back = '<path fill="#9cb026" d="M8,-140.4a10.8,10.8,0,0,0-4.8-.6,12.4,12.4,0,0,0,.1-4.9,11.7,11.7,0,0,0-3.5,3.3,11.8,11.8,0,0,0-3.7-3,11.2,11.2,0,0,0,.4,4.8,10.3,10.3,0,0,0-4.7,1,11.5,11.5,0,0,0,4,2.7,11,11,0,0,0-2.2,4.3,12.1,12.1,0,0,0,4.6-1.5,10.7,10.7,0,0,0,2,4.4,11.3,11.3,0,0,0,1.8-4.5,10.1,10.1,0,0,0,4.6,1.1,10.8,10.8,0,0,0-2.4-4.1A12,12,0,0,0Z" />';
    string memory front = '<circle fill="#f7d60d" cy="-138" r="7"/><circle fill="#fcef9e" cy="-138" r="4.7"/>'; 

    string memory blossom = '<path fill="#e6332a" d="M18.6 -133a5.9 5.9 0 003.8-7.4 6 6 0 00-3.6-3.7 6.4 6.4 0 00.7-5.1 6 6 0 00-7.4-3.7 6.1 6.1 0 00-2.4 1.5 6.1 6.1 0 00.7-2.8 5.9 5.9 0 00-5.9-5.8 5.6 5.6 0 00-4.6 2.3A5.9 5.9 0 00 -10.6 -154a6 6 0 00.7 2.7 6.1 6.1 0 00-2.4-1.5 5.8 5.8 0 00-6.6 8.9 5.8 5.8 0 00-3.6 3.7 5.9 5.9 0 003.8 7.4 7.5 7.5 0 002.8.2 6.5 6.5 0 00-2.2 1.8 5.8 5.8 0 001.4 8.2 6 6 0 005 .9 5.8 5.8 0 002.5 4.5 5.7 5.7 0 008.1-1.4 6.1 6.1 0 001.1-2.5 5.4 5.4 0 001.1 2.6 5.7 5.7 0 008.1 1.2 5.4 5.4 0 002.4-4.5 5.9 5.9 0 005.1-.9 5.8 5.8 0 001.2-8.2 6.4 6.4 0 00-2.1-1.8 5.7 5.7 0 002.8-.2zm-16.9-2.4a4.9 4.9 0 00-1.8 2 6 6 0 00-1.8-2.1 5.5 5.5 0 00-2.5-1 5.5 5.5 0 001.5-2.4 6.2 6.2 0 00.2-2.7 6 6 0 002.7.7 5.9 5.9 0 002.6-.7 6.7 6.7 0 00.2 2.8 5.9 5.9 0 001.4 2.3 5.1 5.1 0 00-2.5 1.1z" /><path fill="#eaccf9" d="M10.6 -141.3a6 6 0 00-5.2-4 5.8 5.8 0 00-5.5-3.7 5.9 5.9 0 00-5.4 3.7 5.9 5.9 0 00-5.2 4 6.1 6.1 0 001.8 6.3 5.7 5.7 0 002.3 6.2 5.7 5.7 0 006.5.3 5.9 5.9 0 006.6-.3 5.7 5.7 0 002.2-6.1 5.9 5.9 0 001.9-6.4z" />';

    string memory flowerStick = '<path fill="#9cb026" d="M36 -100.6c4.7-.6 8-4.7 8-4.7s-4.3-3.2-8.9-2.6-8 4.7-8 4.7 4.2 3.2 8.9 2.6zM27.1 -92c4 2.5 9.2 1.4 9.2 1.4s-1.3-5.1-5.3-7.6-9.1-1.5-9.1-1.5 1.2 5.1 5.2 7.7zM19  -88c2.9 3.7 8.2 4.4 8.2 4.4s.5-5.2-2.4-8.9-8.2-4.5-8.2-4.5-.5 5.3 2.4 9zM11.1 -85.6c1.7 4.3 6.5 6.6 6.5 6.6s2-4.9.3-9.3-6.5-6.6-6.5-6.6-2 4.8-.3 9.3z" /><path fill="#9cb026" d="M18.8 -107.7c.2-4.7 4-8.3 4-8.3s3.5 3.9 3.3 8.6-4 8.4-4 8.4-3.5-3.9-3.3-8.7zM10.7 -104c-1.4-4.5 1-9.2 1-9.2s4.7 2.5 6 7-1 9.3-1 9.3-4.6-2.6-6-7.1zM3.3 -98c-2.7-3.9-1.8-9.2-1.8-9.2s5.2 1.1 7.9 5 1.7 9.2 1.7 9.2-5.2-1.1-7.8-5z" /><path fill="none" stroke="#9cb026" stroke-linecap="round"  stroke-width="3" d="M-0.2 -138c-.2.3-3.4 7-3.7 22.2s14.2 58-1.1 115"/> <path fill="none" stroke="#9cb026"  stroke-width="2" d="M0.7 -84.6s13.6-14.9 27.8-18.5" />';

    return (blossom, flowerStick, back, front);

}





}