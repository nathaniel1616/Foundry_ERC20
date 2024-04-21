// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.sol";
import {OurToken} from "../src/OurToken.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken deployOurToken;
    address token_Owner;
    address Alice = makeAddr("Alice");
    address Bob = makeAddr("Bob");

    uint256 constant INITIAL_SUPPLY = 100 ether;
    uint256 constant AMOUNT = 5e5;

    function setUp() external {
        deployOurToken = new DeployOurToken();
        token_Owner = msg.sender;
        console.log("Determined the owner of Ourtoken", msg.sender);
        ourToken = deployOurToken.run();
    }

    function test_OurTokenIsDeployed() public view {
        assertEq(ourToken.symbol(), "C");
    }

    function test_DecimalsOfOurTokenIsSix() public view {
        assertEq(ourToken.decimals(), 6);
    }

    ////////////////////////////////////////////////
    ////   Testing InHerited Contract       ////////
    //// From ERC20 (from Openzeppelin)    /////////
    ////////////////////////////////////////////////
    function test_checkBalanceOf() public view {
        console.log("test function msg.sender", msg.sender);
        assertEq(ourToken.balanceOf(msg.sender), INITIAL_SUPPLY);
        assertEq(ourToken.balanceOf(Alice), 0);
    }

    function test_transfer() public {
        console.log("test function msg.sender", msg.sender);
        console.log(
            "token balance of msg.sender: ",
            ourToken.balanceOf(msg.sender)
        );
        vm.prank(token_Owner);
        ourToken.transfer(Alice, AMOUNT);
        assertEq(ourToken.balanceOf(Alice), AMOUNT);
    }

    function test_transferRevertWhenNotHavingNoToken() public {
        uint256 BalanceOfAlice = ourToken.balanceOf(Alice);
        // ourToken.transfer();
        // vm.expectRevert(IERC20Errors.ERC20InsufficientBalance.selector);
        // vm.expectRevert();

        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientBalance.selector,
                Alice,
                BalanceOfAlice,
                AMOUNT
            )
        );
        vm.prank(Alice);
        ourToken.transfer(Bob, AMOUNT);
    }
}
