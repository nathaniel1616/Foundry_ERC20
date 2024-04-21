// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../../script/DeployOurToken.s.sol";
import {OurToken} from "../../src/OurToken.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract OurTokenTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);
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

    // openai
    function test_allowanceStartsZero() public view {
        // Initially, allowance from token_Owner to Alice should be zero
        assertEq(ourToken.allowance(token_Owner, Alice), 0);
    }

    function test_approveAndCheckAllowance() public {
        // Approve AMOUNT of tokens from token_Owner to Alice
        vm.prank(token_Owner);
        ourToken.approve(Alice, AMOUNT);

        // Check if allowance was set correctly
        assertEq(ourToken.allowance(token_Owner, Alice), AMOUNT);
    }

    function test_transferFrom() public {
        // Approve AMOUNT of tokens from token_Owner to Alice
        vm.prank(token_Owner);
        ourToken.approve(Alice, AMOUNT);

        // Alice transfers AMOUNT of tokens from token_Owner to Bob
        vm.prank(Alice);
        ourToken.transferFrom(token_Owner, Bob, AMOUNT);

        // Check if the allowance is updated correctly after transferFrom
        assertEq(ourToken.allowance(token_Owner, Alice), 0);
        assertEq(ourToken.balanceOf(Bob), AMOUNT);
    }

    function test_transferFromRevertsWhenNotEnoughAllowance() public {
        // Approve only half of AMOUNT of tokens from token_Owner to Alice
        vm.prank(token_Owner);
        ourToken.approve(Alice, AMOUNT / 2);

        // Expect revert when trying to transferFrom more tokens than allowed
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                Alice,
                AMOUNT / 2,
                AMOUNT
            )
        );
        vm.prank(Alice);
        ourToken.transferFrom(token_Owner, Bob, AMOUNT);
    }
}
