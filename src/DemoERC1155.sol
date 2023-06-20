// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC1155} from "oz-contracts/contracts/token/ERC1155/ERC1155.sol";

contract DemoERC1155 is ERC1155 {
    constructor() ERC1155("DemoERC1155") {}

    /// @dev Mints token with `id` to the `to` address
    function singleMint(address to, uint256 id) external {
        _mint(to, id, 1, "");
    }

    /// @dev Mints tokens with `ids` to the `to` address
    function batchMint(address to, uint256[] calldata ids) external {
        uint256[] memory amounts = new uint256[](ids.length);
        for (uint256 i; i < ids.length;) {
            amounts[i] = 1;

            unchecked {
                ++i;
            }
        }

        _mintBatch(to, ids, amounts, "");
    }

    /// @dev burns token with `id` from the owner address
    function singleBurn(uint256 id) external {
        _burn(msg.sender, id, 1);
    }

    /// @dev Burns tokens with `ids` from the owner address
    function batchBurn(uint256[] calldata ids) external {
        for (uint256 i; i < ids.length;) {
            _burn(msg.sender, ids[i], 1);

            unchecked {
                ++i;
            }
        }
    }

    /// @dev Transfers token with `id` from the `from` address to the `to` address
    function singleTransfer(address to, uint256 id) external {
        _safeTransferFrom(msg.sender, to, id, 1, "");
    }

    /// @dev Transfers tokens with `ids` from the `from` address to the `to` address
    function batchTransfer(address to, uint256[] calldata ids) external {
        uint256 len = ids.length;

        for (uint256 i; i < len;) {
            _safeTransferFrom(msg.sender, to, ids[i], 1, "");

            unchecked {
                ++i;
            }
        }
    }
}
