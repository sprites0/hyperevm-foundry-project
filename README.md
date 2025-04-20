## hyperevm-foundry-project

This repository contains mock precompiles and helper contracts for interacting with HyperEVM's L1 read and write functionality in a Foundry test or deployment environment.

### Usage

The mock precompiles can be set up in your tests or scripts by calling:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {MockL1Precompiles} from "./MockL1Precompiles.sol";
import {Script} from "forge-std/Script.sol";

contract MyScript is Script {
    function setUp() public {
        MockL1Precompiles.setup();
    }

    function run() public {
        vm.startBroadcast();
        ...
        vm.stopBroadcast();
    }
}
```
