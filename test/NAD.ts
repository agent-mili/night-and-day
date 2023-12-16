// test ranomNum function in N&D contract

import { expect } from "chai";
import { ethers } from "hardhat";

describe("NAD", function () {
  xit("Should return a random number", async function () {
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

it("should generate svg clouds", async function () {
  const [owner, otherAccount] = await ethers.getSigners();
  
  const NandD = await ethers.getContractFactory("NAD");
  const nandd = await NandD.deploy();

  const svg = await nandd.generateClouds(1);
  console.log(svg);
  expect(svg).to.be.a("string");
  

});



it("should generate svg sun", async function () {
  const [owner, otherAccount] = await ethers.getSigners();
  
  const NandD = await ethers.getContractFactory("NAD");
  const nandd = await NandD.deploy();

  const svg = await nandd.generateSun(180, 400, 180, 30);

  console.log(svg);

  expect(svg).to.be.a("string");
  

});
});