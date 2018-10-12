const { expectThrow } = require ('../node_modules/openzeppelin-solidity/test/helpers/expectThrow');
const { EVMRevert } = require ('../node_modules/openzeppelin-solidity/test/helpers/EVMRevert');

const CarExchange = artifacts.require("./CarExchange.sol");

//  TODO: add empty lines, tabs
//  IVAN: empty lines, tabs were added

contract('car_exchange_register', function (accounts) {
  beforeEach(async () => {
    carExchange = await CarExchange.new();
  });

  it("should be possible to register a new car", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    let registerCar = await carExchange.register(accountA, "1HGBH41JXMN109186", 5);

    assert.equal(await carExchange.ownerForCar("1HGBH41JXMN109186"), accountA, "accountA is not owner");
    assert.equal(registerCar.logs[0].event, "Registered", "Registered event should be emitted");
  });

  it("should be possible to register a new car with the same account", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    await carExchange.register(accountA, "7HGBH41JXMN109186", 5);
    await carExchange.register(accountA, "8HGBH41JXMN109187", 5);

    assert.equal(await carExchange.ownerForCar("7HGBH41JXMN109186"), accountA, "accountA is not owner");
    assert.equal(await carExchange.ownerForCar("8HGBH41JXMN109187"), accountA, "accountA is not owner");
  });

  it("should revert if we try to register the car with the vinNumber that already exists", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    await carExchange.register(accountA,  "1HGBH41JXMN109188",  5);

    await expectThrow(
      carExchange.register(accountC,  "1HGBH41JXMN109188",  5),
        EVMRevert,
    );
  });

  it("should revert if we try to register the car with the vinNumber that is less then 17 characters", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    //  TODO:  please, reimplement using expectThrow helper in all places
    //  IVAN: reimplement using expectThrow helper in all places was done

    await expectThrow(
      carExchange.register(accountC,  "1HGBH41JXMN1091",  5),
        EVMRevert,
    );
  });

  it("should revert if we try to register the car with the vinNumber that is higher then 17 characters", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    await expectThrow(
      carExchange.register(accountC,  "1HGBH41JXMN10918899",  5),
        EVMRevert,
    );
  });

  it("should revert if we try to register the car with the 0x0 account", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    await expectThrow(
      carExchange.register(0x0,  "2HGBH41JXMN109188",  5),
        EVMRevert,
    );
  });

  it("should revert if we try to register the car with the carPrice 0", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;

    await expectThrow(
      carExchange.register(accountC,  "3HGBH41JXMN109188",  0),
        EVMRevert,
    );
  });
});
