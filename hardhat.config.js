require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");
const { MNEMONIC, INFURA_PROJECT_ID, ETHERSCAN_API_KEY } = process.env;

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      // If you want to do some forking, you can configure it here
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_PROJECT_ID}`,
      accounts: {
        mnemonic: MNEMONIC,
      },
      network_id: 5,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
    },
    // ... Other network configurations ...
  },
  solidity: {
    version: "^0.8.0", // Replace with the version of Solidity you want to use
    settings: {
      optimizer: {
        enabled: false,
        runs: 200
      },
    }
  },
  mocha: {
    // timeout: 20000
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./build/cache",
    artifacts: "./build/contracts"
  },
  plugins: [
    "@nomicfoundation/hardhat-verify",
    // ... other plugins like solidity-coverage, gas-reporter, etc.
  ],
};

