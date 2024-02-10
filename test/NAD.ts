// test ranomNum function in N&D contract

import { expect } from "chai";
import { ethers } from "hardhat";

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


  // deploy linked libraries (SunCalc and NDRenderer) and link them to NAD contract
  const sunCalc = await ethers.deployContract("SunCalc");
  const ndRenderer = await ethers.deployContract("NDRenderer");

  await sunCalc.waitForDeployment();
  await ndRenderer.waitForDeployment();



  const NandD = await ethers.getContractFactory("NAD", {
    libraries: {
      SunCalc: sunCalc.target,
      NDRenderer: ndRenderer.target,
    },
  });
  const nandd = await NandD.deploy();
  const tokenURI = await nandd.tokenURI(1);

  console.log(tokenURI);

  expect(tokenURI).to.be.a("string");
  

});


it("should return a chart", async function () {
  const [owner, otherAccount] = await ethers.getSigners();
  
   // deploy linked libraries (SunCalc and NDRenderer) and link them to NAD contract
   const sunCalc = await ethers.deployContract("SunCalc");
   const ndRenderer = await ethers.deployContract("NDRenderer");
 
   await sunCalc.waitForDeployment();
   await ndRenderer.waitForDeployment();
 
 
 
   const NandD = await ethers.getContractFactory("NAD", {
     libraries: {
       SunCalc: sunCalc.target,
       NDRenderer: ndRenderer.target,
     },
   });
  const nandd = await NandD.deploy();

  const timestamp = BigInt(Date.now()) / BigInt(1e3);
  const chart = await nandd.renderChart("red_rock", 1, timestamp.toString());
  console.log(chart);
  expect(chart).to.be.a("string");



});
});