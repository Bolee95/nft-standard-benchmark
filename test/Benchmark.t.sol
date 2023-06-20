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
 * Gas report should be generated with the same batch size every time in order to get proper values
 * Read and write operations should be also generated separately
 */

contract BenchmarkTest is Test {
    DemoERC1155 public demoERC1155;
    DemoERC721 public demoERC721;
    DemoERC721A public demoERC721A;
    DemoERC721AOptT public demoERC721AOptT;
    DemoERC721AOptB public demoERC721AOptB;

    uint256 public batchSize = 100;
    address public tokenReceiver = address(1);

    modifier showReadWrites(bool startRecord, string memory pTitle) {
        if (startRecord) vm.record();

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

        vm.record();
        vm.startPrank(tokenReceiver);

        demoERC1155.singleBurn(demoId);
        demoERC721.singleBurn(demoId);
        demoERC721A.singleBurn(demoId);
        demoERC721AOptB.singleBurn(demoId);
    }

    function testBatchBurnSequential() public showReadWrites(false, "BatchBurnSequential") {
        _batchBurn({ids: _createIds(batchSize), sequential: true});
    }

    function testBatchBurnNonSequential() public showReadWrites(false, "BatchBurnNonSequential") {
        _batchBurn({ids: _createIds(batchSize), sequential: false});
    }

    function _batchBurn(uint256[] memory ids, bool sequential) private {
        uint256[] memory burnIds = sequential ? ids : _exctractEvenIds(ids);

        _batchMintNonOptimized(tokenReceiver, ids);
        demoERC721AOptB.batchMint(tokenReceiver, ids.length);

        vm.record();
        vm.startPrank(tokenReceiver);

        demoERC1155.batchBurn(burnIds);
        demoERC721.batchBurn(burnIds);
        demoERC721A.batchBurn(burnIds);

        if (sequential) {
            demoERC721AOptB.batchBurnSequential(burnIds);
        } else {
            demoERC721AOptB.batchBurnNonSequential(burnIds);
        }
    }

    function testSingleTransfer() public showReadWrites(false, "SingleTransfer") {
        uint256 demoId = 2;
        address demoTo = address(2);

        _singleMintNonOptimized(tokenReceiver, demoId);
        demoERC721AOptT.singleMint(tokenReceiver);

        vm.record();
        vm.startPrank(tokenReceiver);

        demoERC721.singleTransfer(demoTo, demoId);
        demoERC1155.singleTransfer(demoTo, demoId);
        demoERC721A.singleTransfer(demoTo, 0);
        demoERC721AOptT.singleTransfer(demoTo, 0);
    }

    function testBatchTransferSequential() public showReadWrites(false, "BatchTransferSequential") {
        _batchTransfer({ids: _createIds(batchSize), sequential: true});
    }

    function testBatchTransferNonSequential() public showReadWrites(false, "BatchTransferNonSequential") {
        _batchTransfer({ids: _createIds(batchSize), sequential: false});
    }

    function _batchTransfer(uint256[] memory ids, bool sequential) private {
        address demoTo = address(2);
        uint256[] memory transferIds = sequential ? ids : _exctractEvenIds(ids);

        _batchMintNonOptimized(tokenReceiver, ids);
        demoERC721AOptT.batchMint(tokenReceiver, ids.length);

        vm.record();
        vm.startPrank(tokenReceiver);

        demoERC721.batchTransfer(demoTo, transferIds);
        demoERC1155.batchTransfer(demoTo, transferIds);
        demoERC721A.batchTransfer(demoTo, transferIds);

        if (sequential) {
            demoERC721AOptT.batchTransferSequential(demoTo, transferIds);
        } else {
            demoERC721AOptT.batchTransferNonSequential(demoTo, transferIds);
        }
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

    function _getReadWrites(string memory pTitle) private {
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

    function _createIds(uint256 quantity) private pure returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](quantity);
        for (uint256 i; i < quantity;) {
            ids[i] = i;

            unchecked {
                ++i;
            }
        }

        return ids;
    }

    function _exctractEvenIds(uint256[] memory ids) private pure returns (uint256[] memory) {
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
