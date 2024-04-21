// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    string private s_name;
    string private s_symbol;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) ERC20(_name, _symbol) {
        s_name = _name;
        s_symbol = _symbol;

        _mint(msg.sender, _initialSupply);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}
