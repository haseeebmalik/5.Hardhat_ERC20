require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
require("hardhat-contract-sizer")
require("dotenv").config()

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || ""
const PRIVATE_KEY = process.env.PRIVATE_KEY || ""
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork:"hardhat",
  networks:{
    hardhat:{
      chainId:31337,
      blockConfirmations:1,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
      blockConfirmations:6,
      // gas: 2100000,
      // gasPrice: 8000000000
  },
  },
  solidity: "0.8.17",
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
},
  namedAccounts:{
    deployer:{
      default:0,
    },
    player:{
      default:1,
    },
  },
  mocha:{
   timeout:300000 //300 seconds max
  },
  gasReporter: {
    enabled: false,
    outputFile: "gas-reporter.txt",
    noColors: true,
    currency: "USD",
    coinmarketcap: COINMARKETCAP_API_KEY,
    //now we give token of a particular network so to get the gas price of a particular network, you will get
    //token from hardhat-gas-reporter npm  docs.

    token:"ETH"
},

};
