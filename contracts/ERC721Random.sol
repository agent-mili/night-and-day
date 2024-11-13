// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";


import {IERC165, ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract ERC721Random is ERC721, Ownable, ReentrancyGuard, IERC2981 {


    uint256 public constant mintPrice = 0.05 ether;

     uint16[] public shuffledTokenIds = 
     [
  202,
  260,
  214,
  90,
  286,
  118,
  26,
  104,
  227,
  114,
  242,
  99,
  8,
  68,
  191,
  52,
  237,
  85,
  9,
  316,
  137,
  256,
  194,
  54,
  73,
  188,
  105,
  120,
  117,
  249,
  182,
  166,
  312,
  203,
  282,
  19,
  135,
  210,
  280,
  294,
  145,
  158,
  22,
  62,
  209,
  306,
  273,
  50,
  297,
  239,
  186,
  201,
  248,
  111,
  157,
  55,
  290,
  100,
  284,
  49,
  178,
  240,
  31,
  319,
  103,
  252,
  219,
  94,
  310,
  271,
  38,
  303,
  272,
  207,
  142,
  265,
  289,
  58,
  128,
  193,
  153,
  95,
  245,
  101,
  229,
  285,
  315,
  259,
  107,
  75,
  48,
  125,
  257,
  87,
  268,
  12,
  45,
  27,
  36,
  235,
  299,
  266,
  238,
  276,
  106,
  92,
  96,
  274,
  115,
  84,
  179,
  23,
  108,
  164,
  304,
  69,
  132,
  20,
  47,
  206,
  154,
  40,
  255,
  79,
  143,
  185,
  0,
  277,
  253,
  57,
  167,
  2,
  134,
  129,
  119,
  197,
  211,
  200,
  156,
  308,
  149,
  46,
  77,
  66,
  174,
  78,
  160,
  220,
  39,
  267,
  241,
  123,
  292,
  250,
  113,
  11,
  138,
  161,
  130,
  223,
  124,
  15,
  97,
  295,
  34,
  307,
  247,
  13,
  112,
  41,
  196,
  226,
  72,
  37,
  212,
  17,
  74,
  98,
  263,
  231,
  1,
  56,
  232,
  80,
  25,
  298,
  168,
  317,
  221,
  83,
  318,
  60,
  170,
  291,
  53,
  139,
  150,
  204,
  222,
  264,
  283,
  279,
  141,
  42,
  147,
  155,
  270,
  198,
  163,
  192,
  136,
  14,
  16,
  218,
  159,
  4,
  314,
  93,
  246,
  183,
  86,
  6,
  28,
  82,
  29,
  59,
  288,
  76,
  243,
  3,
  208,
  262,
  110,
  88,
  301,
  230,
  320,
  275,
  199,
  7,
  165,
  61,
  195,
  269,
  51,
  151,
  309,
  126,
  233,
  302,
  89,
  244,
  70,
  133,
  296,
  293,
  190,
  5,
  71,
  251,
  81,
  228,
  287,
  162,
  313,
  173,
  121,
  109,
  216,
  184,
  169,
  44,
  146,
  144,
  65,
  213,
  187,
  224,
  171,
  205,
  305,
  278,
  176,
  281,
  24,
  32,
  102,
  217,
  189,
  175,
  116,
  236,
  127,
  91,
  177,
  122,
  43,
  63,
  67,
  261,
  21,
  35,
  225,
  64,
  18,
  172,
  181,
  148,
  131,
  254,
  234,
  180,
  300,
  258,
  215,
  311,
  152,
  30,
  33,
  10,
  140
];




 

    uint256 public constant maxSupply = 321;

    //12% for giveaways and development team 
    uint256 public constant premintSupply = maxSupply * 12 / 100;
    uint public totalSupply = 0;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
        Ownable(msg.sender)
    {
        premint();
    }

    function premint() internal {
        require(totalSupply == 0, "Premint already called");
        for (uint i = 0; i < premintSupply; i++) {
            mintRandom();
        }
    }





    function mint() external payable nonReentrant {
        require(block.number >= 21194985, "Minting not allowed yet");
        require(msg.value >= mintPrice, "Insufficient funds");
        require(totalSupply < maxSupply, "Max supply reached");
        mintRandom();
    }

    function mintRandom() private  {
         uint randomId = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender))) % shuffledTokenIds.length;
         uint256 tokenId = shuffledTokenIds[randomId];
         shuffledTokenIds[randomId] = shuffledTokenIds[shuffledTokenIds.length - 1];
         shuffledTokenIds.pop();
        totalSupply += 1;
        _safeMint(msg.sender, tokenId);
    }

 function withdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "No Ether available to withdraw");
        payable(owner()).transfer(balance);
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
    function royaltyInfo(uint256, uint256 salePrice) public view virtual returns (address, uint256) {
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

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }
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
