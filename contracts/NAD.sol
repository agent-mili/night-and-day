// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import Strings lib
import "@openzeppelin/contracts/utils/Strings.sol";
import "./motifs/Colosseum.sol";
import "./motifs/TajMahal.sol";
import "./BasicMotif.sol";


contract NAD is ERC721 {
     using Strings for uint256;
     using Strings for int256;

    bytes constant roundByteData = hex"032A010B00B90208015700F700860174006F00670073006D0063005E0052004B0045003B003800380036003500340033003200310030002F002F002E002D002C002B002A00290028012B00F2011800E7010600D501F400C301EA00B101E000A201D6009301CC008401C2007501B8006601AE005800A4004B009E003E0098003300920028008C001D0086001200800007007A00FB007500F4006F00ED006900E6006300DF005D00D8005700D1005100CA004B00C4004500BD003F00B7003900B1003300AB002D00A50027009F00";
    bytes constant bushData = hex"003d022502240064009f0218004f00ef020d003f012d02070032015d02000028018501fc002003fb04250224006403990218004f0349020d003f030b0207003202b301fc0020";
    bytes constant turretData = hex"00e701b0027000e70157020000e701de006f00e7011301a5013901d801f50139018901af01390127006f013901540162035101b00270035101570200035100de006f0351011301a502ff01d801f502ff018901af02ff0127006f02ff0154016201b80125006f0168015b006f019a015b006f02800125006f02c8015b006f029e015b006f021c006d0094021c009f0094";
    bytes constant roofData = hex"01b8014900a70280014900a7018401ca006f01841a006f01b201ca006f01b21a006f02b401ca006f02b41a006f028601ca006f02861a006f00e701f400640139013b0054035101f4006402ff013b0054";
    bytes constant trurret2Data = hex"01cf013e006f0269013e006f";


    Replacement bushReplacement = Replacement({
        tokenId: 2,
        tag: ObjectType.USE,
        dataType: RenderDataType.POSISTIONSANDSCALE,
        data: bushData,
        placeholder: "bush",
        ref: "bush"
    });

    Replacement  turretReplacement = Replacement({
        tokenId: 2,
        tag: ObjectType.USE,
        dataType: RenderDataType.POSISTIONSANDSCALE,
        data: turretData,
        placeholder: "turet",
        ref: "turet"
    });

    Replacement  roofReplacement = Replacement({
        tokenId: 2,
        tag: ObjectType.USE,
        dataType: RenderDataType.POSISTIONSANDSCALE,
        data: roofData,
        placeholder: "roof",
        ref: "roof"
    });


    Replacement  trurret2Replacement = Replacement({
        tokenId: 2,
        tag: ObjectType.USE,
        dataType: RenderDataType.POSISTIONSANDSCALE,
        data: trurret2Data,
        placeholder: "ture2",
        ref: "rure2"
    });

    Replacement roundReplacement = Replacement({
            tokenId: 1,
            tag: ObjectType.USE,
            dataType: RenderDataType.POSITIONSANDTWOSCALES,
            data: roundByteData,
            placeholder: "round",
            ref: "round"
            }); 


     
    constructor(address _sam) ERC721("Night And Day", "N&D") {

        

      


    }


    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        _requireOwned(tokenId);

        generateNFT(tokenId);
    }

    function generateNFT(uint256 tokenId) public view returns (string memory) {

        Motif memory motif;
        if (tokenId == 1) motif = Colosseum.getMotif();
        else motif = TajMahal.getMotif();

       // iterate replacements 
       /* Replacement[] memory replacements = motif.replacements;

         for (uint i = 0; i < replacements.length; i++) {
              Replacement memory replacement = replacements[i];
         } */
        
    }

    function getMotive(string memory motive) public pure returns (string memory) {

     
   }

    /* function generateClouds(uint nonce) public view returns (string memory) {
        uint numClouds = NDUtils.randomNum(nonce++, 1, 10);
        string memory clouds = '';
        for (uint i = 0; i < numClouds; i++) {

            uint layers = NDUtils.randomNum(nonce++, 1, 3);
            uint y = NDUtils.randomNum(nonce++, 0, 400);
            uint baseX = NDUtils.randomNum(nonce++, 0, 1080);
            for (uint j = 0; j < layers; j++) {
                int x = int(NDUtils.randomNum(nonce++, 10, 50));
                // shuffle whetver x is positive or negative
                if (NDUtils.randomNum(nonce++, 0, 1) == 1) {
                    x = -x;
                }
                x += int(baseX);
                uint width = NDUtils.randomNum(nonce++, 100, 300);
                uint height = NDUtils.randomNum(nonce++, 20, 30);

                //concat clouds in one string
                clouds = string.concat(clouds, '<g><path fill="#FFF" d="M', x.toStringSigned(), ' ', y.toString(), 'h', width.toString(), 'v', height.toString(), 'H', x.toStringSigned(), 'z"/></g>');
                y += height;
            }
        } 

        return clouds;
    } */
      

 /*    function generateSun(uint lkd, uint skyHeight ,uint azimuth,int altitude) public view returns (string memory) {
          

        //map sun position into illustration
        //check first if sun is visible in the viewing range horizontal and vertical and consider own direction angle
        if (altitude > -12 && altitude < int(viewingRangeVertical)) {
            if (azimuth > lkd - viewingRangeHorizontal / 2 && azimuth < lkd + viewingRangeHorizontal / 2) {
                //calculate the position of the sun in the illustration
                int x = int (skyWidth / 2 + (azimuth - lkd) / viewingRangeHorizontal * skyWidth);

                int y = int(int(skyHeight / 2) - altitude / int(viewingRangeVertical * skyHeight));

                string memory sun = string.concat('<g><circle cx="', x.toStringSigned(), '" cy="', y.toStringSigned(), '" r="58" fill="#fff"></circle></g>');
                return sun;
            }
            
            return ''; 
        }
    } */



}

