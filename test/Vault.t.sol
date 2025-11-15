// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract VaultTest is Test {
    Vault public vault;
    ERC20Mock public token;
    address public owner = address(0x1);
    address public user = address(0x2);

    function setUp() public {
        // Deploy mock ERC20 token
        token = new ERC20Mock();

        // Deploy Vault implementation
        Vault vaultImpl = new Vault();
        console.log("Vault Implementation deployed at:", address(vaultImpl));

        // Deploy proxy pointing to the Vault implementation
        ERC1967Proxy proxy =
            new ERC1967Proxy(address(vaultImpl), abi.encodeWithSelector(Vault.initialize.selector, address(token)));
        console.log("Vault Proxy deployed at:", address(proxy));

        vault = Vault(address(proxy));

        // Transfer some tokens to user for testing
        token.mint(user, 10_000 ether);
    }

    function testDepositAndWithdraw() public {
        vm.startPrank(user);

        // Approve vault to spend user's tokens
        token.approve(address(vault), 5_000 ether);

        // Deposit tokens into the vault
        vault.deposit(address(token), 5_000 ether);
        assertEq(vault.balanceOf(user), 5_000 ether);
        assertEq(token.balanceOf(address(vault)), 5_000 ether);

        // Withdraw tokens from the vault
        vault.withdraw(2_000 ether);
        assertEq(vault.balanceOf(user), 3_000 ether);
        assertEq(token.balanceOf(address(vault)), 3_000 ether);
        assertEq(token.balanceOf(user), 7_000 ether);

        vm.stopPrank();
    }

    // function test_DepositByOwner() public {
    //     vm.startPrank(owner);

    //     // Approve vault to spend owner's tokens
    //     token.mint(owner, 10_000 ether);
    //     token.approve(address(vault), 5_000 ether);

    //     // Deposit tokens into the vault for user
    //     vault.depositByOwner(user, 5_000 ether);
    //     assertEq(vault.balanceOf(user), 5_000 ether);
    //     assertEq(token.balanceOf(address(vault)), 5_000 ether);

    //     vm.stopPrank();
    // }
}
