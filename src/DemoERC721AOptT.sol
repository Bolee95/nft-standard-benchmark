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

    /// @dev Mints token to the `to` address
    ///      Token ID will be automatically assigned starting from 0 to 2^256 - 1
    function singleMint(address to) external {
        _mint(to, 1);
    }

    /// @dev Mints `quantity` tokens to the `to` address
    ///      Token ID will be automatically assigned starting from 0 to 2^256 - 1
    function batchMint(address to, uint256 quantity) external {
        _mint(to, quantity);
    }

    /// @dev Transfers token with `id` from owner to the `to` address
    function singleTransfer(address to, uint256 id) external {
        safeTransferFrom(msg.sender, to, id);
    }

    /// @dev Transfers tokens with `ids` from owner to the `to` address
    function batchTransfer(address to, uint256[] calldata ids) external {
        _batchTransferFrom(msg.sender, to, ids, true);
    }
}
