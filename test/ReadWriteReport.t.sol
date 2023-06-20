// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./Benchmark.t.sol";

contract ReadWriteReport is BenchmarkTest {
    function _collectReadWrites() internal virtual override returns (bool) {
        return true;
    }
}
