require("@nomiclabs/hardhat-waffle");

const HARMONY_PRIVATE_KEY = "0x0610b6d30be50f100c93975b719d5ead6c928dcd6aaeb47352cb975170b6cbe5"

module.exports = {
  solidity: "0.8.10",
  networks: {
    testnet: {
      url: `https://api.s0.b.hmny.io`,
      accounts: [`${HARMONY_PRIVATE_KEY}`]
    },
    mainnet: {
      url: `https://api.harmony.one`,
      accounts: [`${HARMONY_PRIVATE_KEY}`]
    }
  }
};