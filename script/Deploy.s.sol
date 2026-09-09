// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {VaultFactory} from "../src/VaultFactory.sol";

/// @notice Deploys the VaultFactory. Run with:
///   forge script script/Deploy.s.sol:DeployScript \
///     --rpc-url $SEPOLIA_RPC_URL --broadcast --verify
contract DeployScript is Script {
    function run() external returns (VaultFactory factory) {
        vm.startBroadcast();
        factory = new VaultFactory();
        console2.log("VaultFactory deployed at:", address(factory));
        vm.stopBroadcast();
    }
}
