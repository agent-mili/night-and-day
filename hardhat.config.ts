import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-ignition-ethers";
import "@foundry-rs/hardhat-anvil";
import "@nomicfoundation/hardhat-foundry";


require("hardhat-contract-sizer");

const config: HardhatUserConfig = {
  solidity: { 
  version: "0.8.25",
  settings: {
    viaIR: true,
    optimizer: {
      enabled: true,
      runs: 10,
    },
  },

},

mocha: {
  timeout: 1000000000
},

gasReporter: {
  enabled: true,
  currency: 'USD',
  coinmarketcap:'8ae61cb1-efee-403b-a1f3-aa48c026cc2d',
  //gasPrice: 50
  gasPrice: 25
},

defaultNetwork:"anvil",


networks: {
  hardhat: {
    forking: {
      //infura 
      url: "https://mainnet.infura.io/v3/cd6ed9e0e4c94f8cb914a030ddd9cdd7",
      blockNumber:19482130,

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
