const { expect } = require("chai");
const hre = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("PrecompileUser contract", function () {
    async function PrecompileUserFixture() {
        const precompileUser = await ethers.deployContract("PrecompileUser");
        return { precompileUser };
    }

    it("Should get the block number correctly", async function () {
        const { precompileUser } = await loadFixture(PrecompileUserFixture);
        expect(await precompileUser.getBlockNumber()).to.equal(100);
    });
});
