// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC1155} from "oz-contracts/contracts/token/ERC1155/ERC1155.sol";

contract DemoERC1155 is ERC1155 {
    constructor() ERC1155("DemoERC1155") {}

    function singleMint(address to) external {
        _mint(to, 0, 1, "");
    }

    /// @dev Mints `quantity` tokens to the `account`
    ///      Using single mint function, as `_batchMint` does not have any
    ///      signiticant difference in terms of gas usage
    function batchMint(address to, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _mint(to, i, 1, "");

            unchecked {
                ++i;
            }
        }
    }

    function singleBurn(uint256 tokenId) external {
        _burn(msg.sender, tokenId, 1);
    }

    function batchBurn(uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _burn(msg.sender, i, 1);

            unchecked {
                ++i;
            }
        }
    }

    function singleTransfer(address to, uint256 tokenId) external {
        _safeTransferFrom(msg.sender, to, tokenId, 1, "");
    }

    function batchTransfer(address to, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _safeTransferFrom(msg.sender, to, i, 1, "");

            unchecked {
                ++i;
            }
        }
    }
}
