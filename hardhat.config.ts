import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("hardhat-contract-sizer");

const config: HardhatUserConfig = {
  solidity: { 
  version: "0.8.20",
  settings: {
    viaIR: true,
    optimizer: {
      enabled: true,
      runs: 1,
    },
  },

},

  //@ts-ignore
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
  }

};

export default config;
