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

    address private signerAddress = 0x09505292D5eae5504cEc5c8BA86e09e83C810AA9;

    uint256[] private shuffledTokenIds = [340,
 167,
 423,
 498,
 168,
 169,
 336,
 464,
 57,
 183,
 441,
 333,
 424,
 349,
 251,
 42,
 158,
 108,
 241,
 491,
 471,
 455,
 398,
 126,
 484,
 407,
 431,
 210,
 440,
 145,
 305,
 41,
 238,
 172,
 400,
 55,
 175,
 447,
 66,
 411,
 475,
 387,
 174,
 82,
 409,
 75,
 399,
 291,
 482,
 235,
 203,
 176,
 38,
 489,
 245,
 32,
 152,
 162,
 363,
 278,
 435,
 247,
 156,
 133,
 180,
 9,
 341,
 113,
 96,
 211,
 24,
 222,
 416,
 442,
 12,
 93,
 150,
 219,
 171,
 300,
 421,
 90,
 381,
 92,
 456,
 327,
 271,
 392,
 98,
 375,
 250,
 304,
 473,
 134,
 230,
 264,
 123,
 54,
 151,
 461,
 354,
 267,
 249,
 147,
 115,
 125,
 414,
 364,
 273,
 384,
 170,
 237,
 495,
 86,
 316,
 282,
 258,
 51,
 450,
 393,
 16,
 285,
 428,
 234,
 181,
 259,
 347,
 293,
 85,
 59,
 437,
 80,
 368,
 331,
 136,
 60,
 268,
 296,
 427,
 14,
 143,
 184,
 233,
 72,
 270,
 87,
 227,
 99,
 190,
 142,
 373,
 262,
 358,
 345,
 371,
 2,
 20,
 391,
 197,
 330,
 45,
 61,
 359,
 79,
 100,
 107,
 244,
 166,
 458,
 355,
 307,
 157,
 31,
 445,
 56,
 388,
 105,
 420,
 248,
 337,
 84,
 21,
 480,
 236,
 220,
 315,
 62,
 122,
 155,
 213,
 317,
 173,
 303,
 405,
 204,
 118,
 378,
 231,
 3,
 149,
 319,
 214,
 429,
 274,
 335,
 7,
 78,
 217,
 36,
 104,
 466,
 369,
 334,
 439,
 141,
 178,
 33,
 69,
 35,
 372,
 382,
 275,
 254,
 402,
 253,
 44,
 357,
 496,
 432,
 209,
 459,
 385,
 390,
 29,
 310,
 23,
 163,
 298,
 88,
 394,
 272,
 314,
 103,
 83,
 329,
 192,
 207,
 376,
 240,
 188,
 185,
 47,
 131,
 277,
 485,
 226,
 323,
 73,
 212,
 137,
 187,
 286,
 321,
 28,
 4,
 97,
 164,
 260,
 452,
 404,
 343,
 102,
 129,
 444,
 344,
 49,
 367,
 430,
 109,
 433,
 81,
 148,
 332,
 311,
 206,
 189,
 306,
 200,
 25,
 77,
 130,
 474,
 114,
 374,
 454,
 350,
 477,
 326,
 443,
 360,
 370,
 346,
 410,
 486,
 281,
 499,
 89,
 63,
 53,
 177,
 70,
 322,
 406,
 224,
 380,
 30,
 287,
 379,
 17,
 218,
 135,
 94,
 276,
 422,
 288,
 221,
 362,
 146,
 127,
 65,
 467,
 144,
 52,
 395,
 417,
 338,
 242,
 74,
 488,
 196,
 8,
 58,
 308,
 462,
 320,
 67,
 119,
 91,
 490,
 434,
 257,
 318,
 76,
 283,
 266,
 186,
 479,
 159,
 408,
 205,
 48,
 383,
 453,
 292,
 40,
 128,
 68,
 356,
 294,
 339,
 179,
 43,
 463,
 39,
 27,
 470,
 483,
 280,
 396,
 469,
 269,
 117,
 342,
 297,
 95,
 22,
 487,
 397,
 309,
 223,
 403,
 476,
 448,
 497,
 10,
 193,
 465,
 160,
 325,
 228,
 106,
 110,
 165,
 199,
 313,
 279,
 419,
 124,
 46,
 154,
 438,
 201,
 1,
 5,
 195,
 460,
 284,
 232,
 208,
 140,
 353,
 415,
 202,
 112,
 15,
 132,
 289,
 26,
 111,
 413,
 472,
 301,
 19,
 352,
 425,
 451,
 261,
 361,
 494,
 116,
 216,
 457,
 246,
 449,
 139,
 13,
 138,
 436,
 37,
 11,
 161,
 71,
 312,
 324,
 478,
 121,
 295,
 492,
 34,
 481,
 6,
 239,
 328,
 194,
 366,
 50,
 64,
 446,
 412,
 265,
 153,
 18,
 468,
 377,
 401,
 198,
 243,
 120,
 493,
 351,
 255,
 229,
 500,
 182,
 191,
 348,
 389,
 263,
 252,
 418,
 365,
 302,
 386,
 101,
 225,
 299,
 290,
 215,
 256,
 426];

    uint256 public reservedSupply = 50;
    uint256 public maxSupply = 450;
    uint public totalSupply = 0;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {

    }

    function reservedMint(bytes memory signature) external nonReentrant {
          require(verifyAddressSigner(signature), "SIGNATURE_VALIDATION_FAILED");
        require(totalSupply < maxSupply, "Max supply reached");
        require(reservedSupply > 0, "No reserved supply left");
                 
          uint randomId = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, totalSupply))) % shuffledTokenIds.length;
        uint256 tokenId = shuffledTokenIds[randomId];
        shuffledTokenIds[randomId] = shuffledTokenIds[shuffledTokenIds.length - 1];
        shuffledTokenIds.pop();
        totalSupply += 1;
        reservedSupply -= 1;
        console.log(tokenId);
        _safeMint(msg.sender, tokenId);
    }

    function mint() external nonReentrant {
        require(totalSupply < maxSupply, "Max supply reached");
      //  require(totalSupply >= reservedSupply, "Reserved supply not exhausted");
        uint randomId = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, totalSupply))) % shuffledTokenIds.length;
        uint256 tokenId = shuffledTokenIds[randomId];
        shuffledTokenIds[randomId] = shuffledTokenIds[shuffledTokenIds.length - 1];
        shuffledTokenIds.pop();
        totalSupply += 1;
        console.log(tokenId);
        _safeMint(msg.sender, tokenId);
    }

     function verifyAddressSigner(bytes memory signature) public view returns (bool) {
        console.logBytes(signature);
        console.log(msg.sender);
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender));
        console.logBytes32(messageHash);
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(messageHash);
        console.logBytes32(ethSignedMessageHash);

        return signerAddress == ethSignedMessageHash.recover( signature);
    }

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
