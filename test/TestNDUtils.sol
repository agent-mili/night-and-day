// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";

import "../contracts/NDUtils.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract NDUtilsTest is Test {
    // NDUtils public ndUtils;

    using Strings for uint256;
using Strings for int256;
using Strings for int16;


    function setUp() public {
    //    ndUtils = new NDUtils();
    }

    function testRandomNum() public {
        uint256[1000] memory counts;

        for (uint256 i = 19; i <= 118; i++) {
            //uint256 result = NDUtils.randomNum(string.concat("skin", i.toString()), 0,18);
            uint j = i * i;
             uint256 result = NDUtils.randomNum(string.concat('A', j.toString()), 0,999);
            console.log("RandomNum");
            console.logUint(result);
            //     uint256 result = NDUtils.randomNum(i, 0,2);
            counts[result]++;
        }

        //loggen der counts
 /*        console.log("Counts:");
        for (uint256 i = 0; i < counts.length; i++) {
            console.log("Index:");
            console.logUint(i);
            console.log("Value:");
            console.logUint(counts[i]);
        } */

        uint interval = 200;
        uint256[] memory intervals = new uint256[](counts.length / interval);

        // Überprüfen, ob die Zufallszahlen gleichmäßig in den intervallen verteilt sind
        // z..B. im intervall 1-10, 11-20, 21-30, ...
        for (uint256 i = 0; i < counts.length; i++) {
            intervals[i / interval] += counts[i];
        }

        //loggen der intervals
        console.log("Intervals:");
        for (uint256 i = 0; i < intervals.length; i++) {
            console.log("Index:");
            console.logUint(i);
            console.log("Value:");
            console.logUint(intervals[i]);
        }







        
        uint256 tolerance = 5; // Erlaubte Abweichung

        // Überprüfen, ob die Zufallszahlen gleichmäßig verteilt sind
        for (uint256 i = 0; i < counts.length; i++) {
            uint256 expected = 300 / counts.length;
            uint256 diff = counts[i] > expected ? counts[i] - expected : expected - counts[i];
            assertTrue(diff < tolerance, counts[i].toString());
        }
       
        
    }

}
