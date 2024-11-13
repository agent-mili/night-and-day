// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
// import "../contracts/motifs/GenericMotifs.sol";
// import "../contracts/motifs/GenericMotifsSVG.sol";
// import "../contracts/motifs//Motifs0.sol";
// import "../contracts/motifs/Motifs1.sol";
// import "../contracts/motifs/Motifs3.sol";

// import "../contracts/motifs/Assets.sol";

import "../contracts/NAD.sol";
import "../contracts/NDRenderer.sol";


contract NADTest is Test {
     NAD public nandd;

     NDRenderer public nDRenderer;


    function setUp() public {

        nandd = NAD(0xf4fa0d1C10c47cDe9F65D56c3eC977CbEb13449A);
        nDRenderer = NDRenderer(0xF94AB55a20B32AC37c3A105f12dB535986697945);
        //Contract deployment und Setup
        // GenericMotifs genericMotif = new GenericMotifs();
        // GenericMotifsSVG genericMotifSVG = new GenericMotifsSVG();

        // Motifs0 motif0 = new Motifs0();
        // Motifs1 motif1 = new Motifs1();
        // Motifs3 motif2 = new Motifs2();

    

        // // Foundry unterstützt derzeit keine dynamische Link-Bibliothek in der Deployment-Phase, daher muss dies vorab im Solidity-Code behandelt werden.
        // NDMotifDataManager ndMotifDataManager = new NDMotifDataManager(
        //     address(genericMotif), 
        //     address(genericMotifSVG), 
        //     address(motif0), 
        //     address(motif1)
        //     address(motif3)
        // );

        // nandd = new NAD(
        //     address(ndMotifDataManager)
        // );
    }
 
    //  function testToken0UriWithTime() view public {
    //         string memory tokenURI = nandd.tokenUriWithTime(186, 1722670738103);
    //         assertEq(nandd.totalSupply(), 0); 
    //     }


    
    //  function testToken1UriWithTime() view public {
    //         string memory tokenURI = nandd.tokenUriWithTime(0, 1721811687);
    //         assertEq(nandd.totalSupply(), 0); 
    //     }

    
    
    //  function testToken2UriWithTime() view public {
    //         string memory tokenURI = nandd.tokenUriWithTime(2, 1721811687);
    //         assertEq(nandd.totalSupply(), 0); 
    //     }

    
    //  function testToken3UriWithTime() view public {
    //         string memory tokenURI = nandd.tokenUriWithTime(3, 1721811687);
    //         assertEq(nandd.totalSupply(), 0); 
    //     }

    //  function testToken4UriWithTime() view public {
    //         string memory tokenURI = nandd.tokenUriWithTime(4, 1721811687);
    //         assertEq(nandd.totalSupply(), 0); 
    //     }
    
    //     function testToken5UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(5, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken6UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(6, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }   


    //     function testToken7UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(7, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }   

    //     function testToken8UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(8, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken9UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(9, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken10UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(10, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken11UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(11, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken12UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(12, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken13UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(13, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken14UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(14, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken15UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(15, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken16UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(16, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

    //     function testToken17UriWithTime() view public {
    //             string memory tokenURI = nandd.tokenUriWithTime(17, 1721811687);
    //             assertEq(nandd.totalSupply(), 0); 
    //         }

        // function testToken18UriWithTime() view public {
        //         string memory tokenURI = nandd.tokenUriWithTime(18, 1721811687);
        //         assertEq(nandd.totalSupply(), 0); 
        //     }

        

    
  

    function testMint() public {

        address testUser = vm.addr(1);
        vm.startPrank(testUser);
        nandd.mint{value: .001 ether}();
        vm.stopPrank();
        assertEq(nandd.totalSupply(), 1);
    } 

      }

