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
 * [x] Add single and batch transfers
 * [] Add non-sequenctial options for burn and transfer
 */

contract BenchmarkTest is Test {
    DemoERC1155 public demoERC1155;
    DemoERC721 public demoERC721;
    DemoERC721A public demoERC721A;
    DemoERC721AOptT public demoERC721AOptT;
    DemoERC721AOptB public demoERC721AOptB;

    bool public collectReadWrites = true;
    uint256 public batchSize = 100;
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
        _batchMintNonOptimized(tokenReceiver, batchSize);
    }

    function testSingleBurn() public showReadWrites(false, "SingleBurn") {
        _singleMintNonOptimized(tokenReceiver);
        demoERC721AOptB.singleMint(tokenReceiver);

        _startRecord();

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.prank(tokenReceiver);

        demoERC1155.singleBurn(0);
        demoERC721.singleBurn(0);
        demoERC721A.singleBurn(0);
        demoERC721AOptB.singleBurn(0);
    }

    function testBatchBurn() public showReadWrites(false, "BatchBurn") {
        _batchMintNonOptimized(tokenReceiver, batchSize);
        demoERC721AOptB.batchMint(tokenReceiver, batchSize);

        _startRecord();

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.startPrank(tokenReceiver);
        demoERC1155.batchBurn(batchSize);
        demoERC721.batchBurn(batchSize);
        demoERC721A.batchBurn(batchSize);

        uint256[] memory ids = new uint256[](batchSize);
        for (uint256 i; i < batchSize;) {
            ids[i] = i;

            unchecked {
                ++i;
            }
        }

        demoERC721AOptB.batchBurn(ids);
    }

    function testSingleTransfer() public showReadWrites(false, "SingleTransfer") {
        address demoTo = address(2);

        _singleMintNonOptimized(tokenReceiver);
        demoERC721AOptT.singleMint(tokenReceiver);

        _startRecord();

        vm.startPrank(tokenReceiver);

        demoERC721.singleTransfer(demoTo, 0);
        demoERC1155.singleTransfer(demoTo, 0);
        demoERC721A.singleTransfer(demoTo, 0);
        demoERC721AOptT.singleTransfer(demoTo, _asSingletonArray(0));
    }

    function testBatchTransfer() public showReadWrites(false, "BatchTransfer") {
        address demoTo = address(2);

        _batchMintNonOptimized(tokenReceiver, batchSize);
        demoERC721AOptT.batchMint(tokenReceiver, batchSize);

        _startRecord();

        vm.startPrank(tokenReceiver);

        demoERC721.batchTransfer(demoTo, batchSize);
        demoERC1155.batchTransfer(demoTo, batchSize);
        demoERC721A.batchTransfer(demoTo, batchSize);

        uint256[] memory ids = new uint256[](batchSize);
        for (uint256 i; i < batchSize;) {
            ids[i] = i;

            unchecked {
                ++i;
            }
        }

        demoERC721AOptT.batchTransfer(demoTo, ids);
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

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}
