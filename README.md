# Solidity Vault Factory

A minimal, well-documented Solidity project demonstrating the **factory pattern**, **contract inheritance**, and **contract-to-contract creation** on Ethereum. A `VaultFactory` deploys owned vault contracts on demand, keeps an on-chain registry of every vault it creates, and can read each vault's state back through the factory.

Built with Solidity `^0.8.20` and Foundry.

## Live deployment (Sepolia)

A deployed, **source-verified** `OwnableVault` instance:

- **Contract:** [`0xbcba0a8ffe6719f3e23d28886ef863ee78eab797`](https://sepolia.etherscan.io/address/0xbcba0a8ffe6719f3e23d28886ef863ee78eab797#code)
- **Network:** Ethereum Sepolia testnet
- **Compiler:** `v0.8.34`
- **Status:** Verified — source and ABI are inspectable directly on Etherscan.

> Deploy your own `VaultFactory` with the included Foundry script, then add its address here.

## Architecture

```
Vault                     base contract — tracks a balance, virtual deposit()
  └── OwnableVault        adds single-owner access control + a vault name
        ▲
        │  new OwnableVault(msg.sender, name)
        │
VaultFactory              deploys vaults, registers them, reads their state
```

| Contract | Responsibility |
| --- | --- |
| `Vault` | Base vault. Tracks an internal balance with `virtual` `deposit()` / `balance()` so it can be extended. |
| `OwnableVault` | Extends `Vault`. Assigns an owner and a name at construction and restricts `deposit()` to the owner. |
| `VaultFactory` | Deploys `OwnableVault` instances with the `new` keyword, stores each in an on-chain registry, and exposes `getVaultBalance()` to read a child vault's state through the factory. |

## What it demonstrates

- Contract inheritance and `virtual` / `override` functions
- The factory design pattern (contract-to-contract creation via `new`)
- Constructor-based ownership assignment (`msg.sender` flows from the factory caller to the vault owner)
- On-chain state management and reading child-contract state through a parent
- Custom errors and access-control modifiers
- Source verification on Etherscan

## Contracts

```
src/
├── Vault.sol           # Base vault
├── OwnableVault.sol    # Ownable vault with a name
└── VaultFactory.sol    # Factory + registry
```

### Key interface

```solidity
// VaultFactory
function createVault(string calldata _name) external returns (address vault);
function getVaultCount() external view returns (uint256);
function getVault(uint256 _index) external view returns (address);
function getVaultBalance(uint256 _index) external view returns (uint256);

// OwnableVault
function owner() external view returns (address);
function name() external view returns (string memory);
function deposit(uint256 _amount) external;   // onlyOwner
function balance() external view returns (uint256);
```

## Getting started

Requires [Foundry](https://book.getfoundry.sh/getting-started/installation).

```bash
# Clone
git clone https://github.com/salehe007-stack/solidity-vault-factory.git
cd solidity-vault-factory

# Install forge-std (test/script dependency)
forge install foundry-rs/forge-std

# Build
forge build

# Test
forge test -vvv
```

### Deploy to Sepolia

```bash
cp .env.example .env        # fill in RPC URL, private key, Etherscan key
source .env

forge script script/Deploy.s.sol:DeployScript \
  --rpc-url "$SEPOLIA_RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  --broadcast --verify
```

## Testing

The suite in `test/VaultFactory.t.sol` covers vault creation, owner assignment, multi-vault tracking, deposits read back through the factory, and access-control reverts.

```bash
forge test
```

## Tech

Solidity · Ethereum · Smart Contracts · Contract Inheritance · Factory Pattern · Foundry · EVM

## License

[MIT](./LICENSE)
