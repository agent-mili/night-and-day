// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import Strings lib
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BasicMotif.sol";

import "./SunCalc.sol";
import "./NDRenderer.sol";
import "./NDAlgos.sol";

import "./motifs/Cairo.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
 


contract NAD is ERC721 {
     using Strings for uint256;
     using Strings for int256;

    
    string public constant assets = '<defs><g id="yacht" style="transform-origin:.700001px 143.85px"><path fill="<!--rdColor-->" d="M140.8-19.1H25.3l115.5-162.4z"/><path fill="#AA7035" d="M149.3-2.9H65.5L47.2-13.7h120.4z"/><path fill="#FFF" d="m103.6 0-6.4-8.5L0-.1z"/></g><g id="bush1"><path id="l1" fill="#9BB224" d="M-39 0c5 5 12 7 19 5L0 0l-21-5c-6-2-13 0-18 5"/><use href="#l1" transform="rotate(45)"/><use href="#l1" transform="rotate(90)"/><use href="#l1" transform="rotate(135)"/><use href="#l1" transform="rotate(180)"/></g><g id="bush2"><path id="l2" fill="#9BB224" d="M17-4 0-84-17-4z"/><use href="#l2" transform="rotate(36)"/><use href="#l2" transform="rotate(72)"/><use href="#l2" transform="rotate(-36)"/><use href="#l2" transform="rotate(-72)"/></g><g id="aeroplane" fill="#FBF8F5"><path d="M20 2H0l2-2h15l3-2z"/><path d="M15 7h-2L5-4h2z"/><path d="M20 1h171v1H20z" opacity=".3"/></g><g id="leafs"><path id="pl" fill="#9BB224" d="M-71-129c0-18 9-34 24-43l47-28-28 47c-9 15-26 24-43 24"/><use href="#pl" transform="rotate(45 0 -200)"/><use href="#pl" transform="rotate(90 0 -200)"/><use href="#pl" transform="rotate(180 0 -200)"/><use href="#pl" transform="rotate(225 0 -200)"/><use href="#pl" transform="rotate(270 0 -200)"/></g><g id="palm1"><use href="#fat"/><use href="#leafs"/></g><g id="palm2"><use href="#small"/><use href="#leafs"/></g><g id="tanker" style="transform-origin:0 114.9px"><path fill="#F4E5FC" d="M13.6-38.014h2.8v8.565h-2.8zm61.6 0H78v8.565h-2.8z"/><g fill="#F4E5FC"><path d="M75.2-38.014H78v8.565h-2.8z"/><path d="M78-38.014v8.663h-2.8v-8.663"/></g><path fill="#F4E5FC" d="M121.8-38.014h2.8v8.565h-2.8z"/><g fill="#F4E5FC"><path d="M121.8-38.014h2.8v8.565h-2.8z"/><path d="M124.6-38.014v8.663h-2.8v-8.663"/></g><path fill="#F4E5FC" d="M162.3-38.506h39.2v16.834h-39.2zm-4.2-6.104h13.5v6.104h-13.5z"/><path fill="#9400E3" d="M9.5-28.268h165.7v3.938H9.5z"/><path fill="#D499F4" d="M9.5-28.268h165.7v3.938H9.5z"/><path fill="#9400E3" d="M214.4-24.33H14.2l8.6 20.772h183.1z"/><path fill="#DAD8E0" d="M9.5-30.532h165.7v2.264H9.5z"/><path fill="#FFF" d="M66.3-1.786 16.4-9.268l4.8 7.285zm123.3 0 4.1-5.316 61.8 5.218zm0-57h8.6v1.772h-8.6zm0 7.679h8.6v12.6h-8.6z"/><path fill="#BE1622" d="M189.6-57.014h8.6v5.907h-8.6z"/><path fill="#FFF" d="M189.6-54.947h8.6v1.772h-8.6z"/></g><g id="fisher"><path fill="#C980F1" d="M183.5-64.3h10.8v4.9h-10.8zm-5.1-2.7h21v2.7h-21z"/><path fill="#E6332A" d="M178.6-54.4h20.8v9.3h-20.8z"/><path fill="#BE1622" d="M168.9-59.6h40.2v5.2h-40.2z"/><path fill="#FBD185" d="M25.2-2h81v-91.7z"/><path fill="#E6332A" d="M132.1-9.2H81.3v-36.1h50.8zm-46.6-4.1h42.4v-27.9H85.5z"/><path fill="#C980F1" d="m180.5-18.3-38.7-72.5-38.6 72.5-3.7-1.9 42.3-79.5 42.4 79.5z"/><path fill="#9400E3" d="M159.6-22.8h47.8l9.1-13.5h-56.9z"/><path fill="#FFF" d="M159.6-42.8v6.5h56.9l4.4-6.5z"/><path fill="#9400E3" d="M156.6-48.6h68.5v5.7h-68.5z"/><path fill="#C980F1" d="M124.3-63.2h36.4v4.1h-36.4zm11.2-51.3h12.6v4.1h-12.6z"/><path fill="#C980F1" d="m140.3-59.7-37-36 3-2.9 37 36zm-.6-52.8h4.2v17.2h-4.2z"/><path fill="#E6332A" d="M192.5-30.8v11.5H59.9L71.3-2h150.8l22.3-28.8z"/><path fill="#BE1622" d="M59.9-19.3h132.6V-25H56.1z"/><path fill="#FFF" d="M86.7-17.7h8.8v3.8h-8.8zm58.2 0h8.8v3.8h-8.8zM221-27h8.8v3.8H221zM168.4 0l67.9-10-6.6 9.8zM89.6 0 84-7.1 0-.1zM39.3-77.4h6.2v6.1zM53-66.6h6.1v6.1zm-1.5-17.7h6.2v6zM34.7-94.5h6.1v6zM24-72.2h6.2v6.1zm-6.2-17.3H24v6.1zm4.3-13.2h6.2v6zM37.8-62h6.1v6z"/></g><g id="bus"><path d="M41.5-90H186v81.8H41.5zM0-90h41.5v81.8H0z"/><path fill="#e94e1b" d="M41.5-72h130.9v9.67H41.5z"/><path fill="#f9b233" d="M41.5-62.3H0v-9.67h41.5z"/><circle cx="61.9" cy="-8.2" r="8.2" fill="#e94e1b"/><circle cx="139.9" cy="-8.2" r="8.2" fill="#e94e1b"/><circle cx="164" cy="-8.2" r="8.2" fill="#e94e1b"/></g><g id="camel"><path fill="#f28d00" d="M36.5-33.1 14.4-77.3v44.2z"/><path fill="#f28d00" d="m14.4-33.1 33.1 7.7 33.2-7.7zm0 0 33.1-44.2 33.2 44.2z"/><path fill="#9bb224" d="m30.9-55.2 16.6-22.1 16.6 22.1z"/><path fill="#f28d00" d="M25.4-33.1 14.4 0v-33.1zm0 0L36.5 0v-33.1zm44.2 0L58.6 0v-33.1zm0 0L80.7 0v-33.1zM14.4-66.3v-11L0-74.2v3.1z"/><path fill="#be1622" d="M3.3-75.7h2.8v42.54H3.3z"/></g><g id="coyote"><path fill="#aa6d29" d="M38.7-23.6h-8.2L16 .6h15.7l-6.8-2.7 6.7-7.6L38.7.6zM16 .6 4.8-2.2 0 .6zm14.5-24.2 3.9-14.2.9 1.5 1-1.7 2.4 14.4z"/><path fill="#aa6d29" d="m32.2-27.8-8 5 7.5-1.1z"/><path fill="#9400e3" d="M33-28.6h.4v2.66H33z"/><path fill="#c79f72" d="m26-17.4 4.5-6.2 2.8.9 5.4-.9 1.6 6.2-2.7-1.6-3.6 4.5-2.2-4-3.3 3.2-.5-2.8z"/></g><g id="camper"><path fill="#aa7035" d="M50.263-54.9h16.8v9.94h-16.8z"/><path fill="#aa6d29" d="M39.163-59h13.8v10.98h-13.8z"/><path fill="#f28d00" d="m23.263-21-23.4-5.4 9.5-15.5h23.9z"/><path fill="#ffef99" d="m15.863-52.5-6.5 10.6h9.8l-6.9 12.5-12.4 3 .3 8.1 2.7 12h100.4l34.2-8.4v-33.4l-3.7-4.4z"/><path fill="#be1622" d="M8.163-23.4h129.4v1.91H8.163zm-8.3 4.7h137.7v1.91H-.137z"/><circle cx="20.163" cy="-6.3" r="6.4" fill="#9400e3"/><circle cx="85.063" cy="-6.3" r="6.4" fill="#9400e3"/><g fill="#f28d00"><path id="camper-mask" d="M46.063-41.9h12.6v27.66h-12.6zm15.9 0h16.3v8.78h-16.3zm-28.7 0h8.2v12.49h-8.2zm69.9 0h31.2v12.49h-31.2z"/></g><path fill="#fff" d="M-.137-26.4h5.4v7.38h-5.4zm0 9.9h3.1v4.2h-3.1z"/></g><g id="tent"><path fill="#fad199" d="M53.069-61h-34.4L.069-13.4h53z"/><path fill="#f28d00" d="m54.069-61 18.5 47.6h-18.5zm-2 0-18.6 47.6h18.6z"/><g fill="gold"><path id="tent-mask" d="m84.869-3.3 1.3-12.2 4.3 4.4 5-18 3.1 11 4.5-5.4 5.2 12.6 3.9-2.5 4 10.1z"/></g><path fill="#e6332a" d="m90.069-3.3 9.3-7.2 10.6 7.2z"/><path fill="#aa7035" d="M81.169-3.3h38.6v3.19h-38.6z"/><path fill="#9400e3" d="M52.069-61h2v47.6h-2z"/></g><path id="small" fill="#AA7035" d="M10 0v-166L0-200l-10 34V0z"/><path id="fat" fill="#AA7035" d="M29 0v-120L0-200l-31 80V0z"/><path id="person" d="M0-69h20V0H0z"/></defs>';


   

    Cairo cairo;

     
    constructor() ERC721("Night And Day", "N&D") {

        
         cairo = new Cairo();

      


    }


    function tokenURI(uint256 tokenId) public override view returns (string memory) {
    //    _requireOwned(tokenId);

        return generateNFT(tokenId);
    }

    function generateNFT(uint256 tokenId) public view returns (string memory) {

      string memory topSVG = 
      '<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="1080" height="1080" viewbox="0 0 1080 1080">'
      '<rect fill="<!--skycolor-->" width="1080" height="1080"/>'
      '<!--sun-->'
      '<!--clouds-->'
      '<!--moon-->'
      '<!--skyscene-->';

      string memory endSVG = 
        '<g transform="translate(500, 800) scale(.8)">'
        '<!--flower-->'
        '</g>'
        '<mask id="nightMask">'
        '<rect fill="#fff" width="1080" height="1080"/>'
        '<!--maskedmoon-->'
        '<!--maskedassets-->'
        '</mask>'
        '<!--night-->'
        '</svg>';

        Motif memory motif = cairo.getMotif();

        string memory outputSVG = string.concat(topSVG, assets, motif.svg, endSVG);

        uint timestamp =  block.timestamp;



        (int azimuth, int altitude) = SunCalc.getPosition(motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);

        outputSVG = NDRenderer.renderSun(outputSVG, uint(motif.horizon) * 1e4, azimuth / 1e14, altitude / 1e14, uint(motif.lookingDirection) * 1e4);

        // get moon position
        (int moonAzimuth, int moonAltitude, int parallacticAngle) = SunCalc.getMoonPosition( motif.lat * 1e12, motif.lng * 1e12, timestamp * 1e18);
        console.log("moonAltitude");
        console.logInt(moonAltitude / 1e18);
        console.log("moonAzimuth");
        console.logInt(moonAzimuth / 1e18);


        (int fraction, int phase, int angle )  = SunCalc.getMoonIllumination(timestamp * 1e18);

         outputSVG = NDRenderer.renderMoon(outputSVG,  motif.lookingDirection * 1e4, motif.horizon * 1e4, moonAzimuth / 1e14, moonAltitude / 1e14, parallacticAngle / 1e14, fraction / 1e14, angle / 1e14);

         outputSVG = NDRenderer.setSkyColor(outputSVG, altitude / 1e16);

         outputSVG = NDRenderer.applyNight(outputSVG, altitude / 1e14);
         // take first second of day and add token id to it
         uint cloudNonce = block.timestamp - (block.timestamp  % 86400) + tokenId;
         outputSVG = NDRenderer.generateClouds(outputSVG, motif.horizon, cloudNonce);
         outputSVG = NDRenderer.renderSunFlower(outputSVG, azimuth / 1e16, altitude / 1e16, motif.lookingDirection * 1e2);

        // console.log(motif.scenes);
         
         outputSVG = NDRenderer.renderMainScene(outputSVG, motif.lat, motif.lng, timestamp, 1, motif.scenes);
         outputSVG = NDRenderer.renderReplacements(outputSVG, motif.replacements);
         outputSVG = renderAirplanes(outputSVG, timestamp, tokenId, uint(motif.horizon), motif.lookingDirection);
        

        return outputSVG;


    }


    function renderAirplanes(        
        string memory svg,
        uint timestamp, 
        uint tokenId, uint horizonInPx, int lookingDirection) public pure returns (string memory) {

            string memory assetName = "aeroplane";
            string memory salt = string.concat(tokenId.toString(), lookingDirection.toStringSigned());



            string memory assetsSVG =  NDRenderer.renderMovingAsset(timestamp, salt, assetName, false, 0, horizonInPx, false, 1, 3, 120, 60, 100, 60 );
            console.logUint(timestamp);
            console.log(assetsSVG);
            return NDRenderer.replaceFirst(svg, "<!--skyscene-->", assetsSVG);
        }


        function renderWaterScene(string memory svg, uint timestamp, uint tokenId, uint horizonInPx, int lookingDirection) public pure returns (string memory) {
            

            string memory salt = string.concat(tokenId.toString(), lookingDirection.toStringSigned());
            

            string memory tankerSVG =  NDRenderer.renderMovingAsset(timestamp, salt, "tanker", true, horizonInPx, 0, false, 1, 3, 120, 60, 100, 60 );
            string memory fisherSVG =  NDRenderer.renderMovingAsset(timestamp, salt, "fisher", true, horizonInPx, 0, false, 1, 3, 120, 60, 100, 60 );
            string memory yachtSVG =   NDRenderer.renderMovingAsset(timestamp, salt, "yacht", true, horizonInPx, 0, false, 1, 3, 120, 60, 100, 60 );

            string memory assetsSVG = string.concat(tankerSVG, fisherSVG, yachtSVG);

            return NDRenderer.replaceFirst(svg, "<!--waterscene-->", assetsSVG);


        }


        function renderChart(string memory svg, uint tokenId, uint timestamp) public view returns (string memory) {
            string memory salt = tokenId.toString();

            //Dogecoin chainlink
            //0x2465CefD3b488BE410b941b1d4b2767088e2A028
            //BTC-USD
            //0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c
            //XAU-USD
            //0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c
            //XAG-USD
            //0x379589227b15F1a12195D3f2d90bBc9F31f95235
            //ETH-USD
            //0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419

            AggregatorV3Interface dataFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
            (uint80 firstRoundID , , ,uint firstUpdatedAt , ) = dataFeed.latestRoundData();


            // fetch prices of last  24 hour but at least 8 pricepoints
            // store price and their timestamp (updatedAt)

         //   (uint, uint)[] memory prices = new (uint, uint)[](8);

            uint[] memory prices = new uint[](16);

            for(uint i = 0; i < 16; i+=2) {
                (, int price, , uint updatedAt , ) = dataFeed.getRoundData(firstRoundID);
                prices[i] = uint(price);
                prices[i+1] = updatedAt;
                firstRoundID--;
            }

            console.logUint(prices.length);
            console.logUint(prices[0]);
            // find lowest and highest price
            uint lowestPrice = prices[0];
            uint highestPrice = prices[0];
            for(uint j = 0; j < prices.length; j+=2) {
                if(prices[j] < lowestPrice) {
                    lowestPrice = prices[j];
                }
                if(prices[j] > highestPrice) {
                    highestPrice = prices[j];
                }
            }

            // find the price range
            uint priceRange = highestPrice - lowestPrice;

            //time range by subtracting the first timestamp from the last
            uint timeRange = prices[1] - prices[prices.length - 1];


            uint chartWidth = 280;
            uint chartHeight = 200;
            uint chartX = 20;
            uint chartY = 730;

            // iterate prices and create line chart based on price and timestamp
            string memory chart = '<g id="chart" transform="translate(';
            chart = string.concat(chart, chartX.toString(), ",", chartY.toString(), ') scale(1,-1)">');
            for(uint j = 0; j < prices.length; j+=2) {
                uint x = (prices[j+1] - prices[prices.length - 1]) * chartWidth / timeRange;
                uint y = (prices[j] - lowestPrice) * chartHeight / priceRange;
                chart = string.concat(chart, '<circle cx="', x.toString(), '" cy="', y.toString(), '" r="2" fill="#fff"/>');
            }


            return chart;
           // return NDRenderer.replaceFirst(svg, "<!--chart-->", "chart");
        }





    

    function getMotive(string memory motive) public pure returns (string memory) {

     
   }


}

