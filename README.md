# HyperEVM Foundry Project

A collection of mock precompiles and helper contracts for testing and deploying HyperEVM's L1 read/write functionality in Foundry.

> ⚠️ **Experimental**: This project is under active development. The API may change, and the mock precompiles' reliability hasn't been fully tested.

## Installation

```sh
forge install https://github.com/sprites0/hyperevm-project-template
```

## Basic Usage

### In Tests

```solidity
pragma solidity ^0.8.0;

import {MockL1Precompiles} from "hyperevm-project-template/src/MockL1Precompiles.sol";
import {L1Read} from "hyperevm-project-template/src/L1Read.sol";
import {Test, console} from "forge-std/Test.sol";

contract MyTest is Test {
    function setUp() public {
        MockL1Precompiles.setup();
    }

    function test_example() public {
        console.log(L1Read.l1BlockNumber()); // Returns 100
    }
}
```

### In Scripts

```solidity
pragma solidity ^0.8.0;

import {MockL1Precompiles} from "hyperevm-project-template/src/MockL1Precompiles.sol";
import {L1Read} from "hyperevm-project-template/src/L1Read.sol";
import {Script} from "forge-std/Script.sol";

contract Example {
    event BlockNumber(uint64 indexed blockNumber);

    constructor() {
        uint64 blockNumber = L1Read.l1BlockNumber();
        emit BlockNumber(blockNumber);
    }
}

contract MyScript is Script {
    function setUp() public {
        MockL1Precompiles.setup();
    }

    function run() public {
        vm.startBroadcast();
        new Example(); // Emits the real L1 block number
        vm.stopBroadcast();
    }
}
```

## Advanced Usage: Real L1 Precompiles

The `MoreRealisticL1Precompiles` library connects to a running HyperEVM RPC endpoint for actual L1 data. Note that:

- Each precompile call triggers an RPC call
- Multiple L1 read operations aren't atomic (they'll reflect the latest L1 block)
- Performance is slower due to RPC overhead

```solidity
pragma solidity ^0.8.0;

import {MoreRealisticL1Precompiles} from "hyperevm-project-template/src/MoreRealisticL1Precompiles.sol";
import {L1Read} from "hyperevm-project-template/src/L1Read.sol";
import {Test, console} from "forge-std/Test.sol";

contract MyTest is Test {
    function setUp() public {
        MoreRealisticL1Precompiles.setup();
    }

    function test_example() public {
        console.log(L1Read.l1BlockNumber());
        console.log(L1Read.l1BlockNumber()); // May show different block numbers
    }
}
```
