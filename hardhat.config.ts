// hardhat.config.ts

import "dotenv/config"
import "@nomiclabs/hardhat-etherscan"
import "@nomiclabs/hardhat-solhint"
import "@tenderly/hardhat-tenderly"
import "@nomiclabs/hardhat-waffle"
import "hardhat-abi-exporter"
import "hardhat-deploy"
import "hardhat-deploy-ethers"
import "hardhat-gas-reporter"
import "hardhat-spdx-license-identifier"
import "hardhat-typechain"
import "hardhat-watcher"
import "solidity-coverage"
import "./tasks"

import { HardhatUserConfig } from "hardhat/types"
import { removeConsoleLog } from "hardhat-preprocessor"

const accounts = {
  mnemonic: process.env.MNEMONIC || "test test test test test test test test test test test junk",
  // accountsBalance: "990000000000000000000",
}
const pkey = process.env.PKEY;

const config: HardhatUserConfig = {
  abiExporter: {
    path: "./abi",
    clear: false,
    flat: true,
    // only: [],
    // except: []
  },
  defaultNetwork: "hardhat",
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  gasReporter: {
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
    currency: "USD",
    enabled: process.env.REPORT_GAS === "true",
    excludeContracts: ["contracts/mocks/", "contracts/libraries/"],
  },
  mocha: {
    timeout: 20000,
  },
  namedAccounts: {
    deployer: {
      default: 137,
      17: "0x7CE094Bea0e0adF53641310DB1193028D7F7b19a",
      97: "0x7CE094Bea0e0adF53641310DB1193028D7F7b19a",
      56: "0x7CE094Bea0e0adF53641310DB1193028D7F7b19a",
      96: "0x7CE094Bea0e0adF53641310DB1193028D7F7b19a",
      137: "0x7CE094Bea0e0adF53641310DB1193028D7F7b19a",
    },
    dev: {
      // Default to 1
      default: 137,
      // dev address mainnet
      // 1: "",
        17: "0xBC0EE23C8A355f051a9309bce676F818d35743D1",
        97: "0xBC0EE23C8A355f051a9309bce676F818d35743D1",
        56: "0xBC0EE23C8A355f051a9309bce676F818d35743D1",
        96: "0xBC0EE23C8A355f051a9309bce676F818d35743D1",
        137: "0xBC0EE23C8A355f051a9309bce676F818d35743D1",
    },
  },
  networks: {
    bkc: {
      url: "https://rpc.bitkubchain.io",
      accounts: [`0x${pkey}`],
      chainId: 96,
      live: true,
      saveDeployments: true,
    },    
    bsc: {
      url: "https://bsc-dataseed1.defibit.io",
      accounts: [`0x${pkey}`],
      chainId: 56,
      live: true,
      saveDeployments: true,
    },
    "bsc-testnet": {
      url: "https://data-seed-prebsc-2-s3.binance.org:8545",
      accounts: [`0x${pkey}`],
      chainId: 97,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 20000000000,
    },
    'metachain': {
      url: 'https://rpc.metachain.asia',
      chainId: 17,
      accounts: [`0x${pkey}`],
      live: true,
      saveDeployments: true,
    }
  },
  paths: {
    artifacts: "artifacts",
    cache: "cache",
    deploy: "deploy",
    deployments: "deployments",
    imports: "imports",
    sources: "contracts",
    tests: "test",
  },
  preprocess: {
    eachLine: removeConsoleLog((bre) => bre.network.name !== "hardhat" && bre.network.name !== "localhost"),
  },
  solidity: {
    compilers: [
      {
        version: "0.6.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },      
    ],
  },
  spdxLicenseIdentifier: {
    overwrite: false,
    runOnCompile: true,
  },
  tenderly: {
    project: process.env.TENDERLY_PROJECT!,
    username: process.env.TENDERLY_USERNAME!,
  },
  typechain: {
    outDir: "types",
    target: "ethers-v5",
  },
  watcher: {
    compile: {
      tasks: ["compile"],
      files: ["./contracts"],
      verbose: true,
    },
  },
}

export default config
