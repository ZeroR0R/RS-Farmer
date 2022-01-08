pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract rsfarmer is ERC20 {
    
    using Address for address;
    using SafeERC20 for IERC20;
    
    IERC20 public token;
    
    constructor(address _token) ERC20("RSFarmer", "RSF") {
        
        token = IERC20(_token);
        
    }
    
    function balance() public view returns (uint256) {
        
        return token.balanceOf(address(this));
        
    }
    
    function deposit(uint256 _amount) public {
        
        require(_amount > 0, "You must deposit more than 0");
        
        token.safeTransferFrom(msg.sender, address(this), _amount);
        
        _mint(msg.sender, _amount);
        
    }
    
    function withdraw(uint256 _amount) public {
        
        require(_amount > 0, "You must withdraw more than 0");
        require(balanceOf(address(this)) >= _amount, "This Contract does not have that many tokens");
        
        _burn(msg.sender, _amount);
        token.safeTransfer(msg.sender, _amount);
        
    }
    
}
