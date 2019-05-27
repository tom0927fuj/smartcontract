pragma solidity >=0.4.0 <0.7.0;

contract FujitaniCoin{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;


    event Transfer(address indexed from, address indexed to,uint256 value);
    
    constructor(uint256 _supply,string memory _name,string memory _symbol,uint8 _decimals)public{
        balanceOf[msg.sender] = _supply;
        name= _name;
        symbol=_symbol;
        decimals=_decimals;
        totalSupply=_supply;
    }
    function transfer(address _to, uint256 _value) public{
    // (5) 不正送金チェック
    if (balanceOf[msg.sender] < _value) revert();
    if (balanceOf[_to] + _value < balanceOf[_to]) revert();

    // (6) 送信アドレスと受信アドレスの残高を更新
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    // (7) イベント通知
    emit Transfer(msg.sender, _to, _value);
  }

}