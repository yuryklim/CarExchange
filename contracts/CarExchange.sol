pragma solidity 0.4.24;


contract CarExchange {
  // register a car
  function register(address _owner, uint _vinNumber ) public returns (bool success);

  // buy a car by _vinNumber that is listed for sale
  function buy(uint _vinNumber, uint _value) public returns (bool success);

  // list a car for sale by _vinNumber
  function list(uint _vinNumber, uint _value) public returns (bool success);

  // ownedCars display a list of cars belonging to an owner
  function ownedCars( address _owner) external view returns (uint[] vinNumbers);

  event Registered(uint indexed _vinNumber, address indexed _owner);
  event Bought(uint indexed _vinNumber, address indexed _oldOwner, address indexed _newOwner, uint _value);
  event Listed(uint indexed _vinNumber, address indexed _carOwner, uint _value);
} 
