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
 * [x] Add non-sequenctial options for burn and transfer
 *         -  Removed as it produces the same results for 721 and 1155, and 721OptB and 721OptT
 *            Expect the ids in accenting order. Maybe these should be tested with a different ranges?
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
        _singleMintNonOptimized(tokenReceiver, 0);
    }

    function testBatchMint() public showReadWrites(true, "BatchMint") {
        uint256[] memory ids = _createIds({quantity: batchSize});
        _batchMintNonOptimized(tokenReceiver, ids);
    }

    function testSingleBurn() public showReadWrites(false, "SingleBurn") {
        uint256 demoId = 0;

        _singleMintNonOptimized(tokenReceiver, demoId);
        demoERC721AOptB.singleMint(tokenReceiver);

        _startRecord();

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.prank(tokenReceiver);

        demoERC1155.singleBurn(demoId);
        demoERC721.singleBurn(demoId);
        demoERC721A.singleBurn(demoId);
        demoERC721AOptB.singleBurn(demoId);
    }

    // function testBatchBurnSequential() public showReadWrites(false, "BatchBurnSequential") {
    //     uint256[] memory ids = _createIds({quantity: batchSize});
    //     _batchBurn(ids);
    // }

    function testBatchBurnNonSequential() public showReadWrites(false, "BatchBurnNonSequential") {
        uint256[] memory ids = _createIds({quantity: batchSize});
        _batchBurn(_exctractEvenIds(ids));
    }

    function _batchBurn(uint256[] memory ids) private {
        _batchMintNonOptimized(tokenReceiver, ids);
        demoERC721AOptB.batchMint(tokenReceiver, batchSize);

        _startRecord();

        console.log(demoERC721A.totalSupply());
        console.log(demoERC721A.ownerOf(98));

        // Burn can be called only by owner or approved
        // so we are going to be owner
        vm.startPrank(tokenReceiver);
        demoERC1155.batchBurn(ids);
        demoERC721.batchBurn(ids);
        demoERC721A.batchBurn(ids);
        // demoERC721AOptB.batchBurn(ids);
    }

    function testSingleTransfer() public showReadWrites(false, "SingleTransfer") {
        address demoTo = address(2);
        uint256 demoId = 2;

        _singleMintNonOptimized(tokenReceiver, demoId);
        demoERC721AOptT.singleMint(tokenReceiver);

        _startRecord();

        vm.startPrank(tokenReceiver);

        demoERC721.singleTransfer(demoTo, demoId);
        demoERC1155.singleTransfer(demoTo, demoId);
        demoERC721A.singleTransfer(demoTo, 0);
        demoERC721AOptT.singleTransfer(demoTo, 0);
    }

    function testBatchTransfer() public showReadWrites(false, "BatchTransfer") {
        address demoTo = address(2);
        uint256[] memory ids = _createIds({quantity: batchSize});

        _batchMintNonOptimized(tokenReceiver, ids);
        demoERC721AOptT.batchMint(tokenReceiver, batchSize);

        _startRecord();

        vm.startPrank(tokenReceiver);

        demoERC721.batchTransfer(demoTo, ids);
        demoERC1155.batchTransfer(demoTo, ids);
        demoERC721A.batchTransfer(demoTo, ids);
        demoERC721AOptT.batchTransfer(demoTo, ids);
    }

    function _singleMintNonOptimized(address account, uint256 id) private {
        demoERC1155.singleMint(account, id);
        demoERC721.singleMint(account, id);
        // Tokens always minted in suquential order
        demoERC721A.singleMint(account);
    }

    function _batchMintNonOptimized(address account, uint256[] memory ids) private {
        demoERC1155.batchMint(account, ids);
        demoERC721.batchMint(account, ids);
        // Tokens always minted in suquential order
        demoERC721A.batchMint(account, ids.length);
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

    function _createIds(uint256 quantity) private view returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](quantity);
        for (uint256 i; i < batchSize;) {
            ids[i] = i;

            unchecked {
                ++i;
            }
        }

        return ids;
    }

    function _exctractEvenIds(uint256[] memory ids) private view returns (uint256[] memory) {
        uint256[] memory evenIds = new uint256[](ids.length / 2);
        for (uint256 i; i < ids.length; i += 2) {
            evenIds[i / 2] = ids[i];
        }

        return evenIds;
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}
