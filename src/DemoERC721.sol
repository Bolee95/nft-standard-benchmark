// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721} from "oz-contracts/contracts/token/ERC721/ERC721.sol";

contract DemoERC721 is ERC721 {
    constructor() ERC721("DemoERC721", "DEMO721") {}

    function singleMint(address to) external {
        _mint(to, 0);
    }

    function batchMint(address to, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _mint(to, i);

            unchecked {
                ++i;
            }
        }
    }

    function singleBurn(uint256 tokenId) external {
        _burn(tokenId);
    }

    function batchBurn(uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _burn(i);

            unchecked {
                ++i;
            }
        }
    }

    function singleTransfer(address to, uint256 tokenId) external {
        _transfer(msg.sender, to, tokenId);
    }

    function batchTransfer(address to, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _transfer(msg.sender, to, i);

            unchecked {
                ++i;
            }
        }
    }
}
