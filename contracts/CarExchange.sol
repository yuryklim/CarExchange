pragma solidity 0.4.24;


contract CarExchange {
  struct RegisteredCars {
    address carOwner;
    string vinNumber;
  }
  mapping (uint => RegisteredCars) registeredCars;
  uint carNameIndex;

  //EVENTS//
  event Registered(string indexed _vinNumber, address indexed _owner);
  event Bought(uint indexed _vinNumber, address indexed _oldOwner, address indexed _newOwner, uint _value);
  event Listed(uint indexed _vinNumber, address indexed _carOwner, uint _value);

  // register a car
  //_vinNumber is a Vehicle Identification Number
  // start of implementation function register(address _owner, string _vinNumber)

  function register(address _owner, string _vinNumber) public returns (bool){
    require(!hasCar(_vinNumber));
    require(carNameIndex + 1 > carNameIndex);
    carNameIndex++;
    registeredCars[carNameIndex].carOwner = _owner;
    registeredCars[carNameIndex].vinNumber = _vinNumber;
    emit Registered(_vinNumber, _owner);
  }

  function hasCar(string vinNumber) internal view returns (bool) {
        uint8 index = getCarIndex(vinNumber);
        if (index == 0) {
            return false;
        }
        return true;
    }

    //We must check if the car with such vinNumber already exist
    function getCarIndex(string vinNumber) internal view returns (uint8) {
        for (uint8 i = 1; i <= carNameIndex; i++) {
            if (stringsEqual(registeredCars[i].vinNumber, vinNumber)) {
                return i;
            }
        }
        return 0;
    }
  // end of implementation function register(address _owner, string _vinNumber)

  // buy a car by _vinNumber that is listed for sale
  function buy(uint _vinNumber, uint _value) public returns (bool success){

  }

  // list a car for sale by _vinNumber
  function list(uint _vinNumber, uint _value) public returns (bool success){

  }

  // ownedCars display a list of cars belonging to an owner
  function ownedCars( address _owner) external view returns (uint[] vinNumbers){

  }



  // STRING COMPARISON FUNCTION //

  function stringsEqual(string storage _a, string memory _b) internal view returns (bool) {
    bytes storage a = bytes(_a);
    bytes memory b = bytes(_b);
      if (a.length != b.length) {
        return false;
      }
      // @todo unroll this loop
      for (uint i = 0; i < a.length; i ++) {
        if (a[i] != b[i]) {
          return false;
        }
      }
      return true;
  }
}
