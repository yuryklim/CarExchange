// const { expectThrow } = require ('../node_modules/openzeppelin-solidity/test/helpers/expectThrow');
// const { EVMRevert } = require ('../node_modules/openzeppelin-solidity/test/helpers/EVMRevert');
//
// const CarExchange = artifacts.require ("./CarExchange.sol");
// const BearToken = artifacts.require ('./BearToken.sol');
//
// //  TODO: use test helpers - look for Ambisafe git and OpenZeppelin git test folders.
// //  IVAN: test helpers from OpenZeppelin was used
// contract('car_exchange_buy', function (accounts) {
//
//   beforeEach(async () => {
//     //  TODO: why name is sender? Rename, please
//     //  IVAN: sender was renamed to carExchange and bear to bearToken
//     carExchange = await CarExchange.new();
//     bearToken = await BearToken.new();
//
//     await bearToken.transfer(accounts[1], 500);
//
//     await carExchange.register(accounts[1], "1HGBH41JXMN109186", 5);
//     await carExchange.register(accounts[1], "1HGBH41JXMN109188", 5);
//     await carExchange.register(accounts[3], "1HGBH41JXMN109187", 5);
//   });
//
//   it("should be able to buy a new car by vin and send token", async () => {
//     let accountA, accountB, accountC, accountD;
//     [accountA, accountB, accountC, accountD] = accounts;
//
//     await bearToken.approve(carExchange.address, 5, {
//       from: accountB
//     });
//
//     let buyCar = await carExchange.buy(bearToken.address, "1HGBH41JXMN109187", {
//       from: accountB
//     });
//
//     assert.equal(buyCar.logs[0].event, "Bought", "Bought event should be emitted");
//   });
//
//   it("should be able to register a car after it was bought", async () => {
//     let accountA, accountB, accountC, accountD;
//     [accountA, accountB, accountC, accountD] = accounts;
//
//     await bearToken.approve(carExchange.address, 5, {
//       from: accountB
//     });
//
//     await carExchange.buy(bearToken.address, "1HGBH41JXMN109187", {
//       from: accountB
//     });
//
//     let reqisterCar = await carExchange.register(accountB, "1HGBH41JXMN109187", 5, {
//       from: accountB
//     });
//
//     assert.equal(reqisterCar.logs[0].event, "Registered", "Registered event should be emitted");
//   });
//
//   it("should reject the try to buy car that was already bought", async () => {
//     let accountA, accountB, accountC, accountD;
//     [accountA, accountB, accountC, accountD] = accounts;
//
//     await bearToken.approve(carExchange.address, 10, {
//       from: accountB
//     });
//
//     await carExchange.buy(bearToken.address,  "1HGBH41JXMN109187", {
//       from: accountB
//     });
//
//     await expectThrow(
//       carExchange.buy(bearToken.address,  "1HGBH41JXMN109187", {
//         from: accountB
//         }),
//         EVMRevert,
//     );
//   });
// });
