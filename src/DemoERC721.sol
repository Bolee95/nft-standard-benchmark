// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721} from "oz-contracts/contracts/token/ERC721/ERC721.sol";

contract DemoERC721 is ERC721 {
    constructor() ERC721("DemoERC721", "DEMO721") {}

    /// @dev Mints token with `id` to the `to` address
    function singleMint(address to, uint256 id) external {
        _mint(to, id);
    }

    /// @dev Mints tokens with `ids` to the `to` address
    function batchMint(address to, uint256[] calldata ids) external {
        uint256 len = ids.length;

        for (uint256 i; i < len;) {
            _mint(to, ids[i]);

            unchecked {
                ++i;
            }
        }
    }

    /// @dev Burns token with `id` from the owner address
    function singleBurn(uint256 id) external {
        _burn(id);
    }

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
        _transfer(msg.sender, to, id);
    }

    /// @dev Transfers tokens with `ids` from the `from` address to the `to` address
    function batchTransfer(address to, uint256[] calldata ids) external {
        uint256 len = ids.length;

        for (uint256 i; i < len;) {
            _transfer(msg.sender, to, ids[i]);

            unchecked {
                ++i;
            }
        }
    }
}
