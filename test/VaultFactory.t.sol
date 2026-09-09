// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {VaultFactory} from "../src/VaultFactory.sol";
import {OwnableVault} from "../src/OwnableVault.sol";

contract VaultFactoryTest is Test {
    VaultFactory internal factory;
    address internal alice = address(0xA11CE);
    address internal bob = address(0xB0B);

    function setUp() public {
        factory = new VaultFactory();
    }

    function test_CreateVault_AssignsCallerAsOwner() public {
        vm.prank(alice);
        address vaultAddr = factory.createVault("Alice Vault");

        OwnableVault vault = OwnableVault(vaultAddr);
        assertEq(vault.owner(), alice);
        assertEq(vault.name(), "Alice Vault");
        assertEq(factory.getVaultCount(), 1);
    }

    function test_Factory_TracksMultipleVaults() public {
        vm.prank(alice);
        factory.createVault("Alice Vault");
        vm.prank(bob);
        factory.createVault("Bob Vault");

        assertEq(factory.getVaultCount(), 2);
        assertEq(OwnableVault(factory.getVault(0)).owner(), alice);
        assertEq(OwnableVault(factory.getVault(1)).owner(), bob);
    }

    function test_Deposit_UpdatesBalanceReadableThroughFactory() public {
        vm.prank(alice);
        address vaultAddr = factory.createVault("Alice Vault");

        vm.prank(alice);
        OwnableVault(vaultAddr).deposit(100);

        assertEq(factory.getVaultBalance(0), 100);
    }

    function test_Deposit_RevertsForNonOwner() public {
        vm.prank(alice);
        address vaultAddr = factory.createVault("Alice Vault");

        vm.prank(bob);
        vm.expectRevert(OwnableVault.NotOwner.selector);
        OwnableVault(vaultAddr).deposit(100);
    }
}
