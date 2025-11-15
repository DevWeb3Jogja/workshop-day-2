// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {Vault} from "../src/Vault.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployVault is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Vault implementation
        ERC20Mock token = new ERC20Mock();
        console.log("ERC20Mock deployed at:", address(token));

        Vault vaultImpl = new Vault();
        console.log("Vault Implementation deployed at:", address(vaultImpl));

        // Deploy proxy pointing to the Vault implementation
        ERC1967Proxy proxy =
            new ERC1967Proxy(address(vaultImpl), abi.encodeWithSelector(Vault.initialize.selector, address(token)));
        console.log("Vault Proxy deployed at:", address(proxy));

        vm.stopBroadcast();
    }
}
