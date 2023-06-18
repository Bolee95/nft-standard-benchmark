// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";

import {DemoERC1155} from "../src/DemoERC1155.sol";
import {DemoERC721} from "../src/DemoERC721.sol";
import {DemoERC721A} from "../src/DemoERC721A.sol";
import {DemoERC721AOptT} from "../src/DemoERC721AOptT.sol";
import {DemoERC721AOptB} from "../src/DemoERC721AOptB.sol";

/**
 * [x] Get numbers of SREAD and SSTORE operations per call
 * [] Check why single burn shows no reads or writes for 1155, 721, 721A
 */

contract BenchmarkTest is Test {
    DemoERC1155 public demoERC1155;
    DemoERC721 public demoERC721;
    DemoERC721A public demoERC721A;
    DemoERC721AOptT public demoERC721AOptT;
    DemoERC721AOptB public demoERC721AOptB;

    bool public collectReadWrites = true;
    uint256 public batchMintQuantity = 100;
    address public tokenReceiver = address(1);

    function setUp() public {
        demoERC1155 = new DemoERC1155();
        demoERC721 = new DemoERC721();
        demoERC721A = new DemoERC721A();
        demoERC721AOptT = new DemoERC721AOptT();
        demoERC721AOptB = new DemoERC721AOptB();
    }

    function testSingleMint() public {
        _startRecord();

        _mintNonOptimized(tokenReceiver, 1);

        _getReadWrites("SingleMint");
    }

    function testBatchMint() public {
        _startRecord();

        _mintNonOptimized(tokenReceiver, batchMintQuantity);

        _getReadWrites("BatchMint");
    }

    function testSingleBurn() public {
        _mintNonOptimized(tokenReceiver, 1);
        demoERC721AOptB.mint(tokenReceiver, 1);

        _startRecord();

        demoERC1155.burn(0);
        demoERC721.burn(0);
        demoERC721A.burn(0);

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.prank(tokenReceiver);

        uint256[] memory ids = new uint256[](1);
        ids[0] = 0;
        demoERC721AOptB.batchBurn(ids);

        _getReadWrites("SingleBurn");
    }

    function testBatchBurn() public {
        _mintNonOptimized(tokenReceiver, batchMintQuantity);
        demoERC721AOptB.mint(tokenReceiver, batchMintQuantity);

        _startRecord();

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.startPrank(tokenReceiver);
        demoERC1155.burn(batchMintQuantity);
        demoERC721.burn(batchMintQuantity);
        demoERC721A.burn(batchMintQuantity);

        uint256[] memory ids = new uint256[](batchMintQuantity);
        for (uint256 i; i < batchMintQuantity;) {
            ids[i] = i;

            unchecked {
                ++i;
            }
        }

        demoERC721AOptB.batchBurn(ids);

        _getReadWrites("BatchBurn");
    }

    function _mintNonOptimized(address account, uint256 quantity) private {
        demoERC1155.mint(account, quantity);
        demoERC721.mint(account, quantity);
        demoERC721A.mint(account, quantity);
    }

    function _startRecord() private {
        if (!collectReadWrites) return;
        vm.record();
    }

    function _getReadWrites(string memory processTitle) private {
        if (!collectReadWrites) return;

        console.log("--------------------------------------------------");
        console.log(processTitle);
        console.log("--------------------------------------------------");

        bytes32[] memory reads;
        bytes32[] memory writes;

        (reads, writes) = vm.accesses(address(demoERC1155));
        _print(type(DemoERC1155).name, reads.length, writes.length);
        (reads, writes) = vm.accesses(address(demoERC721));
        _print(type(DemoERC721).name, reads.length, writes.length);
        (reads, writes) = vm.accesses(address(demoERC721A));
        _print(type(DemoERC721A).name, reads.length, writes.length);
        (reads, writes) = vm.accesses(address(demoERC721AOptT));
        _print(type(DemoERC721AOptT).name, reads.length, writes.length);
        (reads, writes) = vm.accesses(address(demoERC721AOptB));
        _print(type(DemoERC721AOptB).name, reads.length, writes.length);

        console.log("--------------------------------------------------");
    }

    /**
     * @dev Take into consideration that every WRITE is adding a READ operation
     */
    function _print(string memory cName, uint256 reads, uint256 writes) private view {
        console.log("%s - reads: %d - writes: %d", cName, reads - writes, writes);
    }
}
