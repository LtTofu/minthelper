var _Dummy0xBTC = artifacts.require("./_Dummy0xBTC.sol");
var _MintHelper = artifacts.require("./MintHelper.sol");
//var _SkeleToken = artifacts.require("./ERC20Interface.sol");
//var _Dummy0xBTC = artifacts.require("./ERC918Interface.sol");
//var _SafeMath = artifacts.require("./SafeMath.sol");

module.exports = function(deployer) {
  deployer.deploy(_Dummy0xBTC);
  deployer.deploy(_MintHelper);
};
