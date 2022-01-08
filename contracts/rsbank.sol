pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "./rs20.sol";

contract rsbank is ERC20 {

  mapping(address => uint) public entryStart;
  mapping(address => bool) public isDeposited;

  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint userBalance, uint depositTime, uint interest);
  event LoanTaken(address indexed user, uint Amount, uint timeStarted, uint interest);
  event LoanRepayed(address indexed user, uint timeTaken);

    
    constructor(uint256 _totalSupply) ERC20("RS 20", "RS") {
        
        _mint(msg.sender, _totalSupply);
        
    }

 function deposit() payable public {
    require(isDeposited[msg.sender] == false, "Error: Deposit already active!");
    require(msg.value >= 10**16, "Error: deposit value must be >= 0.01 ETH");

    getEtherBalance[msg.sender] = getEtherBalance[msg.sender] + msg.value;
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

    isDeposited[msg.sender] = true; //activate deposit status
    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    //check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true, 'Error: No previous deposit');
    uint userBalance = getEtherBalance[msg.sender];

    uint depositTime = block.timestamp - depositStart[msg.sender];
    //calc accrued interest
    uint interestPerSecond = 31668017 * (userBalance / 1e16); // 10% APY per year for 0.01 ETH
    uint interest = interestPerSecond * depositTime;

    token.mint(msg.sender, interest);

    msg.sender.transfer(userBalance);
    
    depositStart[msg.sender] = 0;
    getEtherBalance[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    emit Withdraw(msg.sender, userBalance, depositTime, interest);

  }

  function borrow() payable public {
      pass;
  }

  function payOff() public {
      pass;
  }
}

