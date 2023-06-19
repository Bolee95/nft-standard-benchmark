// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721A} from "ERC721A/ERC721A.sol";

contract DemoERC721A is ERC721A {
    constructor() ERC721A("DemoERC721A", "DEMO721A") {}

    function singleMint(address to) external {
        _mint(to, 1);
    }

    function batchMint(address to, uint256 quantity) external {
        _mint(to, quantity);
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
        transferFrom(msg.sender, to, tokenId);
    }

    function batchTransfer(address to, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            transferFrom(msg.sender, to, i);

            unchecked {
                ++i;
            }
        }
    }
}
