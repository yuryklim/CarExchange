//solium-disable linebreak-style
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
        bool forSale;
    }

    uint256 public carAmountTotal;  // sold + unsold
    Car[] public carList;  // sold + unsold
    mapping(bytes32 => uint256) public carIndex; //  index in carList
    mapping(address => uint256[]) public carIndexesForOwner;  //  address => indexes[] //  TODO: implement

  //EVENTS//
    event Registered(string _vinNumber, address indexed _owner, uint256 indexed _carPrice);
    event Bought(string _vinNumber, address indexed _oldOwner, address indexed _newOwner, uint256 _value);
  
  
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
        // IVAN: carAmountTotal == 0 will be true if no car in carList
        // !carRegistered(_vinNumber) will be true if there is no car with such vin in carList
        // !carList[indexOfCar(_vinNumber)].forSale will be true if car was bought. A new owner can register it again
        require(carAmountTotal == 0 || !carRegistered(_vinNumber) || !carList[indexOfCar(_vinNumber)].forSale, "vin is already registered");

        carIndex[keccak256(abi.encodePacked(_vinNumber))] = carAmountTotal;
        carAmountTotal = carAmountTotal.add(1);
        carList.push(Car(_owner, _vinNumber, _carPrice, true));

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

        uint256 idx = indexOfCar(_vinNumber);
        require(carList[idx].forSale, "car is sold");
    
        uint256 price = carList[idx].carPrice;
    //  TODO: check allowence
    //  IVAN: check allowance was done
       // require(bearToken.allowance(msg.sender, owner) == price, "remaining is less than price");

        require(bearToken.transferFrom(msg.sender, owner, price), "transferFrom was failed");

        address prevOwner = carList[idx].carOwner;
        carList[idx].forSale = false;
        carList[idx].carOwner = msg.sender;

        emit Bought(_vinNumber, prevOwner, msg.sender, price);
    }

  // HELPERS
    function carRegistered(string _vinNumber) public view returns (bool) {
        return stringsEqual(carList[carIndex[keccak256(abi.encodePacked(_vinNumber))]].vinNumber, _vinNumber);
    }

    function carForSale(string _vinNumber) public view returns (bool) {
        uint256 idx = indexOfCar(_vinNumber);
        return carList[idx].forSale;
    }

    function getOwner() public view returns (address) {
        return owner;
    }


  /**
  * @dev add posibility to get index of car in mapping carDetails by vin
  * @param _vinNumber vinNumber of car
  * @return A uint256 index of car with this vinNumber in mapping carDetails
  * If there no car with such vinNumber returns 0
  */
    function indexOfCar(string _vinNumber) public view returns (uint256) {
        uint256 idx = carIndex[keccak256(abi.encodePacked(_vinNumber))];

        require(stringsEqual(carList[idx].vinNumber, _vinNumber), "vin number not registered");

        return idx;
    }

  /**
  * @dev add posibility to convert string to bytes32
  * @param key Any string
  * @return A bytes32
  */
    function convertStringToBytes32(string key) private pure returns (bytes32 ret) {
        require(bytes(key).length <= 32, "length > 32");

        assembly {
          ret := mload(add(key, 32))
        }
    }

    function stringsEqual (string a, string b) private pure returns (bool){
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}
