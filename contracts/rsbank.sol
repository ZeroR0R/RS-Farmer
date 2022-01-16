pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 
import "./rs20.sol";

contract rsbank is ERC20 {

  mapping(address => uint) public getEthBalance;
  mapping(address => uint) public entryStart;
  mapping(address => bool) public isDeposited;
  mapping(address => bool) public isBorrowing;
  mapping(address => uint) public BorrowAmount;

  event Deposit(address indexed user, uint ethAmount, uint timeStart);
  event Withdraw(address indexed user, uint userBalance, uint depositTime, uint interest);
  event LoanTaken(address indexed user, uint Amount, uint timeStarted, uint interest);
  event LoanRepayed(address indexed user, uint timeTaken);

  IERC20 public rstoken;
    
    constructor(uint256 _totalSupply) ERC20("RS 20", "RS") {
        
        _mint(msg.sender, _totalSupply);
        rstoken = IERC20(address(this));
        
    }

 function deposit() payable public {
    require(isDeposited[msg.sender] != true, "Error: Deposit already active!");
    require(msg.value >= 10**16, "Error: deposit value must be >= 0.01 ETH");

    getEthBalance[msg.sender] = getEthBalance[msg.sender] + msg.value;
    entryStart[msg.sender] = entryStart[msg.sender] + block.timestamp;

    isDeposited[msg.sender] = true; //activate deposit status
    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public payable{
    //check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true, 'Error: No previous deposit');
    uint _userBalance = getEthBalance[msg.sender];

    uint _depositTime = block.timestamp - entryStart[msg.sender];
    //calc accrued interest
    uint _interestPerSecond = 31668017 * (_userBalance / 1e16); // 10% APY per year for 0.01 ETH
    uint _interest = _interestPerSecond * _depositTime;

    _mint(msg.sender, _interest);

    payable(msg.sender).transfer(_userBalance);
    
    entryStart[msg.sender] = 0;
    getEthBalance[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    emit Withdraw(msg.sender, _userBalance, entryStart[msg.sender], _interest);

  }

  function borrow(uint _collateral) payable public {
    require(isDeposited[msg.sender] == false, "Error: Already Deposited");
    require(msg.value >= 10**16, "Error: deposit value must be >= 0.01 ETH");
    require(isBorrowing[msg.sender] != true, "Error: Loan already active!");

    entryStart[msg.sender] = entryStart[msg.sender] + block.timestamp;
    uint _amount = msg.value * 100;

    BorrowAmount[msg.sender] = _amount;
    _mint(msg.sender, BorrowAmount[msg.sender]);
    isBorrowing[msg.sender] = true;

    uint _interest = _amount/1;

    emit LoanTaken(msg.sender, _amount, entryStart[msg.sender], _interest);

  }

  function payOff() public {
      require(isBorrowing[msg.sender] == true, "Error: Loan not active!");
      
  }
}

