// test ranomNum function in N&D contract

import { expect } from "chai";
import { ethers, waffle } from "hardhat";
import hre from "hardhat";





//import fs
import fs from "fs";
import { Contract } from "ethers";
import exp from "constants";

describe("NAD", function () {

  let nad: any;;
  let ndRenderer: any;
  let signer:any; // Die Adresse, die die Transaktion senden soll
  let otherSigner:any; // Eine andere Adresse, die die Transaktion senden soll

  // function withdraw() external onlyOwner nonReentrant
  // Adresse und ABI des bestehenden Contracts
  const contractAddressRenderer = "0xF94AB55a20B32AC37c3A105f12dB535986697945";
  const contractABIRenderer = [
    "function renderSunclock(string memory svg, int azimuth, int altitude, int heading) public view returns (string memory)"
  ];

  const contractAddress = "0xB41e747bC9d07c85F020618A3A07d50F96703A78"; // Ersetze mit der richtigen Contract-Adresse
  const contractABI = [
    "function mint() public payable",       // Die mint-Funktion, die Ether entgegennimmt
    "function totalSupply() public view returns (uint256)",  // Die totalSupply-Funktion, die den Gesamtbetrag zurückgibt
   // "function getShuffledTokenIds() public view returns (uint16[])", // Die totalSupply-Funktion, die den Gesamtbetrag zurückgibt
  "function shuffledTokenIds(uint256) public view returns (uint16)", // Die totalSupply-Funktion, die den Gesamtbetrag zurückgibt
   "function ownerOf(uint256 tokenId) public view returns (address)",
  "function getShuffledTokenLength() public view returns (uint256)",
  "function royaltyInfo(uint256 tokenId, uint256 value) public view returns (address receiver, uint256 royaltyAmount)",
  "function setDefaultRoyalty( address receiver, uint96 feeNumerator) public",
  "function owner() public view returns (address)",
  "function withdraw() public"
  ];

  before(async function () {
    // Setze die Instanz des bestehenden Contracts und einen Signer
    nad = new ethers.Contract(contractAddress, contractABI, ethers.provider);
    [signer, otherSigner] = await ethers.getSigners(); // Nimmt den ersten verfügbaren Account als Signer
    nad = nad.connect(signer); // Verbinde den Signer mit dem Contract
   // await hre.network.provider.send("hardhat_reset");

   ndRenderer = new ethers.Contract(contractAddressRenderer, contractABIRenderer, ethers.provider);
    ndRenderer = ndRenderer.connect(signer);


  });

 

xit("mint a nft", async function () {

  const maxSupply = 321;
 
  for (let i = 0; i < 1; i++) {
   // await expect(nad.mint({ value: ethers.parseEther("0.001") })).to.be.reverted;
   try {
    const tx =  await nad.mint({ value: ethers.parseEther("0.001") })
    await tx.wait();
    console.log(tx);
   } catch (error) {
      console.log(error);
    }

   //console.log(tx);

  }

  const mintedSupply = Number(await nad.totalSupply());
  console.log("mintedSupply : ", mintedSupply);

  //await expect(nad.mint())
  //.to.be.revertedWith("Max supply reached");

  //const tx = await nad.mint({ value: ethers.parseEther("0.0001") });

  //console.log(tx);
  

  // expect(supply).to.equal(38);


  const unmintedSupply = Number(await nad.getShuffledTokenLength());

  console.log(unmintedSupply);

  expect(unmintedSupply + mintedSupply).to.equal(maxSupply);

  const shuffledToken: number[] = [];



  for (let i = 0; i < maxSupply - mintedSupply ; i++) {
    const tokenId = Number(await nad.shuffledTokenIds(i));
  //  console.log(tokenId);
    expect(tokenId).to.be.a("number");
    shuffledToken.push(tokenId);
  }

  const isLegit = shuffledToken.every((val, i, a) => val >= 0 && val <= 320 && a.indexOf(val) === i);

  const missingInRange = Array.from({ length: maxSupply }, (_, i) => i).filter(x => !shuffledToken.includes(x));

  //console.log(missingInRange);

  expect(missingInRange.length).to.equal(mintedSupply);

  for (let i = 0; i < missingInRange.length; i++) {
    const tokenId = missingInRange[i];
    const owner = await nad.ownerOf(tokenId);
   // console.log(owner);
    expect(owner).to.be.a("string");
  }

  console.log(isLegit);

  expect(isLegit).to.be.true;









 //  const shuffledTokenIds = await nad.getShuffledTokenIds();
   // console.log(shuffledTokenIds);

   // const owner = await nad.ownerOf(1);
   // console.log(owner);
   // expect(owner).to.be("string");


});

xit("should return royalty info", async function () {
  const tokenId = 1;
  const value = ethers.parseEther("1");
  // const royaltyInfo = await nad.royaltyInfo(tokenId, value);
  // console.log(royaltyInfo);
  // expect(royaltyInfo).to.be.a("array");
  // expect(royaltyInfo[0]).to.be.a("string");
  // const royaltyAmount = ethers.formatEther(royaltyInfo[1]);
  // console.log(royaltyAmount);
  // // royaliy is set to 2.5%
  // expect(royaltyAmount).to.equal("0.025");

  // set royalty to 5%
  console.log(signer.address);
  const tx = await nad.setDefaultRoyalty(signer.address, 500);
  await tx.wait();
  const newRoyaltyInfo = await nad.royaltyInfo(tokenId, value);
  console.log(newRoyaltyInfo);
  expect(newRoyaltyInfo).to.be.a("array");
  expect(newRoyaltyInfo[0]).to.be.a("string");
  const newRoyaltyAmount = ethers.formatEther(newRoyaltyInfo[1]);
  console.log(newRoyaltyAmount);
  // royaliy is set to 5%
  expect(newRoyaltyAmount).to.equal("0.05");


})

xit("should check contract owner", async function () {

  const owner = await nad.owner();
  console.log(owner);
  expect(owner).to.be.a("string");
  expect(owner).to.equal(signer.address);

});

xit("should have balance stored on contract", async function () {

  console.log("nad.address");
  console.log(nad.target);
  const provider = waffle.provider;
  const balance = await ethers.provider.getBalance(nad.target);
  const eths = parseFloat(ethers.formatEther(balance));
  console.log(balance);
  console.log(eths);
  expect(balance).to.be.a("bigint");

})


xit("should withdraw balance of contract to owner", async function () {


  const balance = await ethers.provider.getBalance(nad.target);
  const ownerBalance = await ethers.provider.getBalance(signer.address);
  const ownerEths = parseFloat(ethers.formatEther(ownerBalance));
  const ethsContract = parseFloat(ethers.formatEther(balance));
  expect(balance).to.be.a("bigint");

  console.log("ownerBalance");
  console.log(ownerEths);

  console.log("ethsContract");
  console.log(ethsContract);

  const tx = await nad.withdraw();
  await tx.wait();

  const newBalance = await ethers.provider.getBalance(nad.target);
  const newOwnerBalance = await ethers.provider.getBalance(signer.address);

  const newEthsContract = parseFloat(ethers.formatEther(newBalance));
  const newOwnerEths = parseFloat(ethers.formatEther(newOwnerBalance));

  console.log("newOwnerBalance");
  console.log(newOwnerEths);

  console.log("newEthsContract");
  console.log(newEthsContract);

  //expect(newBalance).to.be.a("bigint");
  expect(newOwnerBalance).to.be.equal(ownerBalance + balance);



})

it("should render sunclock", async function () {
  // iterate azimuth and altitude
  // aimuth from 0 to 360 
  // altitude from 0 to 90

  for (let azimuth = 0; azimuth <= 10000; azimuth += 1) {
    console.log(azimuth);

    for (let altitude = 0; altitude <= 100; altitude += 1) {
      try {
        const sunclock = await ndRenderer.renderSunclock("$sh", azimuth , altitude, 0);
        //console.log(sunclock);
        expect(sunclock).to.be.a("string");
      } catch(error) {
        console.log(azimuth, altitude);
      }
    }
  }

});

})
;