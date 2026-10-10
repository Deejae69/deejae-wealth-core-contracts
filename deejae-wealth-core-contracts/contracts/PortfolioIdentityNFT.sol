// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PortfolioIdentityNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    mapping(uint256 => bytes32) private _portfolioSeeds;
    mapping(address => uint256) private _userToken;

    event PortfolioCreated(
        address indexed owner,
        uint256 indexed tokenId,
        bytes32 portfolioSeed,
        uint256 score
    );

    constructor() ERC721("DeeJae Portfolio Identity", "DPI") {}

    function mintAnonymousPortfolio(
        address to,
        string memory tokenURI,
        uint256 score
    ) public onlyOwner returns (uint256) {
        require(to != address(0), "Invalid recipient address");

        uint256 tokenId = _tokenIds.current();
        _tokenIds.increment();

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        bytes32 portfolioSeed = keccak256(
            abi.encodePacked(block.timestamp, block.prevrandao, to, tokenId, score)
        );

        _portfolioSeeds[tokenId] = portfolioSeed;
        _userToken[to] = tokenId;

        emit PortfolioCreated(to, tokenId, portfolioSeed, score);
        return tokenId;
    }

    function portfolioSeed(uint256 tokenId) external view returns (bytes32) {
        return _portfolioSeeds[tokenId];
    }

    function userPortfolio(address user) external view returns (uint256) {
        return _userToken[user];
    }
}
