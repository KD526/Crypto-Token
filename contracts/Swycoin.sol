//SPDX-License-Identifier: MIT

 pragma solidity ^0.8.9;
/// abstract shows a blueprint of functions to use in a contract
// acts a s aguide
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract ERC20Token {
    function name() public virtual view returns(string memory); 
    function symbol() public view virtual returns(string memory);
    function decimals() public view virtual returns(uint8);
    function totalSupply() public view virtual returns(uint256);
    function balanceOf(address _owner) public view virtual returns(uint256 balances);
    function transfer(address _receiver, uint256 _amount) public virtual returns(bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns(bool success);
    function approve(address _spender, uint256 _value) public virtual returns(bool success);
    function allowance(address _owner, address _spender) public view virtual returns(uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract Owned {
    address owner;
    address newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address _to) public {
        require(owner == msg.sender, 'only owner');
        newOwner = _to;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);

    }
}

/// swycoin inherits from ERC20Token and Owned contract

contract SwyCoin is ERC20Token, Owned {
    string public _name;
    string public _symbol;
    uint8 public _decimals;
    uint256 public _totalSupply;
    address public _minter;

    // address associated with balance of the owner
    mapping(address => uint256) public balances;

    // map addresses allowed to withdraw from owner 
    //mapping(address => mapping (address => uint256)) allowed;

    constructor() {
        _name = "SwyCoin";
        _symbol = "SCT";
        _decimals = 18;
        _totalSupply = 1000000;
        _minter = msg.sender; /// write your address

        balances[_minter] = _totalSupply; 

        emit Transfer(address(0), _minter, _totalSupply);

    }

    function mint(uint amount) public returns (bool) {
        require(_minter == msg.sender);
        balances[_minter] += amount;
        _totalSupply += amount;
        return true;
    }
    
    // override to redefine erc20 functions
    // used memory to store string data temporarily in the contract
    function name() public override view returns(string memory) {
        return _name;

    }

    function symbol() public override view returns(string memory) {
        return _symbol;
    }

    function decimals() public override view returns(uint8) {
        return _decimals;
    }

    function totalSupply() public override  view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns(uint256 balance) {
        return balances[_owner];
    }

    /// transfer on behalf of owner to any receiver
    function transferFrom(address _from, address _to, uint256 _value) public override returns(bool success) {
        require(balances[_from] >= _value, "Not enough tokens to transfer");
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // owner is able to transfer to any recipient address
    function transfer(address _to, uint256 _value) public override  returns(bool success) {
         require(balances[msg.sender] >= _value, "Not enough tokens to transfer");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    // function allows a spender to spend from the owner account
    function approve(address _spender, uint256 _value) public override returns(bool success) {
        return true;
    }

    // used to see how much a spender is allowed to spend from owner address
   function allowance(address _owner, address _spender) public override view returns (uint) {
        return 0;
    }


}