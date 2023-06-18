// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721A} from "ERC721A/ERC721A.sol";

contract DemoERC721A is ERC721A {
    constructor() ERC721A("DemoERC721A", "DEMO721A") {}

    function mint(address account, uint256 quantity) external {
        _mint(account, quantity);
    }

    function burn(uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _burn(i);

            unchecked {
                ++i;
            }
        }
    }
}
