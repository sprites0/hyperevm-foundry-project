// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./L1Read.sol";
import "./L1Write.sol";
import {Vm} from "forge-std/Vm.sol";

// RPC endpoint for Hyperliquid testnet
string constant HYPERLIQUID_RPC = "https://rpc.hyperliquid-testnet.xyz/evm";

Vm constant vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

contract RpcForwarder {
    fallback() external payable {
        vm.pauseGasMetering();
        bytes memory response = _makeRpcCall(address(this), msg.data);
        vm.resumeGasMetering();
        assembly {
            return(add(response, 32), mload(response))
        }
    }
}

library MoreRealisticL1Precompiles {
    function setup() internal {
        vm.etch(L1Read.POSITION_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.SPOT_BALANCE_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.VAULT_EQUITY_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.WITHDRAWABLE_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.DELEGATIONS_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.DELEGATOR_SUMMARY_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.MARK_PX_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.ORACLE_PX_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.SPOT_PX_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.L1_BLOCK_NUMBER_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.PERP_ASSET_INFO_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.SPOT_INFO_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);
        vm.etch(L1Read.TOKEN_INFO_PRECOMPILE_ADDRESS, type(RpcForwarder).runtimeCode);

        vm.allowCheatcodes(L1Read.POSITION_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.SPOT_BALANCE_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.VAULT_EQUITY_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.WITHDRAWABLE_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.DELEGATIONS_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.DELEGATOR_SUMMARY_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.MARK_PX_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.ORACLE_PX_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.SPOT_PX_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.L1_BLOCK_NUMBER_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.PERP_ASSET_INFO_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.SPOT_INFO_PRECOMPILE_ADDRESS);
        vm.allowCheatcodes(L1Read.TOKEN_INFO_PRECOMPILE_ADDRESS);

        vm.etch(0x3333333333333333333333333333333333333333, type(L1Write).runtimeCode);
    }
}

// Helper function to make RPC calls
function _makeRpcCall(address target, bytes memory params) returns (bytes memory) {
    Vm vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));
    
    // Construct the JSON-RPC payload
    string memory jsonPayload = string.concat(
        '[{"to":"',
        vm.toString(target),
        '","data":"',
        vm.toString(params),
        '"},"latest"]'
    );

    // Make the RPC call
    return vm.rpc("eth_call", jsonPayload);
}
