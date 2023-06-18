// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";

import {DemoERC1155} from "../src/DemoERC1155.sol";
import {DemoERC721} from "../src/DemoERC721.sol";
import {DemoERC721A} from "../src/DemoERC721A.sol";
import {DemoERC721AOpt} from "../src/DemoERC721AOpt.sol";

/**
 * [] Get numbers of SREAD and SSTORE operations per call
 */

contract BenchmarkTest is Test {
    DemoERC1155 public demoERC1155;
    DemoERC721 public demoERC721;
    DemoERC721A public demoERC721A;
    DemoERC721AOpt public demoERC721AOpt;

    bool public collectReadWrites = true;
    uint256 public batchMintQuantity = 100;
    address public tokenReceiver = address(1);

    function setUp() public {
        if (collectReadWrites) {
            vm.record();
        }

        demoERC1155 = new DemoERC1155();
        demoERC721 = new DemoERC721();
        demoERC721A = new DemoERC721A();
        demoERC721AOpt = new DemoERC721AOpt();
    }

    function testSingleMint() public {
        demoERC1155.mint(tokenReceiver, 1);
        demoERC721.mint(tokenReceiver, 1);
        demoERC721A.mint(tokenReceiver, 1);
        demoERC721AOpt.mint(tokenReceiver, 1);

        _getReadWrites();
    }

    function testBatchMint() public {
        demoERC1155.mint(tokenReceiver, batchMintQuantity);
        demoERC721.mint(tokenReceiver, batchMintQuantity);
        demoERC721A.mint(tokenReceiver, batchMintQuantity);
        demoERC721AOpt.mint(tokenReceiver, batchMintQuantity);

        _getReadWrites();
    }

    function _getReadWrites() private {
        if (collectReadWrites) {
            bytes32[] memory reads;
            bytes32[] memory writes;

            (reads, writes) = vm.accesses(address(demoERC1155));
            _print("DemoERC1155", reads.length, writes.length);
            (reads, writes) = vm.accesses(address(demoERC721));
            _print("DemoERC721", reads.length, writes.length);
            (reads, writes) = vm.accesses(address(demoERC721A));
            _print("DemoERC721A", reads.length, writes.length);
            (reads, writes) = vm.accesses(address(demoERC721AOpt));
            _print("DemoERC721Opt", reads.length, writes.length);
        }
    }

    function _print(string memory cName, uint256 reads, uint256 writes) private {
        // Take into consideration that every WRITE is adding a READ operation
        console.log("%s - reads: %d - writes: %d", cName, reads - writes, writes);
    }
}
