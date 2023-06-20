// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721ABatchBurnable, ERC721A} from "ERC721A-opt-burn/extensions/ERC721ABatchBurnable.sol";

/**
 * @dev ERC721A token optimized for batch burns.
 *      Separated from `batchBurn` as those are separate extensions
 *      and they are still not incorporated in the same contract.
 */
contract DemoERC721AOptB is ERC721ABatchBurnable {
    constructor() ERC721A("DemoERC721AOptB", "DemoERC721AOptB") {}

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

    /// @dev Burns token with `id` from the owner address
    function singleBurn(uint256 id) external {
        _burn(id);
    }

    /// note `batchBurn` is defined in `ERC721ABatchBurnable` extension
}
