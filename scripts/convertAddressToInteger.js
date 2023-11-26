const { ethers } = require('hardhat');

async function main() {
    const address = "0x8c07411ca94bE4a1804215004a2e7d05AC2712c5";
    number = ethers.BigNumber.from(address);
    console.log("Number: ", number);
}
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });