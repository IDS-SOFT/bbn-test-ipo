
import { ethers } from "hardhat";

const companyName = "ABC";
const totalShares = "500";
const sharePrice = 100;
const paymentToken = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";

async function main() {

  const deploy_contract = await ethers.deployContract("IPOContract", [companyName, totalShares, sharePrice, paymentToken]);

  await deploy_contract.waitForDeployment();

  console.log("IPOContract is deployed to : ",await deploy_contract.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
