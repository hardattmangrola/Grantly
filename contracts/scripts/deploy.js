const hre = require("hardhat");

async function main() {
  const Grantly = await hre.ethers.getContractFactory("Grantly");
  const grantly = await Grantly.deploy();

  await grantly.deployed();
  console.log(`Grantly contract deployed to: ${grantly.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
