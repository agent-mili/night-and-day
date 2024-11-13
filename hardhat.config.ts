import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-ignition-ethers";
import "@foundry-rs/hardhat-anvil";
import "@nomicfoundation/hardhat-foundry";
import "@nomicfoundation/hardhat-ledger" ;

import "hardhat-contract-sizer";



const config: HardhatUserConfig = {
  solidity: { 
  version: "0.8.27",
  settings: {
    viaIR: true,
    optimizer: {
      enabled: true,
      runs: 60,
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
  gasPrice: 5
},

defaultNetwork:"anvil",


networks: {
  hardhat: {
   // gasPrice: 50000000000, // 50 gwei

    forking: {
      url: "https://mainnet.infura.io/v3/",
      blockNumber:19482130,
    },
  },
  sepolia: {
    url: "https://sepolia.infura.io/v3/",
    accounts: [""],
},

mainnet: {
  url: "https://mainnet.infura.io/v3/",
  ledgerAccounts : ["0x730C4EDAc77C64605267189F9dc885D67c27d910"],
  gasPrice: 4000000000, // 40 gwei
},
},

etherscan: {
  apiKey: {
    mainnet:"XVMV7QTMMMMMUE3PSCD6RPKXUMT3X7ZKSG",
  } 
},

  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
  }
};


export default config;
