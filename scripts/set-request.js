
const Operators = {
  NOOP: 0, // No operation, skip query verification in circuit
  EQ: 1, // equal
  LT: 2, // less than
  GT: 3, // greater than
  IN: 4, // in
  NIN: 5, // not in
  NE: 6   // not equal
}

async function main() {

  // you can run https://go.dev/play/p/3id7HAhf-Wi to get schema hash and claimPathKey using YOUR schema
  // suggestion: Use your own go application with that code rather than using playground (it can give a timeout just because it’s restricted by the size of dependency package)
  const schemaBigInt = "211858871543568608478507767336162912855"

  // merklized path to field in the W3C credential according to JSONLD  schema e.g. birthday in the KYCAgeCredential under the url "https://raw.githubusercontent.com/iden3/claim-schema-vocab/main/schemas/json-ld/kyc-v3.json-ld"
  const schemaClaimPathKey = "18985039166381489137731520158771856739325696334209861854133956600929269555815"

  const requestId = 1;

  const query = {
    schema: schemaBigInt,
    claimPathKey: schemaClaimPathKey,
    operator: Operators.EQ, // operator
    value: [1, ...new Array(63).fill(0).map(i => 0)], // for operators 1-3 only first value matters
  };

  // add the address of the contract just deployed
  const StudentVerifierAddress = "0xcaEEF8306684eFFf57D362D50594d1f757202201"

  let studentVerifier = await hre.ethers.getContractAt("StudentVerifier", StudentVerifierAddress)


  const validatorAddress = "0xF2D4Eeb4d455fb673104902282Ce68B9ce4Ac450"; // sig validator
  // const validatorAddress = "0x3DcAe4c8d94359D31e4C89D7F2b944859408C618"; // mtp validator

  try {
    const txId = await studentVerifier.setZKPRequest(
      requestId,
      validatorAddress,
      query.schema,
      query.claimPathKey,
      query.operator,
      query.value
    );
    console.log("Request set: ", txId.hash);
  } catch (e) {
    console.log("error: ", e);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });