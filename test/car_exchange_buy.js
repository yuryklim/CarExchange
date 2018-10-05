const carExchange = artifacts.require("./CarExchange.sol");
const BearToken = artifacts.require('./BearToken.sol');
contract('car_exchange_buy', function(accounts) {
  beforeEach(async () => {
        sender = await carExchange.new();
        bear = await BearToken.new();
        await bear.transfer(accounts[1], 500);
        await sender.addNewERC20Token('BEAR', bear.address);
        await sender.register(accounts[1], "1HGBH41JXMN109186");
        await sender.register(accounts[1], "1HGBH41JXMN109188");
        await sender.register(accounts[3], "1HGBH41JXMN109187");
    });
  it("should be able to buy a new car by vin and send token", async() => {
        let accountA, accountB, accountC, accountD;
        [accountA, accountB, accountC, accountD ] = accounts;
        let amount = 5;
        await bear.approve(sender.address, amount, {from: accountB});
        let balanceBeforeBuySender = ((await  bear.balanceOf(accountB)).toString());
        let balanceBeforeBuyReceiver = ((await  bear.balanceOf(accountC)).toString());
        assert.equal(balanceBeforeBuySender, 500, "not correct ballance before buy for sender");
        assert.equal(balanceBeforeBuyReceiver, 0, "not correct ballance before buy for receiver");
        let buyCar = await sender.buy('BEAR', "1HGBH41JXMN109187", accountC, amount, {from: accountB});
        let balanceAfterBuySender = ((await  bear.balanceOf(accountB)).toString());
        let balanceAfterBuyReceiver = ((await  bear.balanceOf(accountC)).toString());

        assert.equal(balanceAfterBuySender, 495, "not correct ballance after buy for sender");
        assert.equal(balanceAfterBuyReceiver, 5, "not correct ballance after buy for receiver");
        assert.equal(buyCar.logs[0].event, "Bought", "Bought event should be emitted");
  });
  it("should revert if we try to buy the car that was already bought", async() => {
    let accountA, accountB, accountC, accountD;
    [accountA, accountB, accountC, accountD ] = accounts;
    let amount = 5;
    await bear.approve(sender.address, 10, {from: accountB});
    await sender.buy('BEAR', "1HGBH41JXMN109187", accountC, amount, {from: accountB});
    try {
      await sender.buy('BEAR', "1HGBH41JXMN109187", accountD, amount, {from: accountB});
    } catch(e) {
      assert.equal(e.message, "VM Exception while processing transaction: revert no car with such vin", "Error should be throwed");
      assert.equal((await bear.balanceOf(accountD)).toString(), 0, "accountD received tokens");
      assert.equal((await bear.balanceOf(accountB)).toString(), 495, "accountB transfered tokens");
    }
  });
});
