// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OwnableVault} from "./OwnableVault.sol";

/// @title VaultFactory
/// @notice Deploys {OwnableVault} instances on demand and keeps an on-chain
///         registry of every vault it has created.
/// @dev Demonstrates the factory pattern: contract-to-contract creation with
///      the `new` keyword, plus reading state from a child contract through
///      the factory ({getVaultBalance}).
contract VaultFactory {
    /// @notice All vaults deployed by this factory, in creation order.
    OwnableVault[] public vaults;

    /// @notice Emitted when a new vault is deployed.
    /// @param vault The address of the newly deployed vault.
    /// @param owner The account that owns the new vault (the caller).
    /// @param name  The human readable name given to the vault.
    event VaultCreated(address indexed vault, address indexed owner, string name);

    /// @notice Deploy a new {OwnableVault} owned by the caller.
    /// @param _name A human readable name for the vault.
    /// @return vault The address of the newly deployed vault.
    function createVault(string calldata _name) external returns (address vault) {
        OwnableVault newVault = new OwnableVault(msg.sender, _name);
        vaults.push(newVault);
        vault = address(newVault);
        emit VaultCreated(vault, msg.sender, _name);
    }

    /// @notice Number of vaults deployed by this factory.
    function getVaultCount() external view returns (uint256) {
        return vaults.length;
    }

    /// @notice Read a deployed vault's balance through the factory.
    /// @param _index The index of the vault in the registry.
    /// @return The tracked balance of the vault at `_index`.
    function getVaultBalance(uint256 _index) external view returns (uint256) {
        return vaults[_index].balance();
    }

    /// @notice Address of a deployed vault by index.
    /// @param _index The index of the vault in the registry.
    function getVault(uint256 _index) external view returns (address) {
        return address(vaults[_index]);
    }
}
