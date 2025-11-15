// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token token;

    address public owner = makeAddr("owner");
    address public user = makeAddr("user");
    address public minter = makeAddr("minter");

    function setUp() public {
        vm.prank(owner);
        token = new Token("MyToken", "MTK", minter);
    }

    function testMintByOwner() public {
        uint256 mintAmount = 1000;

        vm.prank(owner);
        token.mint(owner, mintAmount);

        assertEq(token.balanceOf(owner), mintAmount);
    }

    function testMintByUser() public {
        uint256 mintAmount = 1000;

        vm.prank(user);
        vm.expectRevert();
        token.mint(user, mintAmount);
    }

    function testMintByMinter() public {
        uint256 mintAmount = 1000;

        vm.prank(minter);
        token.mintByMinter(user, mintAmount);

        assertEq(token.balanceOf(user), mintAmount);
    }
}
