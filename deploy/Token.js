 module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments

  const { deployer, dev } = await getNamedAccounts()

  const Token = await deploy("TokenineRewardPoint", {
    from: deployer,
    log: true,
    deterministicDeployment: false
  })
  await (await Token.transferOwnership(dev)).wait()
}

module.exports.tags = ["TokenineRewardPoint"]
