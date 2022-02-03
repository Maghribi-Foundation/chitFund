const ChitFund = artifacts.require("ChitFund");
const ChitFundFactory = artifacts.require("ChitFundFactory");

module.exports = function (deployer) {
  deployer.deploy(ChitFund, "BeatInflation", 1, 18, 18);
  deployer.deploy(ChitFundFactory);
};
