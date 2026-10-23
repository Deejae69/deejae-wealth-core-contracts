// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract D33JToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000_000e18;

    constructor() ERC20("D33J Coin", "D33J") {
        _mint(msg.sender, 200_000_000e18);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply reached");
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
