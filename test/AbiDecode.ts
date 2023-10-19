import { ethers } from "hardhat";
import { expect } from "chai";
import { Reverter } from "@/test/helpers/reverter";
import { wei } from "@/scripts/utils/utils";
import { AbiDecoder, AbiEncoder, TypeConverter } from "@ethers-v6";

describe("AbiDecoder", () => {
  let decoder: AbiDecoder;
  let encoder: AbiEncoder;
  let converter: TypeConverter;

  before(async () => {
    const Decoder = await ethers.getContractFactory("AbiDecoder");
    decoder = await Decoder.deploy();

    const Encoder = await ethers.getContractFactory("AbiEncoder");
    encoder = await Encoder.deploy();

    const Converter = await ethers.getContractFactory("TypeConverter");
    converter = await Converter.deploy();
  });

  describe("#decodeTypes", () => {
    it("should decode uint", async () => {
      let uint = 51;
      let encoded = await encoder.encodeUint(uint);
      let decoded = await decoder.decodeTypes(encoded,["uint256"]);

      expect(await converter.toUint(decoded[0][0])).to.eq(uint);
    });

    it('should decode uint array', async () => {
      let uintArray = [51,88,302];
      let encoded = await encoder.encodeUintArray(uintArray);
      let decoded = await decoder.decodeTypes(encoded,["uint256[]"]);
      let clonedArray  = Object.assign([], decoded[0]);

      expect((await converter.toUintArray(clonedArray)).toString()).to.eq(uintArray.toString());
    });

    it('should decode bytes', async () => {
      let bytes = "0x50000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000";
      let encoded = await encoder.encodeBytes(bytes);
      let decoded = await decoder.decodeTypes(encoded, ["bytes"]);
      let clonedArray = Object.assign([], decoded[0]);

      expect(await converter.toBytes(clonedArray)).to.eq(bytes);
    });
  });
});
