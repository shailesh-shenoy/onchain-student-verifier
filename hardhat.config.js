require('@nomiclabs/hardhat-waffle');
require('dotenv').config();
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-solhint");

module.exports = {
  solidity: "0.8.16",
  networks: {
    mumbai: {
      chainId: 80001,
      url: `${process.env.QUICKNODE_MUMBAI_URL}`,
      accounts: [`0x${process.env.MUMBAI_PRIVATE_KEY}`]
    }
  }
};
