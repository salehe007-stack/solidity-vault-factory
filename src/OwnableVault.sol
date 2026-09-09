// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vault} from "./Vault.sol";

/// @title OwnableVault
/// @notice A {Vault} that adds single-owner access control and a human
///         readable name. Only the owner may deposit into the vault.
/// @dev Ownership is assigned at construction. When created through
///      {VaultFactory}, the factory passes the calling account as `_owner`,
///      so the deployer of the vault becomes its owner.
contract OwnableVault is Vault {
    /// @notice The account allowed to deposit into this vault.
    address public owner;

    /// @notice A human readable label for this vault.
    string public name;

    /// @dev Thrown when a non-owner attempts an owner-only action.
    error NotOwner();

    /// @param _owner The account that will own the vault.
    /// @param _name  A human readable name for the vault.
    constructor(address _owner, string memory _name) {
        owner = _owner;
        name = _name;
    }

    /// @dev Restricts a function to the vault owner.
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    /// @notice Deposit into the vault. Restricted to the owner.
    /// @param _amount The amount to credit to the vault balance.
    function deposit(uint256 _amount) public override onlyOwner {
        super.deposit(_amount);
    }
}
