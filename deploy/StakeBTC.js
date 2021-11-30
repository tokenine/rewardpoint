module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
    // const mvp_address = '0xDD7847deD760a8e7FB882B4A9B0e990323415ed9' // BKC
    // const mvpp_address ='0x9c882a7004D4bB7E5fa77856625225EA29619323' // BKC
    const mvp_address = '0x3379A0BdF5A5CB566127C421782686BA0f80490a' // BSC
    const mvpp_address ='0xF9800Ba96038AaCeA81734d2Ff40b7bC8358545D' // BSC
    const { deployer } = await getNamedAccounts()
  
    await deploy("MVPStakeBTC", {
      from: deployer,
      args: [mvp_address, mvpp_address],
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["MVPStakeBTC"]
  