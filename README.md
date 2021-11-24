# StarkNet Playground

My lil' playground. Feeling cute, might port some of my Solidity contracts here, idk.

## Getting started

Clone this project:
```sh
git clone https://github.com/exp-table/starknet-playground.git
cd starknet-playground
```

Create a [virtualenv](https://docs.python.org/3/library/venv.html) and activate it:

```sh
python3 -m venv env
source env/bin/activate
```

Install `nile`:

```sh
pip install cairo-nile
```

Use `nile` to quickly set up your development environment:

```sh
nile init
...
✨  Cairo successfully installed!
...
✅ Dependencies successfully installed
🗄  Creating project directory tree
⛵️ Nile project ready! Try running:
```
This command creates the project directory structure and installs `cairo-lang`, `starknet-devnet`, `pytest`, and `pytest-asyncio` for you. The template includes a makefile to build the project (`make build`) and run tests (`make test`).

## A few notes regarding the contracts
### cmp.cairo
Holds basic comparison operators not present in the modules starkware offers.

### DutchAuction.cairo
For the moment, any logic regarding the handling of the currency used for paying is not implemented. For simplicity and elegance, we will probably let the user handles it on the contract interacting with the DutchAuction.
⚠️ Waiting for native support of `timestamp `.