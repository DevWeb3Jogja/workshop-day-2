// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

abstract contract VaultStorage {
    /// @custom:storage-location erc7201:example.main
    struct MainStorage {
        mapping(address => uint256) balances;
    }

    // keccak256(abi.encode(uint256(keccak256("vault.example.main")) - 1)) & ~bytes32(uint256(0xff));
    bytes32 private constant MAIN_STORAGE_LOCATION = 0x183a6125c38840424c4a85fa12bab2ab606c4b6d0e7cc73c0c06ba5300eab500;

    function _getMainStorage() internal pure returns (MainStorage storage $) {
        assembly {
            $.slot := MAIN_STORAGE_LOCATION
        }
    }
}
