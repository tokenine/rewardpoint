module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments;
  // const mvp_address = '0xDD7847deD760a8e7FB882B4A9B0e990323415ed9' // BKC
  // const mvpp_address ='0x9c882a7004D4bB7E5fa77856625225EA29619323' // BKC
  // const mvp_address = '0x3379A0BdF5A5CB566127C421782686BA0f80490a' // BSC
  // const mvpp_address ='0x7E78a9b7c688c5b8152dF3f50f6F32E983f28ac8' // BSC
  const mvp_address = "0x9737e3Be617d482cFCF013358e1DEB188aB63E0B"; // META
  const mvpp_address = "0x4F9Bb119FD364479ffff56d616B86a248315BD27"; // META
  const { deployer } = await getNamedAccounts();

  await deploy("MVPStake", {
    from: deployer,
    args: [mvp_address, mvpp_address],
    log: true,
    deterministicDeployment: false,
  });
};

module.exports.tags = ["MVPStake"];
