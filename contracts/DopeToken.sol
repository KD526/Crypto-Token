//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DopeToken is ERC20 {
    address public admin;
    mapping(address => uint256) public balances;
    
    constructor() ERC20("Dope Token", "DT") {

        _mint(msg.sender, 100000 * 10 ** 18);
    }

    function mint(address to, uint amount) external {
        require(msg.sender == admin, 'Only admin needed');
        _mint(to, amount);
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
    }



}