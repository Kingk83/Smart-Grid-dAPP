const TWHToken = artifacts.require("TWHToken");

module.exports = function (deployer) {
  deployer.deploy(TWHToken);
};
