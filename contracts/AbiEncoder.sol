// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract AbiEncoder {
    function encodeUint(uint256 a) external pure returns (bytes memory) {
        return abi.encode(a);
    }

    function encodeUintArray(uint256[] calldata a) external pure returns (bytes memory) {
        return abi.encode(a);
    }

    function encodeBytes(bytes calldata b) external pure returns (bytes memory) {
        return abi.encode(b);
    }
}
