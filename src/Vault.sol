// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract Vault is OwnableUpgradeable, UUPSUpgradeable {
    IERC20 public token;
    mapping(address => uint256) public balances;

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
        balances[msg.sender] += amountIn;

        emit Deposit(msg.sender, amountIn);
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert AmountMustBeGreaterThanZero();
        if (balances[msg.sender] < amount) revert AmountMustBeGreaterThanZero();

        balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }

    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
