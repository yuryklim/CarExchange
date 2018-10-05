const carExchange = artifacts.require("./CarExchange.sol");
const BearToken = artifacts.require('./BearToken.sol');
contract('CarExchange', function(accounts) {
  beforeEach(async () => {
        sender = await carExchange.new();
        bear = await BearToken.new();
        await bear.transfer(accounts[1], 500);
        await sender.addNewERC20Token('BEAR', bear.address);
    });
    it("should be able to transfer sender token to another wallet", async() => {
      let accountA, accountB, accountC, accountD;
      let amount = 5;

      [accountA, accountB, accountC, accountD ] = accounts;
      await bear.approve(sender.address, amount,{from: accountB});
      await sender.register(accounts[1], "1HGBH41JXMN109186");
      let balance = ((await  bear.balanceOf(accountB)).toString());
      console.log(balance);
      await sender.buy('BEAR', "1HGBH41JXMN109186", accountC, 5, {from: accountB});
      let balance1 = ((await  bear.balanceOf(accountB)).toString());
      console.log(balance1);
      console.log(sender.carDetails.toString());
      // await sender.buy('BEAR', "1HGBH41JXMN109186", accountD, 5, {from: accountA});
      // let balance2 = ((await  bear.balanceOf(accountA)).toString());
      // console.log(balance2);


  });

  it("should be possible to register a new car", function() {
        var myCarExchangeInstance;
        return carExchange.deployed().then(function (instance) {
            myCarExchangeInstance = instance;
            return myCarExchangeInstance.register(accounts[0], "1HGBH41JXMN109186");
        }).then(function (txResult) {
            //console.log(txResult);
            assert.equal(txResult.logs[0].event, "Registered", "Registered event should be emitted");
        });
  });

  it("should be possible to register a new car with the same account", function() {
        var myCarExchangeInstance;
        return carExchange.deployed().then(function (instance) {
            myCarExchangeInstance = instance;
            return myCarExchangeInstance.register(accounts[0], "1HGBH41JXMN109187");
        }).then(function (txResult) {
            //console.log(txResult);
            assert.equal(txResult.logs[0].event, "Registered", "Registered event should be emitted");
        });
  });

  it("should be possible to register a new car with another account", function() {
        var myCarExchangeInstance;
        return carExchange.deployed().then(function (instance) {
            myCarExchangeInstance = instance;
            return myCarExchangeInstance.register(accounts[1], "1HGBH41JXMN109188");
        }).then(function (txResult) {
            //console.log(txResult);
            assert.equal(txResult.logs[0].event, "Registered", "Registered event should be emitted");
        });
  });

  it("should revert if we try to register the car with the vinNumber that already exists", async() => {
    let instant = await carExchange.deployed();
    try{
      await instant.register(accounts[1], "1HGBH41JXMN109188");
    } catch(e){
      assert.equal(e.message, "VM Exception while processing transaction: revert vin is already registered", "Error should be throwed");
    }
  });

  it("should revert if we try to register the car with the vinNumber that is less then 17 characters", async() => {
    let instant = await carExchange.deployed();
    try{
      await instant.register(accounts[1], "1HGBH41JXMN");
    } catch(e){
      assert.equal(e.message, "VM Exception while processing transaction: revert wrong vin length", "Error should be throwed");
    }
  });

  it("should revert if we try to register the car with the vinNumber that is higher then 17 characters", async() => {
    let instant = await carExchange.deployed();
    try{
      await instant.register(accounts[1], "1HGBH41JXMN109188909");
    } catch(e){
      assert.equal(e.message, "VM Exception while processing transaction: revert wrong vin length", "Error should be throwed");
    }
  });
});
