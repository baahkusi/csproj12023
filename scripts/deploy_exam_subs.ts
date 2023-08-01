import { ethers } from "hardhat";
import 'dotenv/config'

async function main() {

  const c = await ethers.deployContract("ExamSubmissions", [process.env.ADMIN_ADDRESS, process.env.HOD_ADDRESS]);

  await c.waitForDeployment();

  const { ...tx } = c.deploymentTransaction()?.toJSON()
  tx.data = await c.getAddress()

  console.log(`deployed to ${JSON.stringify(tx, null, 2)}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
