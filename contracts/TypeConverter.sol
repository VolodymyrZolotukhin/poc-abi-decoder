// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TypeConverter {
    function toUint(bytes32 data) external pure returns (uint256) {
        return uint256(data);
    }

    function toUintArray(bytes32[] memory data) external pure returns (uint256[] memory array) {
        array = new uint256[](data.length);
        for(uint256 i; i < array.length; i++) {
            array[i] = uint256(data[i]);
        }
    }

    function toBytes(bytes32[] memory data) external pure returns (bytes memory bytes_) {
        for(uint256 i; i < data.length; i++) {
            bytes_ = bytes.concat(bytes_, data[i]);
        }
    }
}
