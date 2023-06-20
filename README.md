# Prerequisites

Installed `Foundry` framework. See [this](https://github.com/foundry-rs/foundry)

# Running benchmark

Benchmarking is done by running a test suite. The test can be found at the following path `test/Benchmark.t.sol`.

In order to retrieve gas report, run the following command in terminal:

```bash
forge test --match-path ./test/GasReport.t.sol --gas-report
```

In order to retrieve read/write report, run the following command:

```bash
forge test --match-path ./test/ReadWriteReport.t.sol -vv
```

The output of the execution is the following:
- Gas report per contract and per function. Single and batch functions are separated for a clearer results and distinction
- The numbers of SSTORE and SLOAD operations per contract and per function