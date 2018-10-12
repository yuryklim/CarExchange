pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./BearToken.sol";
contract CarExchange is Ownable {
  using SafeMath for uint256;

  address public owner;

  BearToken public bearToken;

  struct Car {
    address carOwner;
    string vinNumber;
    uint256 carPrice;
  }

  uint256 public carAmount;
  //  use explicit uint256
  mapping (uint256 => Car) public carDetails;  //  we have only registered cars here
  //  IVAN: here we have a problem, address => {1,  2,  5} for example, car with index 2 was bought
  //  How to remove this index 2 from this array uint256[]?
  mapping (address => uint256[]) private ownerCars;  //  owner => carIndexes[]
  mapping (bytes32 => address) private carOwner;

  //EVENTS//
  event Registered(string _vinNumber, address indexed _owner, uint256 indexed _carPrice);
  event Bought(string _vinNumber, address indexed _oldOwner, address indexed _newOwner, uint256 _value);
//  event Listed(uint indexed _vinNumber, address indexed _carOwner, uint _value);
  constructor() public {
      owner = msg.sender;
    }

  /**
  * @dev function for registering a cars
  * @param _vinNumber Is a Vehicle Identification Number and contains 17 characters (digits and capital letters)
  * @param _owner The address of person who owns the car
  * @param _carPrice The price in tokens of the registered car
  * @return A bool that registration of a new car was successful
  */
  function register(address _owner, string _vinNumber, uint256 _carPrice) public returns (bool) {

    require(_owner != address(0), "address can not be 0");
    require(_carPrice > 0, "price of car can not be 0");
    require(bytes(_vinNumber).length == 17, "wrong vin length");
    require(carOwner[convertStringToBytes32(_vinNumber)] == address(0), "vin is already registered");

    carAmount += 1;
    carDetails[carAmount] = Car(_owner, _vinNumber, _carPrice);

    carOwner[convertStringToBytes32(_vinNumber)] = _owner;
    ownerCars[_owner].push(carAmount);

    emit Registered(_vinNumber, _owner, _carPrice);
  }

  /**
  * @dev add function buy(...) for buying a car  by _vinNumber that is listed for sale
  * @param token The address of token that is using for buying a car
  * @param _vinNumber Is a Vehicle Identification Number and contains 17 characters (digits and capital letters)
  * @return A boolean that process of buying was successful
  */
  function buy(address token, string _vinNumber) public returns (bool) {

    bearToken = BearToken(token);

    require(indexOfCar(_vinNumber) != 0, "no car with such vin");
    require(bearToken.balanceOf(msg.sender) >= priceForCar(_vinNumber), "buyer has no enough amount of tokens");

    //  IVAN: here we have a problem with transactions which can perform simultaneously and our contract
    //  will get 2 * carPrice amount of tokens or even more:)
    require(bearToken.approve(owner, priceForCar(_vinNumber)), "allow to owner to spent tokens");
    require(bearToken.transferFrom(msg.sender, owner, priceForCar(_vinNumber)));

    emit Bought(_vinNumber, carOwner[convertStringToBytes32(_vinNumber)], msg.sender, priceForCar(_vinNumber));

    delete (carDetails[indexOfCar(_vinNumber)]);  //  remove car by _vinNumber from list of registered cars
    delete (carOwner[convertStringToBytes32(_vinNumber)]);  //  remove the address of registered car (new owner is able to register it again)
  }

  /**
  * @dev add posibility to get address of car owner
  * @param _vinNumber vinNumber of car
  * @return An address of car owner
  */
  function ownerForCar(string _vinNumber) public view returns (address) {
    return carOwner[convertStringToBytes32(_vinNumber)];
  }

  /**
  * @dev add posibility to get indexes of car that belong to certain address
  * @param _owner address of person who posess this car
  * @return A uint256[] array of car indexes for certain address
  */
  function carsForOwner(address _owner) public view returns (uint256[]) {
    //  IVAN: not correct return after car was bought: {1, 2,  5}
    return ownerCars[_owner];
  }

  /**
  * @dev add posibility to get price of car in mapping carDetails by vin
  * @param _vinNumber vinNumber of car
  * @return A uint256 price of car with this vinNumber in mapping carDetails
  */
  function priceForCar(string _vinNumber) public view returns (uint256) {
    return carDetails[indexOfCar(_vinNumber)].carPrice;
  }

  /**
  * @dev add posibility to get index of car in mapping carDetails by vin
  * @param _vinNumber vinNumber of car
  * @return A uint256 index of car with this vinNumber in mapping carDetails
  * If there no car with such vinNumber returns 0
  */
  function indexOfCar(string _vinNumber) private view returns (uint256) {
    for (uint256 i = 1; i < carAmount + 1; i++) {
      if (convertStringToBytes32(carDetails[i].vinNumber) == convertStringToBytes32(_vinNumber))
        return i;
      }
        return 0;
  }

  // list a car for sale by _vinNumber
  /* function list(uint _vinNumber, uint _value) public returns (bool success){

  } */

  // ownedCars display a list of cars belonging to an owner
  /* function ownedCars( address _owner) external view returns (uint[] vinNumbers){

  } */

  /**
  * @dev add posibility to conbert string to bytes32
  * @param key Any string
  * @return A bytes32
  */
  function convertStringToBytes32(string key) private pure returns (bytes32 ret) {
    require(bytes(key).length <= 32);

    assembly {
      ret := mload(add(key, 32))
    }
  }
}
