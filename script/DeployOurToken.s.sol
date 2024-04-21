// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurToken is Script {
    OurToken ourToken;
    string constant TOKEN_NAME = "Coast";
    string constant TOKEN_SYMBOL = "C";
    uint256 constant INITIAL_SUPPLY = 100 ether;

    function run() external returns (OurToken) {
        ourToken = deployOurToken(TOKEN_NAME, TOKEN_SYMBOL, INITIAL_SUPPLY);
        return ourToken;
    }

    function deployOurToken(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) public returns (OurToken) {
        vm.startBroadcast();
        ourToken = new OurToken(_name, _symbol, _initialSupply);
        vm.stopBroadcast();
        console.log("The token has been deployed", ourToken.name());
        return ourToken;
    }
}
