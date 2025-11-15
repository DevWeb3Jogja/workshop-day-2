// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

import {VaultStorage} from "./library/VaultStorage.sol";

contract Vault is VaultStorage, OwnableUpgradeable, UUPSUpgradeable {
    IERC20 public token;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    error UnsupportedToken();
    error AmountMustBeGreaterThanZero();

    constructor() {
        _disableInitializers();
    }

    function initialize(address tokenAddress) external initializer {
        __Ownable_init(msg.sender);
        token = IERC20(tokenAddress);
    }

    function deposit(address tokenIn, uint256 amountIn) external {
        if (tokenIn != address(token)) revert UnsupportedToken();
        if (amountIn == 0) revert AmountMustBeGreaterThanZero();

        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);

        // Write data into storage
        VaultStorage.MainStorage storage $ = VaultStorage._getMainStorage();
        $.balances[msg.sender] += amountIn;

        emit Deposit(msg.sender, amountIn);
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert AmountMustBeGreaterThanZero();
        VaultStorage.MainStorage storage $ = VaultStorage._getMainStorage();
        if ($.balances[msg.sender] < amount) revert AmountMustBeGreaterThanZero();

        $.balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }

    function balanceOf(address user) external view returns (uint256) {
        VaultStorage.MainStorage storage $ = VaultStorage._getMainStorage();
        return $.balances[user];
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
