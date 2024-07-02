// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../contracts/motifs/GenericMotifs.sol";
import "../contracts/motifs/GenericMotifsSVG.sol";
import "../contracts/motifs//Motifs0.sol";
import "../contracts/motifs/Motifs1.sol";

import "../contracts/NAD.sol";


contract NADTest is Test {
   //  NAD public nandd;


    function setUp() public {
        // Contract deployment und Setup
        GenericMotifs genericMotif = new GenericMotifs();
        GenericMotifsSVG genericMotifSVG = new GenericMotifsSVG();

        Motifs0 motif0 = new Motifs0();
        Motifs1 motif1 = new Motifs1();

    

        // Foundry unterstützt derzeit keine dynamische Link-Bibliothek in der Deployment-Phase, daher muss dies vorab im Solidity-Code behandelt werden.
        NDMotifDataManager ndMotifDataManager = new NDMotifDataManager(
            address(genericMotif), 
            address(genericMotifSVG), 
            address(motif0), 
            address(motif1), 
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
}
