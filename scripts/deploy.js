async function main() {
  const verifierContract = "StudentVerifier";
  const verifierName = "Verified Student";
  const verifierSymbol = "VSBT";


  const poseidonFacade = "0xD65f5Fc521C4296723c6Eb16723A8171dCC12FB0";

  const ERC20Verifier = await ethers.getContractFactory(verifierContract, {
    libraries: {
      PoseidonFacade: "0xD65f5Fc521C4296723c6Eb16723A8171dCC12FB0"
    },
  });
  const erc20Verifier = await ERC20Verifier.deploy(
    verifierName,
    verifierSymbol
  );

  await erc20Verifier.deployed();
  console.log(verifierName, " contract address:", erc20Verifier.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
