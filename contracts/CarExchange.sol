pragma solidity ^0.4.24;

//  TODO: uze OpenZeppelin, implement as Ownable, use SafeMath for uint256
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
contract CarExchange is Ownable {
  using SafeMath for uint256;

  address public owner;

  ERC20 public ERC20token;
  struct Car {
    address carOwner;
    string vinNumber;
  }

  uint256 public carAmount;
  //  use explicit uint256
  mapping (uint256 => Car) public carDetails;  //  we have only registered cars here
  mapping (address => uint256[]) private ownerCars;  //  owner => carIndexes[]
  mapping (bytes32 => address) private carOwner;
  /**
  * @dev list of all supported tokens for transfer
  * @param string token symbol
  * @param address contract address of token
  */
  mapping(bytes32 => address) public tokens;

  //EVENTS//
  event Registered(string _vinNumber, address indexed _owner);
  event Bought(string _vinNumber, address indexed _oldOwner, address indexed _newOwner, uint256 _value);
//  event Listed(uint indexed _vinNumber, address indexed _carOwner, uint _value);
  constructor() public {
      owner = msg.sender;
    }

  /**
  * @dev function for registering a cars
  *_vinNumber is a Vehicle Identification Number and contains 17 characters (digits and capital letters)
  */
  function register(address _owner, string _vinNumber) public returns (bool){
    require(_owner != address(0), "address can not be 0");
    require(bytes(_vinNumber).length == 17, "wrong vin length");
    require(carOwner[convert(_vinNumber)] == address(0), "vin is already registered");

    carAmount += 1; //  TODO: use SafeMath
    carDetails[carAmount] = Car(_owner, _vinNumber);

    carOwner[convert(_vinNumber)] = _owner;
    ownerCars[_owner].push(carAmount);

    emit Registered(_vinNumber, _owner);
  }
  /**
  * @dev add function buy(...) for buying a car  by _vinNumber that is listed for sale
  * @param symbol_ symbol for something - TODO: rest functions
  */
  function buy(bytes32 symbol_, string _vinNumber, address _to, uint256 _value) public returns (bool) {
    /**
     *  TODO
     *  _to - no need in this. transfer tokens to this contract
     * _value - no need. Find car by _vinNumber and transfer it's price in tokens
     * symbol_ - remove. Use BearToken only
     */

      address contract_ = tokens[symbol_];  //  TODO: remove
      address from = msg.sender; // TODO: no need. Storage pays with gas, but calls like msg.sender are free
      ERC20token = ERC20(contract_);  //  TODO: remove
      address _oldOwner = carOwner[convert(_vinNumber)];//address of car owner
      require(_value > 0, "amount of ERC20 tokens must be higher than zero");  //  TODO: remove. transferFrom will fail if not enough
      require(IndexOfCar(_vinNumber) != 0, "no car with such vin");
<<<<<<< HEAD
      require(ERC20token.balanceOf(from) >= _value, "buyer has no enough amount of tokens");
      require(ERC20token.approve(from, _value), "allow to account from to spent tokens");
=======
      require(ERC20token.balanceOf(from) >= _value, "buyer has no enough amount of tokens"); //  TODO: remove. transferFrom will fail if not enough
>>>>>>> e63ac88c784c72fff2702937bdd11b2351ed6f0e
      delete (carDetails[IndexOfCar(_vinNumber)]);//remove car by _vinNumber from list of registered cars
      delete (carOwner[convert(_vinNumber)]);//remove the address of registered car (new owner is able to register it again)
      require(ERC20token.transferFrom(from, _to, _value), "can not perform transferFrom");
      emit Bought(_vinNumber, _oldOwner, from, _value);
  }

  function ownerForCar(string _vinNumber) public view returns (address) {
      return carOwner[convert(_vinNumber)];
  }

  function carsForOwner(address _owner) public view returns (uint256[]) {
      return ownerCars[_owner];
  }
  /**
  * @dev add posibility to get index of car in mapping carDetails by vin
  */
  function IndexOfCar(string _vinNumber) private view returns (uint256) {
      for (uint256 i = 1; i < carAmount + 1; i++) {
        if (convert(carDetails[i].vinNumber) == convert(_vinNumber))
        return i;
      }
      return 0;
  }

  /**
  * @dev add address of token to list of supported tokens using
  * token symbol as identifier in mapping
  * TODO: remove as other unnecessary functional
  */
  function addNewERC20Token(bytes32 symbol_, address address_) public onlyOwner returns (bool) {
      tokens[symbol_] = address_;
      return true;
  }



  // list a car for sale by _vinNumber
  /* function list(uint _vinNumber, uint _value) public returns (bool success){

  } */

  // ownedCars display a list of cars belonging to an owner
  /* function ownedCars( address _owner) external view returns (uint[] vinNumbers){

  } */

//  TODO: rename to express, what it does
  function convert(string key) private pure returns (bytes32 ret) {
    require(bytes(key).length <= 32);

    assembly {
      ret := mload(add(key, 32))
    }
  }
}
