pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; 


contract rsbank is ERC20 {
    
    constructor(uint256 _totalSupply) ERC20("RS 20", "RS") {
        
        _mint(msg.sender, _totalSupply);
        
    }
    
}
