// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import "forge-std/console.sol";

import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract ERC721Reservations is ERC721, ReentrancyGuard, IERC2981 {

    using ECDSA for bytes32;
   // mapping(uint256 => bool) public usedIndexes;

  //  address private signerAddress = 0x09505292D5eae5504cEc5c8BA86e09e83C810AA9;

    uint256[] private shuffledTokenIds = [187,
 259,
 98,
 178,
 294,
 128,
 277,
 36,
 216,
 140,
 176,
 121,
 199,
 165,
 296,
 218,
 237,
 169,
 257,
 200,
 278,
 23,
 135,
 35,
 286,
 78,
 20,
 201,
 265,
 111,
 236,
 71,
 62,
 274,
 144,
 19,
 112,
 232,
 276,
 125,
 138,
 280,
 172,
 101,
 270,
 116,
 68,
 8,
 73,
 92,
 56,
 131,
 318,
 134,
 84,
 49,
 26,
 7,
 311,
 34,
 13,
 44,
 284,
 190,
 288,
 102,
 210,
 95,
 70,
 314,
 302,
 185,
 196,
 271,
 90,
 158,
 261,
 154,
 317,
 81,
 106,
 38,
 262,
 28,
 10,
 151,
 52,
 17,
 53,
 230,
 82,
 66,
 55,
 235,
 91,
 67,
 142,
 249,
 275,
 137,
 234,
 209,
 301,
 25,
 223,
 208,
 50,
 224,
 160,
 240,
 110,
 11,
 211,
 282,
 186,
 175,
 303,
 60,
 124,
 315,
 76,
 9,
 51,
 39,
 104,
 86,
 89,
 191,
 132,
 171,
 228,
 188,
 268,
 298,
 32,
 31,
 83,
 229,
 225,
 279,
 243,
 252,
 59,
 174,
 93,
 94,
 22,
 149,
 156,
 313,
 127,
 115,
 226,
 254,
 97,
 203,
 194,
 3,
 168,
 212,
 80,
 14,
 292,
 129,
 0,
 247,
 182,
 217,
 133,
 153,
 146,
 109,
 272,
 108,
 260,
 281,
 308,
 163,
 306,
 305,
 139,
 184,
 150,
 152,
 29,
 117,
 18,
 162,
 119,
 291,
 166,
 120,
 107,
 24,
 1,
 206,
 267,
 285,
 143,
 258,
 251,
 15,
 189,
 2,
 147,
 312,
 310,
 45,
 159,
 33,
 47,
 192,
 309,
 300,
 238,
 215,
 193,
 64,
 264,
 40,
 253,
 205,
 85,
 293,
 245,
 231,
 54,
 141,
 77,
 157,
 113,
 63,
 79,
 170,
 273,
 256,
 219,
 304,
 161,
 30,
 195,
 57,
 96,
 100,
 5,
 222,
 290,
 130,
 233,
 164,
 287,
 295,
 114,
 263,
 37,
 103,
 136,
 65,
 269,
 197,
 69,
 61,
 46,
 167,
 87,
 72,
 207,
 266,
 307,
 289,
 27,
 173,
 155,
 248,
 177,
 6,
 122,
 4,
 148,
 180,
 16,
 123,
 75,
 250,
 198,
 99,
 221,
 283,
 255,
 43,
 21,
 213,
 41,
 145,
 42,
 183,
 105,
 126,
 48,
 220,
 202,
 204,
 239,
 246,
 181,
 179,
 58,
 299,
 244,
 214,
 316,
 88,
 227,
 118,
 74,
 297,
 12,
 242,
 241];

    uint256 public reservedSupply = 50;
    uint256 public maxSupply = 450;
    uint public totalSupply = 0;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {

    }

    // function reservedMint(bytes memory signature, uint256 codeIndex) external nonReentrant {
    //       require(verifyAddressSigner(signature, codeIndex), "SIGNATURE_FAILED");
    //     require(totalSupply < maxSupply, "Max supply reached");
    //     require(reservedSupply > 0, "No reserved supply left");
                 
    //     uint randomId = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender))) % shuffledTokenIds.length;
    //     uint256 tokenId = shuffledTokenIds[randomId];
    //     shuffledTokenIds[randomId] = shuffledTokenIds[shuffledTokenIds.length - 1];
    //     shuffledTokenIds.pop();
    //     totalSupply += 1;
    //     reservedSupply -= 1;
    //     _safeMint(msg.sender, tokenId);
    // }

    function mint() external nonReentrant {
        require(totalSupply < maxSupply, "Max supply reached");
        uint randomId = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender))) % shuffledTokenIds.length;
        uint256 tokenId = shuffledTokenIds[randomId];
        shuffledTokenIds[randomId] = shuffledTokenIds[shuffledTokenIds.length - 1];
        shuffledTokenIds.pop();
        totalSupply += 1;
        _safeMint(msg.sender, tokenId);
    }

//  function verifyAddressSigner(bytes memory signature, uint256 index) public returns (bool) {
//         // Check if the index has already been used
//         require(!usedIndexes[index], "Index already used");

//         // Encode the message with the sender's address and the index
//         bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, index));
//         bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(messageHash);

//         // Recover the signer address from the signature
//         address recoveredAddress = ethSignedMessageHash.recover(signature);

//         // Check if the recovered address matches the signer's address
//         if (recoveredAddress == signerAddress) {
//             // Mark the index as used
//             usedIndexes[index] = true;
//             return true;
//         } else {
//             return false;
//         }
//     }


     struct RoyaltyInfo {
        address receiver;
        uint96 royaltyFraction;
    }

    RoyaltyInfo private _defaultRoyaltyInfo;

    /**
     * @dev The default royalty set is invalid (eg. (numerator / denominator) >= 1).
     */
    error ERC2981InvalidDefaultRoyalty(uint256 numerator, uint256 denominator);

    /**
     * @dev The default royalty receiver is invalid.
     */
    error ERC2981InvalidDefaultRoyaltyReceiver(address receiver);

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @inheritdoc IERC2981
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual returns (address, uint256) {
        RoyaltyInfo memory royalty = _defaultRoyaltyInfo;

        uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();

        return (royalty.receiver, royaltyAmount);
    }

    /**
     * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
     * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
     * override.
     */
    function _feeDenominator() internal pure virtual returns (uint96) {
        return 10000;
    }

    /**
     * @dev Sets the royalty information that all ids in this contract will default to.
     *
     * Requirements:
     *
     * - `receiver` cannot be the zero address.
     * - `feeNumerator` cannot be greater than the fee denominator.
     */
    function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
        uint256 denominator = _feeDenominator();
        if (feeNumerator > denominator) {
            // Royalty fee will exceed the sale price
            revert ERC2981InvalidDefaultRoyalty(feeNumerator, denominator);
        }
        if (receiver == address(0)) {
            revert ERC2981InvalidDefaultRoyaltyReceiver(address(0));
        }

        _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
    }

    /**
     * @dev Removes default royalty information.
     */
    function _deleteDefaultRoyalty() internal virtual {
        delete _defaultRoyaltyInfo;
    }


}
