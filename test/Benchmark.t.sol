// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";

import {DemoERC1155} from "../src/DemoERC1155.sol";
import {DemoERC721} from "../src/DemoERC721.sol";
import {DemoERC721A} from "../src/DemoERC721A.sol";
import {DemoERC721AOptT} from "../src/DemoERC721AOptT.sol";
import {DemoERC721AOptB} from "../src/DemoERC721AOptB.sol";

/**
 * [x] Get numbers of SLOAD and SSTORE operations per call
 * [x] Check why single burn shows no reads or writes for 1155, 721, 721A
 *         -  For 1155, it should have at least 1 read and 1 write
 * [] Add single and batch transfers
 * [] Add non-sequenctial options for burn and transfer
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

    modifier showReadWrites(bool startRecord, string memory pTitle) {
        _startRecord();

        _;

        _getReadWrites(pTitle);
    }

    function setUp() public {
        demoERC1155 = new DemoERC1155();
        demoERC721 = new DemoERC721();
        demoERC721A = new DemoERC721A();
        demoERC721AOptT = new DemoERC721AOptT();
        demoERC721AOptB = new DemoERC721AOptB();
    }

    function testSingleMint() public showReadWrites(true, "SingleMint") {
        _singleMintNonOptimized(tokenReceiver);
    }

    function testBatchMint() public showReadWrites(true, "BatchMint") {
        _batchMintNonOptimized(tokenReceiver, batchMintQuantity);
    }

    function testSingleBurn() public showReadWrites(false, "SingleBurn") {
        _singleMintNonOptimized(tokenReceiver);
        demoERC721AOptB.singleMint(tokenReceiver);

        _startRecord();

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.prank(tokenReceiver);

        demoERC1155.singleBurn(0);
        // FIXME Check this
        demoERC721.singleBurn(1);
        demoERC721A.singleBurn(0);

        demoERC721AOptB.singleBurn(0);
    }

    function testBatchBurn() public showReadWrites(false, "BatchBurn") {
        _batchMintNonOptimized(tokenReceiver, batchMintQuantity);
        demoERC721AOptB.batchMint(tokenReceiver, batchMintQuantity);

        _startRecord();

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.startPrank(tokenReceiver);
        demoERC1155.batchBurn(batchMintQuantity);
        demoERC721.batchBurn(batchMintQuantity);
        demoERC721A.batchBurn(batchMintQuantity);

        uint256[] memory ids = new uint256[](batchMintQuantity);
        for (uint256 i; i < batchMintQuantity;) {
            ids[i] = i;

            unchecked {
                ++i;
            }
        }

        demoERC721AOptB.batchBurn(ids);
    }

    function _singleMintNonOptimized(address account) private {
        demoERC1155.singleMint(account);
        demoERC721.singleMint(account);
        demoERC721A.singleMint(account);
    }

    function _batchMintNonOptimized(address account, uint256 quantity) private {
        demoERC1155.batchMint(account, quantity);
        demoERC721.batchMint(account, quantity);
        demoERC721A.batchMint(account, quantity);
    }

    function _startRecord() private {
        if (collectReadWrites) vm.record();
    }

    function _getReadWrites(string memory pTitle) private {
        if (!collectReadWrites) return;

        bytes32[] memory reads;
        bytes32[] memory writes;

        console.log("--------------------------------------------------");
        console.log(pTitle);
        console.log("--------------------------------------------------");

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
