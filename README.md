## hyperevm-foundry-project

This repository contains mock precompiles and helper contracts for interacting with HyperEVM's L1 read and write functionality in a Foundry test or deployment environment.

### Warning: Highly experimental

This project is still under development and the API is subject to change.
Reliability or functionality of the mock precompiles has not been tested.

### Installation & Usage

```sh
forge install https://github.com/sprites0/hyperevm-foundry-project
```

The mock precompiles can be set up in your tests or scripts by calling `MockL1Precompiles.setup()`:

```solidity
pragma solidity ^0.8.0;

import {MockL1Precompiles} from "hyperevm-foundry-project/src/MockL1Precompiles.sol";
import {L1Read} from "hyperevm-foundry-project/src/L1Read.sol";
import {Test, console} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";

contract MyTest is Test {
    function setUp() public {
        MockL1Precompiles.setup();
    }

    function test_example() public {
        console.log(L1Read.l1BlockNumber()); // returns 100
    }
}

contract Example {
    event BlockNumber(uint64 indexed blockNumber);

    constructor() {
        uint64 blockNumber = L1Read.l1BlockNumber();
        emit BlockNumber(blockNumber);
    }
}

contract MyScript is Script {
    function run() public {
        vm.startBroadcast();
        new Example(); // This transaction will emit the real L1 block number
        vm.stopBroadcast();
    }
}
```

#### Advanced Usage: More realistic L1 precompiles

The `MoreRealisticL1Precompiles` library allows you to use the L1 precompiles in a more realistic way.
It will forward the call to the HyperEVM RPC endpoint, so you need to have it running.

However, the precompiles here cannot guarantee the atomicity of L1 read operations - calling multiple precompiles
will result in multiple RPC calls, which always point to the latest L1 block data.

```solidity
pragma solidity ^0.8.0;

import {MoreRealisticL1Precompiles} from "hyperevm-foundry-project/src/MoreRealisticL1Precompiles.sol";
import {L1Read} from "hyperevm-foundry-project/src/L1Read.sol";
import {Test, console} from "forge-std/Test.sol";

contract MyTest is Test {
    function setUp() public {
        MoreRealisticL1Precompiles.setup();
    }

    function test_example() public {
        console.log(L1Read.l1BlockNumber());
        console.log(L1Read.l1BlockNumber()); // different block number
    }
}
```
