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
      runs: 10,
    },
  },

},

networks: {
  hardhat: {
    forking: {
      //infura 
      url: "https://mainnet.infura.io/v3/b7328e17100448f89847030a6ec31280",
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
