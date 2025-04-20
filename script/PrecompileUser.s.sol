// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PrecompileUser} from "../src/examples/PrecompileUser.sol";
import {MockL1Precompiles} from "../src/MockL1Precompiles.sol";

contract PrecompileUserScript is Script {
    PrecompileUser public user;

    function setUp() public {
        MockL1Precompiles.setup();
    }

    function run() public {
        vm.startBroadcast();

        user = new PrecompileUser();

        vm.stopBroadcast();
    }
}
