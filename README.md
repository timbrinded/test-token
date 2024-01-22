# StablePound token

![alt text](./symbol.png)

This repo is a proof of concept for a stable token using standard OZ libraries.

## Deployed Example

- **Proxy Contract**: Stores all the balances and data for the token  [0xd3003Ed9E97e8808BEF9dE8b3a381383B2Ef17f9](https://sepolia.etherscan.io/address/0xd3003Ed9E97e8808BEF9dE8b3a381383B2Ef17f9#code)
- **Implementation Contract**: Location where all the logic sits. Can be replaced/upgraded with new contracts [0x6cd1ebFBC1dBc24A68736F7439dd46AdE5662E44](https://sepolia.etherscan.io/address/0x6cd1ebFBC1dBc24A68736F7439dd46AdE5662E44#code)


---

## Building

> [!IMPORTANT]  
> This repo uses the **Foundry** stack, for installation instructions first run [this](https://book.getfoundry.sh/getting-started/installation#using-foundryup).

To build this project, simply run:

```sh
forge compile
```

## Testing

To run all the tests associated with this project, run:

```sh
forge test
```

## Deploying

### Setup

To deploy this script to testnet, a few environment variables need to be setup.

Run the following to create an environment variables file:

```sh
cp .env.example .env
```

Populate with:

- `FOUNDRY_ETH_RPC_URL`: RPC for network, e.g. "https://mainnet.infura.io/v3/...". You can get a key from [infura.io](https://www.infura.io/) for example
- `FOUNDRY_PRIVATE_KEY`: Private key which to send the deploy transactions with. Be sure to remove the `0x` from the beginning.
- `ETHERSCAN_API_KEY`: Create an account at etherscan.io and create a [API key token](https://etherscan.io/myapikey)

### Run Script

```sh
source .env
forge script script/token.s.sol:TokenScript --broadcast --verify --rpc-url $FOUNDRY_ETH_RPC_URL --private-key $FOUNDRY_PRIVATE_KEY
```

## Proxy Registration

When deploying, the contracts will be automatically verified. However they must be manually registered as a Proxy contract, so that the function interfaces are correctly shown on page. Use the `proxyContractChecker` (e.g. for [sepolia](https://sepolia.etherscan.io/proxyContractChecker)) to mark this contract as inherenting functions from another source.
