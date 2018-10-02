pragma solidity ^0.4.24;

//  TODO: uze OpenZeppelin, implement as Ownable, use SafeMath for uint256
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
contract CarExchange is Ownable {
  using SafeMath for uint256;
  struct Car {
    address carOwner;
    string vinNumber;
  }

  uint256 public carAmount;
  //  use explicit uint256
  mapping (uint256 => Car) public carDetails;  //  we have only registered cars here
  mapping (address => uint256[]) private ownerCars;  //  owner => carIndexes[]
  mapping (bytes32 => address) private carOwner;

  //EVENTS//
  event Registered(string _vinNumber, address indexed _owner);
//  event Bought(uint indexed _vinNumber, address indexed _oldOwner, address indexed _newOwner, uint _value);
//  event Listed(uint indexed _vinNumber, address indexed _carOwner, uint _value);

  // register a car
  //_vinNumber is a Vehicle Identification Number and contains 17 characters (digits and capital letters)
  // start of implementation function register(address _owner, string _vinNumber)

  function register(address _owner, string _vinNumber) public returns (bool){
    require(_owner != address(0), "can not be 0");
    require(bytes(_vinNumber).length == 17, "wrong vin length");
    require(carOwner[convert(_vinNumber)] == address(0), "vin is already registered");

    carAmount += 1; //  TODO: use SafeMath
    carDetails[carAmount] = Car(_owner, _vinNumber);

    carOwner[convert(_vinNumber)] = _owner;
    ownerCars[_owner].push(carAmount);

    emit Registered(_vinNumber, _owner);
  }

  function ownerForCar(string _vinNumber) public view returns (address) {
      return carOwner[convert(_vinNumber)];
  }

  function carsForOwner(address _owner) public view returns (uint256[]) {
      return ownerCars[_owner];
  }

  // function hasCar(string vinNumber) internal view returns (bool) {
  //       uint8 index = getCarIndex(vinNumber);
  //       if (index == 0) {
  //           return false;
  //       }
  //       return true;
  //   }

  //   //We must check if the car with such vinNumber already exist
  //   function getCarIndex(string vinNumber) internal view returns (uint8) {
  //       for (uint8 i = 1; i <= carNameIndex; i++) {
  //           if (stringsEqual(registeredCars[i].vinNumber, vinNumber)) {
  //               return i;
  //           }
  //       }
  //       return 0;
  //   }
  // end of implementation function register(address _owner, string _vinNumber)

  // buy a car by _vinNumber that is listed for sale
  /* function buy(uint _vinNumber, uint _value) public returns (bool success){

  } */

  // list a car for sale by _vinNumber
  /* function list(uint _vinNumber, uint _value) public returns (bool success){

  } */

  // ownedCars display a list of cars belonging to an owner
  /* function ownedCars( address _owner) external view returns (uint[] vinNumbers){

  } */

  // STRING COMPARISON FUNCTION //

//   function stringsEqual(string storage _a, string memory _b) internal view returns (bool) {
//     bytes storage a = bytes(_a);
//     bytes memory b = bytes(_b);
//       if (a.length != b.length) {
//         return false;
//       }
//       // @todo unroll this loop
//       for (uint i = 0; i < a.length; i ++) {
//         if (a[i] != b[i]) {
//           return false;
//         }
//       }
//       return true;
//   }

  function convert(string key) private pure returns (bytes32 ret) {
    require(bytes(key).length <= 32);

    assembly {
      ret := mload(add(key, 32))
    }
  }
}
