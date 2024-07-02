pragma solidity ^0.8.25;

import "./motifs/Motifs0.sol";
import "./motifs/Motifs1.sol";
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
    GenericMotifs public genericMotifs;
    GenericMotifsSVG public genericMotifsSVG;




     constructor(address _genericMotifAddress, address  _genericMotifSVGAddress ,address _motifAdress1, address _motifAdress2)  {

        genericMotifs =  GenericMotifs(_genericMotifAddress);
        genericMotifsSVG =  GenericMotifsSVG(_genericMotifSVGAddress);
        sightSeeing1 =  Motifs0(_motifAdress1);
        sightSeeing2 =  Motifs1(_motifAdress2);
     }

    function getMotifByTokenId(uint256 tokenId) public view returns (Motif memory) {
        
        require(tokenId < 320, "Token ID out of range");
        bytes memory motifData;

        Motif memory motif;
        MotifType motifType;


        if (tokenId < 19) {
            // handle sight seeing motifs
            motifType = MotifType.SIGHT_SEEING;

           if (tokenId < 12) {
               motifData = sightSeeing1.getMotifData(tokenId);
              }     
           else  {

               motifData =  sightSeeing2.getMotifData(tokenId -12);
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
        MotifType motifType = tokenId < 119 ? MotifType.BEACH : tokenId < 219 ? MotifType.SKYSCRAPER : MotifType.LANDSCAPE;
        bytes memory flzBytesSVG;

        (bytes memory flzGenericMotifs, uint startIndex, uint endIndex) = genericMotifs.getGeneric(tokenId - GENERICS_START_INDEX);
        
        bytes memory genericMotifs = NDDecoder.flzDecompress(flzGenericMotifs);
        motifData = new bytes(endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            motifData[i - startIndex] = genericMotifs[i];
        }
        
        
        flzBytesSVG = genericMotifsSVG.getGenericSVG(motifType);

        string memory svg = string(NDDecoder.flzDecompress(flzBytesSVG));

        genericMotif = NDDecoder.decodeGenericMotif(motifData);
        motif.name = genericMotif.name;
        motif.lat = genericMotif.lat;
        motif.lng = genericMotif.lng;
        motif.heading = genericMotif.heading;
        motif.svg = svg;
        (motif.scenes, ) = NDDecoder.decodeSceneIMotif(genericMotifsSVG.getScene(motifType),0);

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

    function getFlower(FlowerType flowerType) public pure returns (FlowerParts memory) {

        if (flowerType == FlowerType.SUNFLOWER) {
            return getSunflower();
        }
        else if (flowerType == FlowerType.GENTIAN) {
            return getGentian();
        }
        else if (flowerType == FlowerType.ROSE) {
            return getRose();
        }
        else if (flowerType == FlowerType.MOONFLOWER) {
            return getMoonflower();
        }
    }


    function getSunflower() public pure returns (FlowerParts memory) {

        FlowerParts memory flowerSVG;


        string memory fullBlossom;
        string memory fullFlowerStick;
        int16[2] memory petalRotationAnchor = [int16(0), int16(-75)];
        flowerSVG.stick = '<g fill="#9bb224"><rect x="-4" y="-74" width="8" height="74"/>$l</g>';
        flowerSVG.blossom = '<g fill="gold"><path d="M21-85C28-91 28-102 28-102C28-102 18-102 11-95C5-89 5-78 5-78C5-78 15-79 21-85Z" id="s-leaf"/>$1</g>';
        int[] memory petalRotations = NDDecoder.bytesToIntArray(hex"001E003C005A0078009600B400D200F0010E012C014A", 2);
        int16[] memory leafPos = new int16[](2);
        leafPos[0] = -3;
        leafPos[1] = 71;
        flowerSVG.blossom = NDUtils.setUseRotations(flowerSVG.blossom, "s-leaf", "$1", petalRotations, petalRotationAnchor);
        flowerSVG.stick  = NDUtils.setUseTags( flowerSVG.stick, "s-leaf", leafPos , false, "$l");
        flowerSVG.back = '<circle fill="#9bb224" cy="-75" r="26"/>';
        flowerSVG.front = '<circle fill="#aa7035" cy="-75" r="18"/>';

        return flowerSVG;

}


function getGentian() public pure returns (FlowerParts memory) {

    FlowerParts memory flowerSVG;

    int[] memory petalRotations = NDDecoder.bytesToIntArray(hex"001e003c005a0078009600b400d200f0010e012c014a", 2);

    flowerSVG.stick = '<g style="transform:rotateY($azis);transform-box:fill-box;transform-origin:center">'
    '<polygon fill="#9BB224" points="-7.5,-52 8,-52 3,-3 -2.6,-3"/></g>'
    '<path id="g-leaf" fill="#9BB224" d="M15,-6.3c5.9-5.8,6.2-15.2,6.2-15.2s-9.4,0.1-15.3,5.9c-5.9,5.8-6.2,15.2-6.2,15.2S9.6,-0.5,15.6,-6.3z"/>'
    '<use href="#g-leaf" transform="scale(-1,1)"/>';


    flowerSVG.back = '<circle fill="#9BB224" cy="-52" r="7.8"/>';
    flowerSVG.front = '<circle stroke-width="3.5" stroke="#B959ED" fill="#9300E2" cy="-52" r="12.5"/>'
    '<circle fill="#FFFFFF" cx="-4" cy="-55" r="2.2"/><circle fill="#FFFFFF" cx="4" cy="-55" r="2.2"/><circle fill="#FFFFFF" cy="-48" r="2.2"/>';

    int16 [2] memory petalRotationAnchor = [int16(0), int16(-52)];
    string memory petals = '$1<path id="g-petal" fill="#EACCF9" d="M1,-69c-1.8-6.2-7.9-9.9-7.9-9.9s-3.4,6.4-1.8,12.5c1.7,6.2,7.9,9.8,7.9,9.8S2.5,-62.6z"/>';
    flowerSVG.blossom = NDUtils.setUseRotations(petals , "g-petal", "$1", petalRotations, petalRotationAnchor);

    return flowerSVG;

}


function getRose() public pure returns (FlowerParts memory) {

    FlowerParts memory flowerSVG;
    int[] memory petalRotations = NDDecoder.bytesToIntArray(hex"0048009000d80120", 2);
    flowerSVG.back = '<path fill="#9cb026" d="M8,-140.4a10.8,10.8,0,0,0-4.8-.6,12.4,12.4,0,0,0,.1-4.9,11.7,11.7,0,0,0-3.5,3.3,11.8,11.8,0,0,0-3.7-3,11.2,11.2,0,0,0,.4,4.8,10.3,10.3,0,0,0-4.7,'
    '1,11.5,11.5,0,0,0,4,2.7,11,11,0,0,0-2.2,4.3,12.1,12.1,0,0,0,4.6-1.5,10.7,10.7,0,0,0,2,4.4,11.3,11.3,0,0,0,1.8-4.5,10.1,10.1,0,0,0,4.6,1.1,10.8,10.8,0,0,0-2.4-4.1A12,12,0,0,0Z" />';
    flowerSVG.front = '<circle fill="#f7d60d" cy="-138" r="7"/><circle fill="#fcef9e" cy="-138" r="4.7"/>'; 

    string memory blossom = '<g><path id="r-leaf" fill="#e6332a" d="M0-121c.13 1 .5 2 1.1 3 1.9 2 5.5 3 8.1 1 1.8-1 2.4-3 2.4-5 1.7 1 3.4 0 5.1-.7 2.6-1.9 3.1-5.6 1.2-8.3-.56-.6-1.3-1.2-2.1-1.7L1.9-139l-3 1.6z" />$p'
    '<path fill="#eaccf9" d="M10.6 -141.3a6 6 0 00-5.2-4 5.8 5.8 0 00-5.5-3.7 5.9 5.9 0 00-5.4 3.7 5.9 5.9 0 00-5.2 4 6.1 6.1 0 001.8 6.3 5.7 5.7 0 002.3 6.2 5.7 5.7 0 006.5.3 5.9 5.9 0 006.6-.3 5.7 5.7 0 002.2-6.1 5.9 5.9 0 001.9-6.4z" /></g>';

    flowerSVG.blossom = NDUtils.setUseRotations(blossom, "r-leaf", "$p", petalRotations, [int16(0), -138]);

    flowerSVG.stick = '<path fill="#9cb026" d="M36 -100.6c4.7-.6 8-4.7 8-4.7s-4.3-3.2-8.9-2.6-8 4.7-8 4.7 4.2 3.2 8.9 2.6zM27.1 -92c4 2.5 9.2 1.4 9.2 1.4s-1.3-5.1-5.3-7.6-9.1-1.5-9.1-1.5 1.2 5.1 5.2 7.7z'
    'M19 -88c2.9 3.7 8.2 4.4 8.2 4.4s.5-5.2-2.4-8.9-8.2-4.5-8.2-4.5-.5 5.3 2.4 9zM11.1 -85.6c1.7 4.3 6.5 6.6 6.5 6.6s2-4.9.3-9.3-6.5-6.6-6.5-6.6-2 4.8-.3 9.3z" />'
    '<path fill="#9cb026" d="M18.8 -107.7c.2-4.7 4-8.3 4-8.3s3.5 3.9 3.3 8.6-4 8.4-4 8.4-3.5-3.9-3.3-8.7zM10.7 -104c-1.4-4.5 1-9.2 1-9.2s4.7 2.5 6 7-1 9.3-1 9.3-4.6-2.6-6-7.1zM3.3 -98c-2.7-3.9-1.8-9.2-1.8-9.2s5.2 1.1 7.9 5 1.7 9.2 1.7 9.2-5.2-1.1-7.8-5z" />'
    '<path fill="none" stroke="#9cb026" stroke-linecap="round" stroke-width="3" d="M-0.2 -138c-.2.3-3.4 7-3.7 22.2s14.2 58-1.1 115"/> <path fill="none" stroke="#9cb026" stroke-width="2" d="M0.7 -84.6s13.6-14.9 27.8-18.5" />';

    return flowerSVG;

}

function getMoonflower() public pure returns (FlowerParts memory) {

    FlowerParts memory flowerSVG;

    flowerSVG.back = '<rect x="-5" y="-128" width="10" height="12" rx="5" ry="5" fill="#9cb026"/>';
    flowerSVG.front = '<path fill="#f7d60d" d="M5-121l12 24-17-20-17 20 13-23-24-10 26 5 3-25 3 26 24-6z"/>';
    flowerSVG.blossom = '<path fill="#fff" d="M20-95l1-19 10-17-18-8-13-16-13 16-18 7 9 18 2 19 20-4 20 4z"/>';

    flowerSVG.stick = '<path fill="#ccc" d="M-22-23l19-43 24 14-5 38 9 14h-51l4-23z"/>'
    '<path id="m-leaf" d="M-13-32l-4-8h-7l-5 17s1 5 1 7-2 6-2 6 4-3 5-4 7-1 7-1l15-9-2-7-9-2z" fill="#9cb026"/>'
    '<use href="#m-leaf" transform="matrix(.85 0 0 .85 15 -50)" />'
    '<use href="#m-leaf" transform="rotate(-75 -13 -66) scale(1.15)" />'
    '<path d="M0-121s-2 35 3 45c5 12 26 24-8 40-22 10-15 40 22 22" fill="none" stroke="#9cb026" stroke-width="4"/>';

    return flowerSVG;


}

}