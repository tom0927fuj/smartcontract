pragma solidity >=0.4.0 <0.7.0;

contract FujitaniCoin{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => int8) public blacklist;
    address public owner;
    
    modifier onlyOwner(){if(msg.sender != owner) revert();_;}


    event Transfer(address indexed from, address indexed to,uint256 value);
    event Blacklisted(address indexed from);
    event DeleteFromBlacklist(address indexed target);
    event RejectedPaymentToBlacklistedAddr(address indexed from,address indexed to,uint256 value);
    event RejectedPaymentFromBlacklistedAddr(address indexed from,address indexed to,uint256 value);
    
    constructor(uint256 _supply,string memory _name,string memory _symbol,uint8 _decimals)public{
        balanceOf[msg.sender] = _supply;
        name= _name;
        symbol=_symbol;
        decimals=_decimals;
        totalSupply=_supply;
        owner=msg.sender;
    }
    
    // (5) アドレスをブラックリストに登録する
    function blacklisting(address _addr) onlyOwner public{
        blacklist[_addr] = 1;
        emit Blacklisted(_addr);
    }

    // (6) アドレスをブラックリストから削除する
    function deleteFromBlacklist(address _addr) onlyOwner public{
        blacklist[_addr] = -1;
        emit DeleteFromBlacklist(_addr);
    }
    
    function transfer(address _to, uint256 _value) public{
    if (balanceOf[msg.sender] < _value) revert();
    if (balanceOf[_to] + _value < balanceOf[_to]) revert();
    // ブラックリストに存在するアドレスには入出金不可
    if (blacklist[msg.sender] > 0) {
      emit RejectedPaymentFromBlacklistedAddr(msg.sender, _to, _value);
    } 
    else if (blacklist[_to] > 0) {
      emit RejectedPaymentToBlacklistedAddr(msg.sender, _to, _value);
    }
    else{
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }
    
  }

}