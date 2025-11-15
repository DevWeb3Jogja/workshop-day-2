// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {DeployVault} from "../script/DeployVault.s.sol";

contract DeployVaultTest is Test {
    DeployVault vault;

    function setUp() public {
        vault = new DeployVault();
    }

    function testDeployVault() public {
        vault.run();
    }
}
