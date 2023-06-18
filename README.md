# Prerequisites

Installed `Foundry` framework. See [this](https://github.com/foundry-rs/foundry)

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