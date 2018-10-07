pragma solidity ^0.4.24;


import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol"; //  TODO: reimplement this
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
* @title BearToken is a basic ERC20 Token
*/
contract BearToken is DetailedERC20, StandardToken, Ownable{

    uint256 public totalSupply;
  

    /**
    * @dev assign totalSupply to account creating this contract
    */
    constructor() DetailedERC20("BearToken", "BEAR", 5) public {

        totalSupply = 100000000000;

        owner = msg.sender;
        balances[msg.sender] = totalSupply;

        emit Transfer(0x0, msg.sender, totalSupply);
    }
}
