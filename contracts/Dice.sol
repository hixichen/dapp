// Dicero
// current contract address:
pragma solidity ^0.4.10;

contract Dice {
  uint64 seed = 0;
  uint64 constant upper = 10000;

  uint256 round_id = 0;
  uint public minBet = 1 finney;
  address public admin;

  uint public gasFee = 2300;
  uint public houseEdge = 190; //houseEdge(10000 = 100%)
  mapping(address => uint) public player;

  event LOG_StartBet(address _from, uint _amount, uint256 round_id);
  event LOG_EndBet(address _from, uint _amount, uint256 round_id);
  event LOG_LessThanMinBet(address _from, uint _amount);
  event LOG_TrasferToExtSuccess(address _from, uint _amount);
  event LOG_TransferToExtFail(address _from, uint _amount);
  event LOG_LessAmountToPlayer(address _from, uint _amount);
  event LOG_GetCurrentBalance(address _from, uint _amount);
  event LOG_SafeSendSuccess(address _from, uint _amount);
  event LOG_SafeSendFail(address _from, uint _amount);

  function Dice()  public payable {
    // constructor
    admin = msg.sender;
  }

  /* ============ This is the dice game =========
    core function: get random number and get result.
  */
  function bet(address addr, uint amount) public payable returns(uint256, uint) {

    if ( amount < minBet) {
      LOG_LessThanMinBet(addr, amount);
      return (round_id, amount);
    }
    round_id++;
    LOG_StartBet(addr, amount, round_id);

    //player[addr] = amount;
    uint64 rand_num = random();
    uint bet_value = amount - gasFee;
    uint player_result = bet_value * (rand_num * 2 - houseEdge) / upper;
    LOG_EndBet(addr, player_result, round_id);
    return (round_id, player_result);
  }

  /* ==========  internal helper function =========*/
  // return a pseudo random number between lower and upper bounds
  // given the number of previous blocks it should hash.
  function random() public returns (uint64 randomNumber) {
    seed = uint64(keccak256(keccak256(block.blockhash(block.number), seed), now));
    return seed % upper;
  }

  /* require admin */
  modifier onlyAdmin {
    require(msg.sender == admin);
    _;
  }

  /*========= admin configuration ========*/
  function configGas(uint gasAmount) public onlyAdmin {
    gasFee = gasAmount;
  }

  function configMinBet(uint amount) public onlyAdmin {
    minBet = amount;
  }

  function configHouseEdge(uint amount) public onlyAdmin {
    minBet = amount;
  }

  function changeAdmin() public onlyAdmin {
    admin = msg.sender;
  }

  /*========= functionality ========*/
  function getContractBalance() public onlyAdmin returns(uint) {
      LOG_GetCurrentBalance(this, this.balance);
      player[msg.sender] = 100 finney;
      return this.balance;
  }

  function getPlayerBalance(address addr) public onlyAdmin returns(uint) {
      LOG_GetCurrentBalance(addr, player[addr]);
  		return player[addr];
  }

  function transferToExternal(uint amount) public onlyAdmin {
    if(int(this.balance - amount) <= 0) {
        LOG_TransferToExtFail(admin, amount);
    }
    admin.transfer(amount);
    LOG_TrasferToExtSuccess(admin, amount);
  }

  /*===  distribution the fund. =======*/
  function safeSend(address player_addr, uint amount) public payable onlyAdmin {
      if(amount == 0){
        return;
      }

      if(this.balance < amount) {
         LOG_LessAmountToPlayer(player_addr, amount);
         //TODO

      }else {

        if (!(player_addr.call.gas(gasFee).value(amount)())){
          LOG_SafeSendFail(player_addr, amount);
          revert();
        }
      }

     LOG_SafeSendSuccess(player_addr, amount);
  }

  function destroy() public onlyAdmin {
    selfdestruct(admin);
  }
}
