require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

// Read environment variables (which are stored in the .env file)
const infuraProjectId = process.env.INFURA_PROJECT_ID;
const mnemonic = process.env.MNEMONIC; // Be sure to never commit this

export const networks = {
  // Configuration for the Goerli Testnet
  goerli: {
    provider: () => new HDWalletProvider(
      mnemonic,
      `https://goerli.infura.io/v3/${infuraProjectId}`
    ),
    network_id: 5, // Goerli's network id
    gas: 5500000, // Gas limit used for deploys
    confirmations: 2, // # of confirmations to wait between deployments
    timeoutBlocks: 200, // # of blocks before a deployment times out
  },
  // ... Other network configurations ...
};
export const mocha = {
  // timeout: 100000
};
export const compilers = {
  solc: {
    version: "^0.8.0", // Fetch exact version from solc-bin
    settings: {
      optimizer: {
        enabled: false,
        runs: 200
      },
    }
  },
};
export const db = {
  enabled: false
};
export const plugins = [
  'truffle-plugin-verify'
];
export const api_keys = {
  etherscan: process.env.ETHERSCAN_API_KEY
};
