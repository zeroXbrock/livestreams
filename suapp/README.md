# stream2

deploy smart contract

```sh
./deployContracts.sh
```

test it with `suave spell`

```sh
CONTRACT_ADDR=$(cat contract-deployment.json | jq -r .deployedTo)
suave spell conf-request --confidential-input $(cast to-uint256 42) $CONTRACT_ADDR "setNumber()"
```

run forge tests

```sh
# suavex-anvil required
forge test --ffi -vvv
