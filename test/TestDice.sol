pragma solidity ^0.4.10;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Dice.sol";


contract TestDice {

  function testInitialBet() {
    Dice dice = Dice(DeployedAddresses.Dice());
    uint value = 100 finney;
    var (id, result) = dice.bet(dice, value);
    Assert.isAtMost(result, value*2, "result");
    Assert.equal(id, 1, "id");
    //Assert.equal(dice.getContractBalance(), value, "get balance failed");
  }
}
