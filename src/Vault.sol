// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Vault
/// @notice Minimal base vault that tracks an internal balance.
/// @dev Kept intentionally simple so it can be extended (see {OwnableVault}).
///      `deposit` and `balance` are `virtual` so derived contracts can
///      layer additional behaviour (e.g. access control) on top.
contract Vault {
    /// @dev Running balance credited to this vault.
    uint256 internal _balance;

    /// @notice Emitted whenever the vault balance is increased.
    event Deposit(address indexed from, uint256 amount);

    /// @notice Credit `_amount` to the vault balance.
    /// @param _amount The amount to add to the vault's tracked balance.
    function deposit(uint256 _amount) public virtual {
        _balance += _amount;
        emit Deposit(msg.sender, _amount);
    }

    /// @notice Read the current vault balance.
    /// @return The vault's tracked balance.
    function balance() public view virtual returns (uint256) {
        return _balance;
    }
}
