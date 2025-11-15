// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {UpgradeVault} from "../script/UpgradeVault.s.sol";

contract UpgradeVaultTest is Test {
    UpgradeVault upgradeVault;

    function setUp() public {
        upgradeVault = new UpgradeVault();
    }

    function testUpgradeVault() public {
        upgradeVault.run();
    }
}
