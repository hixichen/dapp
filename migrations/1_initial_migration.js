var Migrations = artifacts.require("./Migrations.sol");
var Dice = artifacts.require("./Dice.sol");
module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Dice);
};
