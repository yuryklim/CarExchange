const carExchange = artifacts.require("./CarExchange.sol");
const BearToken = artifacts.require('./BearToken.sol');


contract('car_exchange_buy', function (accounts) {
  beforeEach(async () => {
    sender = await carExchange.new();
    bear = await BearToken.new();
    await bear.transfer(accounts[1], 500);
    await sender.register(accounts[1], "1HGBH41JXMN109186", 5);
    await sender.register(accounts[1], "1HGBH41JXMN109188", 5);
    await sender.register(accounts[3], "1HGBH41JXMN109187", 5);
  });

  it("should be able to buy a new car by vin and send token", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    await bear.approve(sender.address, 5, {
      from: accountB
    });
    //console.log((await  bear.balanceOf(sender.address)).toString());
    let buyCar = await sender.buy(bear.address, "1HGBH41JXMN109187", {
      from: accountB
    });
    assert.equal(buyCar.logs[0].event, "Bought", "Bought event should be emitted");
  });

  it("should be able to register a car after it was bought", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    await bear.approve(sender.address, 5, {
      from: accountB
    });
    await sender.buy(bear.address, "1HGBH41JXMN109187", {
      from: accountB
    });
    let reqisterCar = await sender.register(accountB, "1HGBH41JXMN109187", 5, {
      from: accountB
    });
    assert.equal(reqisterCar.logs[0].event, "Registered", "Registered event should be emitted");
  });

  it("should revert if we try to buy the car that was already bought", async () => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD] = accounts;
    await bear.approve(sender.address, 10, {
      from: accountB
    });
    await sender.buy(bear.address, "1HGBH41JXMN109187", {
      from: accountB
    });
    try {
      await sender.buy(bear.address, "1HGBH41JXMN109187", {
        from: accountB
      });
    } catch (e) {
      assert.equal(e.message, "VM Exception while processing transaction: revert no car with such vin", "Error should be throwed");
    }
  });
});