require("@nomiclabs/hardhat-waffle");
require('dotenv').config()

module.exports = {
  solidity: "0.8.10",
  networks: {
    testnet: {
      url: `https://api.s0.b.hmny.io`,
      accounts: [`${process.env.HARMONY_PRIVATE_KEY}`]
    },
    mainnet: {
      url: `https://api.harmony.one`,
      accounts: [`${process.env.HARMONY_PRIVATE_KEY}`]
    }
  }
};