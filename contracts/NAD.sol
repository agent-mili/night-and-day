// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import Strings lib
import "@openzeppelin/contracts/utils/Strings.sol";
import "./motifs/Colosseum.sol";
import "./BasicMotif.sol";


contract NAD is ERC721 {
     using Strings for uint256;
     using Strings for int256;


    


     
    constructor(address _sam) ERC721("Night And Day", "N&D") {

      


    }


    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        _requireOwned(tokenId);

        return "1";
    }

    function generateNFT(uint256 tokenId) public view returns (string memory) {

       Motif memory motif = Colosseum.getMotif();

       // iterate replacements 
       Replacement[] memory replacements = motif.replacements;

         for (uint i = 0; i < replacements.length; i++) {
              Replacement memory replacement = replacements[i];
         }
        



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

