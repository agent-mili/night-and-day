// test ranomNum function in N&D contract

import { expect } from "chai";
import { ethers } from "hardhat";

//import fs
import fs from "fs";

describe("NAD", function () {
  /* xit("Should return a random number", async function () {
    const [owner, otherAccount] = await ethers.getSigners();

    const NandD = await ethers.getContractFactory("NAD");
    const nandd = await NandD.deploy();

    // pass in thre arguments of type uint to the randomNum function

    const randomNum = await nandd.randomNum(11, 1, 100);
    console.log(randomNum);
    expect(randomNum).to.be.a("bigint");
  });

  xit("should return a basic motive", async function () {
    const [owner, otherAccount] = await ethers.getSigners();
    
    const NandD = await ethers.getContractFactory("NAD");
    const nandd = await NandD.deploy();

    const motive = await nandd.getMotive('red_rock');
    console.log(motive);
    expect(motive).to.be.a("string");
    
});

xit("should generate svg clouds", async function () {
  const [owner, otherAccount] = await ethers.getSigners();
  
  const NandD = await ethers.getContractFactory("NAD");
  const nandd = await NandD.deploy();

  const svg = await nandd.generateClouds(1);
  console.log(svg);
  expect(svg).to.be.a("string");
  

});



xit("should generate svg sun", async function () {
  const [owner, otherAccount] = await ethers.getSigners();
  
  const NandD = await ethers.getContractFactory("NAD");
  const nandd = await NandD.deploy();

  const svg = await nandd.generateSun(180, 400, 180, 30);

  console.log(svg);

  expect(svg).to.be.a("string");
  

}); */

// write a test for tokenUri function
it("should return a token URI", async function () {
  const [owner, otherAccount] = await ethers.getSigners();

// create motif instance and give its address to NAD contract constructor

const GenericMotif = await ethers.getContractFactory("GenericMotifs");
const genericMotif = await GenericMotif.deploy();  

const GenericMotifSVG = await ethers.getContractFactory("GenericMotifsSVG");
const genericMotifSVG = await GenericMotifSVG.deploy();


  const motif0 = await ethers.deployContract("Motifs0");
  await motif0.waitForDeployment();

  const motif1 = await ethers.deployContract("Motifs1");
  await motif1.waitForDeployment();

  const motif2 = await ethers.deployContract("Motifs2");
  await motif2.waitForDeployment();


  // deploy linked libraries (SunCalc and NDRenderer) and link them to NAD contract
  const sunCalc = await ethers.deployContract("SunCalc");
  await sunCalc.waitForDeployment();


  const NDDecoder = await ethers.deployContract("NDDecoder");
  const ndDecoder = await NDDecoder.waitForDeployment();


  const NDRenderer = await ethers.getContractFactory("NDRenderer");


  const ndRenderer = await NDRenderer.deploy();



  const NDMotifDataManager = await ethers.getContractFactory("NDMotifDataManager", {
    libraries: {
      NDRenderer: ndRenderer.target,
      NDDecoder: ndDecoder.target,
    },
  });
  
  const ndMotifDataManager = await NDMotifDataManager.deploy(genericMotif.target, genericMotifSVG.target, motif0.target, motif1.target, motif2.target);

  


  const NandD = await ethers.getContractFactory("NAD", {
    libraries: {
      SunCalc: sunCalc.target,
      NDRenderer: ndRenderer.target,
    },
  });
  const nandd = await NandD.deploy(ndMotifDataManager.target);


  let tokenURI;
  ///for (let i = 120; i < 121; i++) {
     tokenURI = await nandd.tokenUriWithTime(220, 1712142140);
    fs.writeFileSync(`./svgs/tokenURI${120}.svg`, tokenURI);
  //}


  //console.log("Gas: ", await nandd.tokenURI(120));




  expect(tokenURI).to.be.a("string");
  

});


xit("should return a chart", async function () {
  const [owner, otherAccount] = await ethers.getSigners();

  const GenericMotif = await ethers.getContractFactory("GenericMotifs");
  const genericMotif = await GenericMotif.deploy();  

  const GenericMotifSVG = await ethers.getContractFactory("GenericMotifsSVG");
const genericMotifSVG = await GenericMotifSVG.deploy();


  const motif0 = await ethers.deployContract("Motifs0");
  await motif0.waitForDeployment();
  const motif1 = await ethers.deployContract("Motifs1");
  await motif1.waitForDeployment();
  const motif2 = await ethers.deployContract("Motifs2");
  await motif2.waitForDeployment();
  
   // deploy linked libraries (SunCalc and NDRenderer) and link them to NAD contract
   const sunCalc = await ethers.deployContract("SunCalc");
   const ndRenderer = await ethers.deployContract("NDRenderer");
   const NDDecoder = await ethers.deployContract("NDDecoder");
 
   await sunCalc.waitForDeployment();
   await ndRenderer.waitForDeployment();
    await NDDecoder.waitForDeployment();




  const NDMotifDataManager = await ethers.getContractFactory("NDMotifDataManager", {
    libraries: {

      NDDecoder: NDDecoder.target,
    },
  });
  
  const ndMotifDataManager = await NDMotifDataManager.deploy(genericMotif.target, genericMotifSVG.target  ,  motif0.target, motif1.target, motif2.target);

 
 
 
   const NandD = await ethers.getContractFactory("NAD", {
     libraries: {
       SunCalc: sunCalc.target,
       NDRenderer: ndRenderer.target,
     },
   });
   const nandd = await NandD.deploy(ndMotifDataManager.target);

  const timestamp = BigInt(Date.now()) / BigInt(1e3);
  const chart = "";//await nandd.renderChart("red_rock", 1, timestamp.toString());
  console.log(chart);
  expect(chart).to.be.a("string");



});
});