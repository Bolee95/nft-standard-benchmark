// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC721ABatchTransferable, ERC721A} from "ERC721A-opt-transfer/extensions/ERC721ABatchTransferable.sol";
import {ERC721ABatchBurnable} from "ERC721A-opt-burn/extensions/ERC721ABatchBurnable.sol";

contract DemoERC721AOpt is ERC721ABatchTransferable {
    constructor() ERC721A("DemoERC721AOpt", "DemoERC721AOpt") {}

    function mint(address account, uint256 quantity) external {
        _mint(account, quantity);
    }
}
