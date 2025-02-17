# Foundry Fund Me

This is a simple project to help users to create a campaign to raise funds for their projects.

- [Foundry Fund Me](#foundry-fund-me)
- [Getting Started](#getting-started)

# Getting Started

## Requirements
- [git](https://git-scm.com/doc)
- [node](https://nodejs.org/en/download/)
- [foundry](https://book.getfoundry.sh/getting-started/installation)

## Quick Start

```bash
git clone https://github.com/SudeepMalipeddi/foundry-fund-me
cd foundry-fund-me
```

# Usage

## Deploy

```bash
forge script script/DeployFundMe.s.sol
```

## Testing

```bash
forge test
```

or

```bash
// Only run test functions matching the specified regex pattern.

forge test --match-test testFunctionName
```

or

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

To generate test coverage report, run the following command:

```bash
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). **NOTE:** FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
  - You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

2. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your metamask.

3. Deploy

```bash
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Scripts

After deploying to a testnet or local net, you can run the scripts.

Using cast deployed locally example:

```bash
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```

or

```bash
forge script script/Interactions.s.sol:FundFundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
```

### Withdraw

```bash
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>
```

## Estimate gas

You can estimate how much gas things cost by running:

```bash
forge snapshot
```

And you'll see an output file called `.gas-snapshot`

# Formatting

To run code formatting:

```bash
forge fmt
```
