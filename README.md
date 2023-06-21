# Prerequisites

Installed `Foundry` framework. See [this](https://github.com/foundry-rs/foundry)

# Test cases

Main focus of benchmark is to show the performance of single token operation, as well as the batch operations.
Regarding the batch operations, the focus is on the variations:

- Sequential token identifiers (0, 1, 2, 3, ...)
- Non-sequential token identifiers (0, 2, 4, 6, ...)

The main idea behind this is to show how standards and their optimized versions perform in different scenarios.

When batch operations are used, the `batchSize` is used to determine the number of tokens that will be minted/burned/transferred.

By default, `batchSize` is set to `100`. This value can be changed in `test/Benchmark.t.sol` file.

# Running benchmark

Benchmarking is done by running a test suite. The test can be found at the following path `test/Benchmark.t.sol`.

In order to run a benchmark, run the following command in terminal:

```bash
forge test --match-path ./test/Benchmark.t.sol --gas-report -vv
```

`--match-path` will make sure only `Benchmark` test will be executed

`--gas-report` will generate a gas report for each contract and function

`-vv` will make sure the output of the execution will include logs containing SSTORE/SLOAD reports

The output of the execution is the following:
- Gas report per contract and per function. Single and batch functions are separated for a clearer results and distinction
- The numbers of SSTORE and SLOAD operations per contract and per function

## Benchmarking results

The output of the Benchmark should mostly be taken as is for the most of the report.
The only thing that should be taken into consideration is that `batchMint` will be executed
with `batchSize` and with `batchSize * 2` in case when non-sequential transfer/burn is tested.
For this reason, minimal gas consumtion (when `batchSize` tokens are minted)
will be ~2x less then maximal gas consumption (when `batchSize * 2` tokens are minted).
In this case, proper value that should be used is the minimal one, as it works with `batchSize` 
amount of tokens.

The pretier version of the report can be found in [report.md](./report.md) file.