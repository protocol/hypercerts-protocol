import { getNamedAccounts } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deploy } = hre.deployments; // we get the deployments and getNamedAccounts which are provided by hardhat-deploy.
  const { deployer } = await getNamedAccounts(); // The deployments field itself contains the deploy function.

  await deploy("HypercertSVG", { from: deployer });
};

export default deploy;
deploy.tags = ["local"];