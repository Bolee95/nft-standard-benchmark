// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC1155} from "oz-contracts/contracts/token/ERC1155/ERC1155.sol";

contract DemoERC1155 is ERC1155 {
    constructor() ERC1155("DemoERC1155") {}

    /// @dev Mints `quantity` tokens to the `account`
    ///      Using single mint function, as `_batchMint` does not have any
    ///      signiticant difference in terms of gas usage
    function mint(address account, uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _mint(account, i, 1, "");

            unchecked {
                ++i;
            }
        }
    }

    function burn(uint256 quantity) external {
        for (uint256 i; i < quantity;) {
            _burn(msg.sender, i, 1);

            unchecked {
                ++i;
            }
        }
    }
}
