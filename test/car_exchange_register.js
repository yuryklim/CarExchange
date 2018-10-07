const carExchange = artifacts.require("./CarExchange.sol");
contract('car_exchange_register', function(accounts) {
  it("should be possible to register a new car", async() => {
    sender = await carExchange.new();
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    let registerCar = await sender.register(accountA, "1HGBH41JXMN109186", 5);
    assert.equal(await sender.ownerForCar("1HGBH41JXMN109186"), accountA, "accountA is not owner");
    assert.equal(registerCar.logs[0].event, "Registered", "Registered event should be emitted");
  });
  it("should be possible to register a new car with the same account", async() => {
    sender = await carExchange.new();
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    await sender.register(accountA, "1HGBH41JXMN109186", 5);
    //console.log((await sender.register(accountA, "2HGBH41JXMN109186")).logs[0].event);
    await sender.register(accountA, "1HGBH41JXMN109187", 5);
    assert.equal(await sender.ownerForCar("1HGBH41JXMN109187"), accountA, "accountA is not owner");
    assert.equal(await sender.ownerForCar("1HGBH41JXMN109186"), accountA, "accountA is not owner");
  });
  it("should revert if we try to register the car with the vinNumber that already exists", async() => {
    sender = await carExchange.new();
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    await sender.register(accountA, "1HGBH41JXMN109188", 5);
    try {
      await sender.register(accountA, "1HGBH41JXMN109188", 5);
    } catch(e) {
      assert.equal(e.message, "VM Exception while processing transaction: revert vin is already registered", "Error should be throwed");
    }
  });
  it("should revert if we try to register the car with the vinNumber that is less then 17 characters", async() => {
    sender = await carExchange.new();
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    try{
      await sender.register(accountB, "1HGBH41JXMN", 5);
    } catch(e){
      assert.equal(e.message, "VM Exception while processing transaction: revert wrong vin length", "Error should be throwed");
    }
  });

  it("should revert if we try to register the car with the vinNumber that is higher then 17 characters", async() => {
    sender = await carExchange.new();
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    try{
      await sender.register(accountC, "1HGBH41JXMN109188909", 5);
    } catch(e){
      assert.equal(e.message, "VM Exception while processing transaction: revert wrong vin length", "Error should be throwed");
    }
  });
  it("should revert if we try to register the car with the 0x0 account", async() => {
    sender = await carExchange.new();
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    try{
      await sender.register("0x0", "1HGBH41JXMN109188", 5);
    } catch(e){
      assert.equal(e.message, "VM Exception while processing transaction: revert address can not be 0", "Error should be throwed");
    }
  });
});
