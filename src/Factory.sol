// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Token} from "./Token.sol";

contract Factory {
    event TokenCreated(address tokenAddress);

    function createToken(string memory name, string memory symbol) external returns (address) {
        Token token = new Token(name, symbol, msg.sender);
        emit TokenCreated(address(token));
        return address(token);
    }
}
