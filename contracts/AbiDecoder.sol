// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

enum DataType {
    primitive,
    bytesLike,
    arrayLike
}

contract AbiDecoder {
    using Strings for string;

    uint256 public constant BYTES_32_SIZE = 0x20;

    function decodeTypes(bytes memory data, string[] calldata types) external pure returns (bytes32[][] memory decoded) {
        decoded = new bytes32[][](types.length);
        uint256 arrayOffset;

        for(uint256 i; i < types.length; i++) {
            if (getType(types[i]) == DataType.primitive) {
                decoded[i] = new bytes32[](1);
                decoded[i][0] = decode32(data, BYTES_32_SIZE * (i + arrayOffset));
            } else if (getType(types[i]) == DataType.arrayLike) {
                (bytes32[] memory decodedArray, uint256 offset) = decodeArrayLike(data, BYTES_32_SIZE * (i + arrayOffset));
                decoded[i] = decodedArray;
                arrayOffset += offset;
            } else {
                (bytes32[] memory decodedArray, uint256 offset) = decodeBytesLike(data, BYTES_32_SIZE * (i + arrayOffset));
                decoded[i] = decodedArray;
                arrayOffset += offset;
            }
        }
    }

    function decode32(bytes memory data, uint256 offset) private pure returns(bytes32 decodedValue) {
        assembly {
            decodedValue:= mload(add(add(data, BYTES_32_SIZE), offset))
        }
    }

    function decodeArrayLike(bytes memory data, uint256 offset) private pure returns(bytes32[] memory decodedArray, uint256 arraySize) {
        uint256 arraySizeOffset = uint256(decode32(data, offset));
        require(arraySizeOffset == BYTES_32_SIZE, "array size fail");

        arraySize = uint256(decode32(data,offset+BYTES_32_SIZE));
        decodedArray = new bytes32[](arraySize);

        for(uint256 i; i < arraySize; i++) {
            decodedArray[i] = decode32(data, offset+(2+i)*BYTES_32_SIZE);
        }
    }

    function decodeBytesLike(bytes memory data, uint256 offset) private pure returns(bytes32[] memory decodedArray, uint256 arraySize) {
        uint256 arraySizeOffset = uint256(decode32(data, offset));
        require(arraySizeOffset == BYTES_32_SIZE, "array size fail");

        arraySize = uint256(decode32(data,offset+BYTES_32_SIZE));
        arraySize = arraySize / BYTES_32_SIZE == 0 ? 1 : arraySize / BYTES_32_SIZE;
        decodedArray = new bytes32[](arraySize);

        for(uint256 i; i < arraySize; i++) {
            decodedArray[i] = decode32(data, offset+(2+i)*BYTES_32_SIZE);
        }
    }

    function getType(string memory type_) private pure returns(DataType) {
        if (type_.equal("uint256") || type_.equal("address") || type_.equal("bytes32") || type_.equal("int256")) {
            return DataType.primitive;
        } else if (type_.equal("bytes") || type_.equal("string")) {
            return DataType.bytesLike;
        } else {
            return DataType.arrayLike;
        }
    }
}
