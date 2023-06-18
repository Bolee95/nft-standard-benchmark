// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721} from "oz-contracts/contracts/token/ERC721/ERC721.sol";

contract DemoERC721 is ERC721 {
    constructor() ERC721("DemoERC721", "DEMO721") {}

    function mint(address account, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _mint(account, i);

            unchecked {
                ++i;
            }
        }
    }
}
