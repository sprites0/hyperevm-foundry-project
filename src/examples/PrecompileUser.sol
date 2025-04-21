// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import "../L1Read.sol";

contract PrecompileUser {
    constructor() {
        uint64 blockNumber = L1Read.l1BlockNumber();
        console.log("blockNumber", blockNumber);
    }

    function getBlockNumber() public view returns (uint64) {
        return L1Read.l1BlockNumber();
    }
}
