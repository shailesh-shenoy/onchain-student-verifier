const { ethers } = require('hardhat');

async function main() {
    const address = "0x2847C991E182b901e6e5bcEB2ff2C8F1C3AA1Db2";
    number = ethers.BigNumber.from(address);
    console.log("Number: ", number);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });