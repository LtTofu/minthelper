pragma solidity ^0.4.26;
// Minthelper contract customized for COSMiC ERC918 token mining software.
//
// THANKS:
//  - Original `Minthelper` contract by Mikers (https://github.com/snissn)
//  - Additional Thanks to 0x1d00ffff (https://github.com/0x1d00ffff)
//

library SafeMath
{
    
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }

}

contract Ownable
{
  address public owner;

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
    constructor() public
    {
        owner = msg.sender;
    }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert();
    }
    _;
  }


}


contract ERC20Interface
{
    
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
}

contract ERC918Interface
{
    
    function totalSupply() public constant returns (uint);
    function getMiningDifficulty() public constant returns (uint);
    function getMiningTarget() public constant returns (uint);
    function getMiningReward() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function merge() public returns (bool success);
    // uint public lastRewardAmount;

    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);

    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
    
}


//
contract MintHelper is Ownable
{
    using SafeMath for uint;

    address public minterWallet;
//  address public mintableToken;
//  uint public minterFeePercent;

    constructor( address mWallet ) public
    {
      minterWallet = mWallet;
      //minterFeePercent = 2;
    }


//
// called by mining software to mint solutions, claim reward.
    function proxyMint( uint256 nonce, bytes32 challenge_digest, address mintableToken )
    public /* onlyOwner */
    returns (bool)
    {
    // pay to the miner's eth address, specified by first 20 bytes of a solution nonce
        address payoutAddr = address( uint160(nonce) );
        
    //identify the rewards that will be won and how to split them up
        uint totalReward = ERC918Interface(mintableToken).getMiningReward();    //get current reward in tokens
      
    //uint donatePercent = 2;
    //uint minterReward = totalReward.mul(donatePercent).div(100);              //developer gets 2% auto-donation
        uint minterReward = totalReward.mul(2).div(100);
      
        uint payoutReward = totalReward.sub(minterReward);                      //the miner gets 98% !
        
        require( (minterReward + payoutReward) == totalReward );
    //require( minterReward > 0 && minterReward < totalReward );
    //require( payoutReward > 0 && payoutReward < totalReward );
        
    // call mint() in selected erc918 token contract with solution nonce and its keccak256 digest. get paid in new tokens
        require( ERC918Interface(mintableToken).mint(nonce, challenge_digest ));

    //transfer the tokens to the correct wallets.
        require(ERC20Interface(mintableToken).transfer(minterWallet, minterReward));
        require(ERC20Interface(mintableToken).transfer(payoutAddr, payoutReward));
        
        return true;
    }


//withdraw any eth inside
// function withdraw()
//  public onlyOwner
//  {
//      msg.sender.transfer(address(this).balance);      
//  }


    //send tokens out
    function send(address _tokenAddr, address dest, uint value)
    public onlyOwner
    returns (bool)
    {
        return ERC20Interface(_tokenAddr).transfer(dest, value);
    }

}
