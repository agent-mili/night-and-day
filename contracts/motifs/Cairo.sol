// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;
import "../BasicMotif.sol";

string constant svg = "";



// implmenets interface IMotif
contract Cairo is IMotif {
    function getMotif() external view override returns (Motif memory) {}
}