// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721ABatchTransferable, ERC721A} from "ERC721A-opt-transfer/extensions/ERC721ABatchTransferable.sol";
// import {ERC721ABatchBurnable} from "ERC721A-opt-burn/extensions/ERC721ABatchBurnable.sol";

/**
 * @dev ERC721A token optimized for batch transfers.
 *      Separated from `batchBurn` as those are separate extensions
 *      and they are still not incorporated in the same contract.
 */
contract DemoERC721AOptT is ERC721ABatchTransferable {
    constructor() ERC721A("DemoERC721AOptT", "DemoERC721AOptT") {}

    function singleMint(address to) external {
        _mint(to, 1);
    }

    function batchMint(address to, uint256 quantity) external {
        _mint(to, quantity);
    }

    function singleTransfer(address to, uint256[] memory tokenIds) external {
        _batchTransferFrom(msg.sender, to, tokenIds, true);
    }

    function batchTransfer(address to, uint256[] memory tokenIds) external {
        _batchTransferFrom(msg.sender, to, tokenIds, true);
    }
}
