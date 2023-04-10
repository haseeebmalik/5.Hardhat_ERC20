// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";



//initial supply  -  50 000
//capped / max-supply  -  100 000
//minting strategy
//block reward
//burnable


contract OceanToken is ERC20,ERC20Capped,ERC20Burnable {
    address payable public immutable i_owner;
    uint256 public  s_blockReward;
    address[] public s_blockMiners;
    mapping(address=>uint256) public s_addressToTokenAmount;  

error OceanToken__NotOwner(address caller,address owner);

    constructor (uint256 cap,uint256 reward) ERC20("OceanToken","OCT") ERC20Capped(cap * (10 ** decimals())){
       i_owner=payable(msg.sender);
       //here is a decimals function which is inherited from openzappelin ERC20
       //It will tell us the decimals our token have.
        _mint(i_owner,50000*(10** decimals()));
        s_blockReward=reward * (10** decimals());
    }
        function _mint(address account, uint256 amount) internal virtual override(ERC20Capped,ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _mintMinerReward() internal {
        // block.coinbase is the address of miner who record this 
        // transaction to blockchain
        _mint(block.coinbase,s_blockReward);
        s_blockMiners.push(block.coinbase); 
        s_addressToTokenAmount[block.coinbase]+=s_blockReward; 

    }

    function _beforeTokenTransfer(address from,address to, uint256 value) internal virtual override{
        if(from !=address(0) && to!=block.coinbase && block.coinbase!=address(0)){
           _mintMinerReward() ;
        }
        super._beforeTokenTransfer(from,to,value);
    }
    function destroy() public onlyOwner{
        selfdestruct(i_owner);
    }

    function setBlockReward(uint256 reward) public onlyOwner{
      s_blockReward=reward * (10** decimals());
    }

    function getOwner() public view returns(address){
        return i_owner; 
    }
    function getBlockMinerTokens(address minerAddress) public view returns(uint256){
      return s_addressToTokenAmount[minerAddress]; 
    }
    function getBlockMiners() public view returns(address[] memory){
       return s_blockMiners;  
    }


    modifier onlyOwner{
        if(msg.sender!=i_owner){
            revert OceanToken__NotOwner(msg.sender,i_owner);
        }
        _;
    }
}