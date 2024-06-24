# setting up a suapp

This will cover the basics of suapp development:

- what you need to install
- how to set up a fresh project
- core features of SUAVE
  - the unique things we can build
- an example suapp

## outline

### system prerequisites

For smart contracts:

- [foundry](https://book.getfoundry.sh/getting-started/installation)

For building web apps:

- [bun](https://bun.sh/docs/installation)

*For windows users:*

- [Windows Subsystem for Linux (wsl)](https://learn.microsoft.com/en-us/windows/wsl/install)

### creating a new project

```sh
mkdir suapp-example && cd suapp-example
forge init
forge install flashbots/suave-std
code .
```

- [ ] make `Counter.sol` into a suapp
- [ ] write a forge test that uses a precompile

### creating a web suapp

```sh
bun create vite ./web
cd ./web
```

- [ ] import `Counter.json` for ABI
- [ ] import common suave-viem stuff; scroll around in intellisense
  - note:
  - Common: `@flashbots/suave-viem`
  - Suave-specific: `@flashbots/suave-viem/chains/utils`
- [ ] send a CCR using metamask
  - [ ] set fresh RPC settings
  - [ ] add fresh funded wallet
  - [ ] enable eth_sign
- [ ] (if time allots) checkout EIP712 CCRs
  - [ ] note: indifferent to RPC settings
  - [ ] disable eth_sign
