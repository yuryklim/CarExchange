var carExchange = artifacts.require("./CarExchange.sol");
contract('CarExchange', function(accounts) {
  it("should be possible to register a new car", function() {
        var myCarExchangeInstance;
        return carExchange.deployed().then(function (instance) {
            myCarExchangeInstance = instance;
            return myCarExchangeInstance.register(accounts[0], "1HGBH41JXMN109186");
        }).then(function (txResult) {
            console.log(txResult);
            assert.equal(txResult.logs[0].event, "Registered", "Registered event should be emitted");
        });
  });
  it("should be possible to register a new car with the same account", function() {
        var myCarExchangeInstance;
        return carExchange.deployed().then(function (instance) {
            myCarExchangeInstance = instance;
            return myCarExchangeInstance.register(accounts[0], "1HGBH41JXMN109187");
        }).then(function (txResult) {
            console.log(txResult);
            assert.equal(txResult.logs[0].event, "Registered", "Registered event should be emitted");
        });
  });
  it("should be possible to register a new car with another account", function() {
        var myCarExchangeInstance;
        return carExchange.deployed().then(function (instance) {
            myCarExchangeInstance = instance;
            return myCarExchangeInstance.register(accounts[1], "1HGBH41JXMN109188");
        }).then(function (txResult) {
            console.log(txResult);
            assert.equal(txResult.logs[0].event, "Registered", "Registered event should be emitted");
        });
  });
});
