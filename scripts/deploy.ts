import { ethers } from "hardhat";

async function main() {
  
  const sam = await ethers.deployContract("SAM");
  const nad = await ethers.deployContract("NAD", [sam.getAddress()]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
