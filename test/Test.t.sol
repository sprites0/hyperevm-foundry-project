// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/MockL1Precompiles.sol";
import "../src/examples/PrecompileUser.sol";

contract CounterTest is Test {
    function setUp() public {
        MockL1Precompiles.setup();
    }

    function testDeploy() public {
        new PrecompileUser();
        console.log("user deployed");
    }
}
