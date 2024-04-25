// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/motifs/GenericMotifs.sol";
import "../contracts/motifs/GenericMotifsSVG.sol";
import "../contracts/motifs//Motifs0.sol";
import "../contracts/motifs/Motifs1.sol";
import "../contracts/motifs/Motifs2.sol";

import "../contracts/NAD.sol";

contract NADTest is Test {
     NAD public nandd;

    function setUp() public {
        // Contract deployment und Setup
        GenericMotifs genericMotif = new GenericMotifs();
        GenericMotifsSVG genericMotifSVG = new GenericMotifsSVG();

        Motifs0 motif0 = new Motifs0();
        Motifs1 motif1 = new Motifs1();
        Motifs2 motif2 = new Motifs2();

    

        // Foundry unterstützt derzeit keine dynamische Link-Bibliothek in der Deployment-Phase, daher muss dies vorab im Solidity-Code behandelt werden.
        NDMotifDataManager ndMotifDataManager = new NDMotifDataManager(
            address(genericMotif), 
            address(genericMotifSVG), 
            address(motif0), 
            address(motif1), 
            address(motif2)
        );

        nandd = new NAD(
            address(ndMotifDataManager)
        );
    }

    function testTokenUriWithTime() view private {

        // Da Foundry keine native Unterstützung für das Schreiben in Dateisysteme hat, kommentieren wir den fs.writeFileSync Teil aus.
        string memory tokenURI = nandd.tokenUriWithTime(120, 1712142140);
        // Validierung
        assertEq(tokenURI, "hello"); // Ersetze `erwarteterWert` mit dem tatsächlichen erwarteten Wert des tokenURI
    }

    function testMint() public {
        // Minting

         address testUser = vm.addr(1);
          vm.startPrank(testUser);
        nandd.mint();
        vm.stopPrank();
        // Validierung
        assertEq(nandd.totalSupply(), 1); // Ersetze `erwarteterWert` mit dem tatsächlichen erwarteten Wert des totalSupply
    }


    function testMintWithSignature() public {
        // Minting
        uint  privateKey = 0xb37e31f1c48f94e08a3c2d3529a116ce2152d5fdddfb31035a015bbb082d8057;
         address testUser = vm.addr(1);
         address metamask = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
         bytes32 digest = keccak256(abi.encodePacked());

         (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
         bytes memory signature = abi.encodePacked(r, s, v);
          vm.startPrank(testUser);
        nandd.reservedMint(signature);
        vm.stopPrank();
        // Validierung
        assertEq(nandd.totalSupply(), 1); // Ersetze `erwarteterWert` mit dem tatsächlichen erwarteten Wert des totalSupply
    }

      function testMintWithWrongSignature() private {
        // Minting
        uint  privateKey = 0xd58dce883fa4dd165a4e5b99d441642d7171fc4563d4e4aeef8f29954abe323d;
         address testUser = vm.addr(1);
         bytes32 digest = keccak256(abi.encodePacked(testUser));

         (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
         bytes memory signature = abi.encodePacked(r, s, v);
          vm.startPrank(testUser);
          vm.expectRevert();
         nandd.reservedMint(signature);
        vm.stopPrank();
        // Validierung
       // assertEq(nandd.totalSupply(), 1); // Ersetze `erwarteterWert` mit dem tatsächlichen erwarteten Wert des totalSupply
    }
}
