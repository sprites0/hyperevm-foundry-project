// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./L1Read.sol";
import "./L1Write.sol";
import {Vm} from "forge-std/Vm.sol";

// This is just a mock value, it's different from the testnet and mainnet
uint64 constant BTC_MOCK_TOKEN_ID = 100;
address constant BTC_MOCK_DEPLOYER = address(0x1234567890123456789012345678901234567890);
// This is the same value as the testnet and mainnet
uint64 constant USDC_TOKEN_ID = 0;

// Mock spot id of BTC-USDC pair
uint64 constant BTC_USDC_SPOT_ID = 1000;

contract MockPositionPrecompile {
    fallback() external payable {
        // (address _user, uint16 _perp) = abi.decode(msg.data, (address, uint16));
        bytes memory result =
            abi.encode(L1Read.Position({szi: 100, entryNtl: 100, isolatedRawUsd: 100, leverage: 100, isIsolated: true}));
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockSpotBalancePrecompile {
    fallback() external payable {
        // (address _user, uint64 _token) = abi.decode(msg.data, (address, uint64));
        bytes memory result = abi.encode(L1Read.SpotBalance({total: 100, hold: 100, entryNtl: 100}));
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockUserVaultEquityPrecompile {
    fallback() external payable {
        // (address _user, address _vault) = abi.decode(msg.data, (address, address));
        bytes memory result = abi.encode(L1Read.UserVaultEquity({equity: 100, lockedUntilTimestamp: 100}));
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockWithdrawablePrecompile {
    fallback() external payable {
        // (address _user) = abi.decode(msg.data, (address));
        bytes memory result = abi.encode(L1Read.Withdrawable({withdrawable: 100}));
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockDelegationsPrecompile {
    fallback() external payable {
        // (address _user) = abi.decode(msg.data, (address));
        L1Read.Delegation[] memory delegations = new L1Read.Delegation[](0);
        bytes memory result = abi.encode(delegations);
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockDelegatorSummaryPrecompile {
    fallback() external payable {
        // (address _user) = abi.decode(msg.data, (address));
        bytes memory result = abi.encode(
            L1Read.DelegatorSummary({
                delegated: 100,
                undelegated: 100,
                totalPendingWithdrawal: 100,
                nPendingWithdrawals: 100
            })
        );
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockL1BlockNumberPrecompile {
    fallback() external payable {
        bytes memory result = abi.encode(100);
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockPerpAssetInfoPrecompile {
    fallback() external payable {
        // (uint32 _perp) = abi.decode(msg.data, (uint32));
        bytes memory result = abi.encode(
            L1Read.PerpAssetInfo({
                coin: "BTC",
                marginTableId: 100,
                szDecimals: 100,
                maxLeverage: 100,
                onlyIsolated: true
            })
        );
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockSpotInfoPrecompile {
    fallback() external payable {
        // (uint32 _spot) = abi.decode(msg.data, (uint32));
        bytes memory result = abi.encode(L1Read.SpotInfo({name: "BTC", tokens: [BTC_MOCK_TOKEN_ID, USDC_TOKEN_ID]}));
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockTokenInfoPrecompile {
    fallback() external payable {
        // (uint32 _token) = abi.decode(msg.data, (uint32));
        uint64[] memory spots = new uint64[](1);
        spots[0] = BTC_USDC_SPOT_ID;
        bytes memory result = abi.encode(
            L1Read.TokenInfo({
                name: "BTC",
                spots: spots,
                deployerTradingFeeShare: 100,
                deployer: BTC_MOCK_DEPLOYER,
                evmContract: BTC_MOCK_DEPLOYER,
                szDecimals: 6,
                weiDecimals: 12,
                evmExtraWeiDecimals: 2
            })
        );
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockMarkPxPrecompile {
    fallback() external payable {
        // (uint32 _index) = abi.decode(msg.data, (uint32));
        bytes memory result = abi.encode(100);
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockOraclePxPrecompile {
    fallback() external payable {
        // (uint32 _index) = abi.decode(msg.data, (uint32));
        bytes memory result = abi.encode(100);
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

contract MockSpotPxPrecompile {
    fallback() external payable {
        // (uint32 _index) = abi.decode(msg.data, (uint32));
        bytes memory result = abi.encode(100);
        assembly {
            return(add(result, 32), mload(result))
        }
    }
}

library MockL1Precompiles {
    Vm constant vm = Vm(address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D));

    function setup() internal {
        vm.etch(L1Read.POSITION_PRECOMPILE_ADDRESS, type(MockPositionPrecompile).runtimeCode);
        vm.etch(L1Read.SPOT_BALANCE_PRECOMPILE_ADDRESS, type(MockSpotBalancePrecompile).runtimeCode);
        vm.etch(L1Read.VAULT_EQUITY_PRECOMPILE_ADDRESS, type(MockUserVaultEquityPrecompile).runtimeCode);
        vm.etch(L1Read.WITHDRAWABLE_PRECOMPILE_ADDRESS, type(MockWithdrawablePrecompile).runtimeCode);
        vm.etch(L1Read.DELEGATIONS_PRECOMPILE_ADDRESS, type(MockDelegationsPrecompile).runtimeCode);
        vm.etch(L1Read.DELEGATOR_SUMMARY_PRECOMPILE_ADDRESS, type(MockDelegatorSummaryPrecompile).runtimeCode);
        vm.etch(L1Read.MARK_PX_PRECOMPILE_ADDRESS, type(MockMarkPxPrecompile).runtimeCode);
        vm.etch(L1Read.ORACLE_PX_PRECOMPILE_ADDRESS, type(MockOraclePxPrecompile).runtimeCode);
        vm.etch(L1Read.SPOT_PX_PRECOMPILE_ADDRESS, type(MockSpotPxPrecompile).runtimeCode);
        vm.etch(L1Read.L1_BLOCK_NUMBER_PRECOMPILE_ADDRESS, type(MockL1BlockNumberPrecompile).runtimeCode);
        vm.etch(L1Read.PERP_ASSET_INFO_PRECOMPILE_ADDRESS, type(MockPerpAssetInfoPrecompile).runtimeCode);
        vm.etch(L1Read.SPOT_INFO_PRECOMPILE_ADDRESS, type(MockSpotInfoPrecompile).runtimeCode);
        vm.etch(L1Read.TOKEN_INFO_PRECOMPILE_ADDRESS, type(MockTokenInfoPrecompile).runtimeCode);

        vm.etch(0x3333333333333333333333333333333333333333, type(L1Write).runtimeCode);
    }
}
