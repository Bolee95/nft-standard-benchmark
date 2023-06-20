// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721A} from "ERC721A/ERC721A.sol";

contract DemoERC721A is ERC721A {
    constructor() ERC721A("DemoERC721A", "DEMO721A") {}

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

    /// @dev Burns tokens with `ids` from the owner address
    function batchBurn(uint256[] calldata ids) external {
        uint256 len = ids.length;

        for (uint256 i; i < len;) {
            _burn(ids[i]);

            unchecked {
                ++i;
            }
        }
    }

    /// @dev Transfers token with `id` from the `from` address to the `to` address
    function singleTransfer(address to, uint256 id) external {
        transferFrom(msg.sender, to, id);
    }

    /// @dev Transfers tokens with `ids` from the `from` address to the `to` address
    function batchTransfer(address to, uint256[] calldata ids) external {
        uint256 len = ids.length;

        for (uint256 i; i < len;) {
            transferFrom(msg.sender, to, ids[i]);

            unchecked {
                ++i;
            }
        }
    }
}
