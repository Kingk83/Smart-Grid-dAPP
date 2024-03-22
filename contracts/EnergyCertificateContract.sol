// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EnergyCertificate is ERC721Enumerable, Ownable {
    uint256 private _nextTokenId = 1;
    mapping(uint256 => uint256) public certificateAmount; // Maps tokenId to the amount of energy (in kWh)
    mapping(uint256 => string) private _tokenURIs; // Optional mapping for token URIs

    constructor() ERC721("RenewableEnergyCertificate", "REC") {}

    function mintCertificate(address to, uint256 amount, string memory newTokenURI) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
        certificateAmount[tokenId] = amount;
        _setTokenURI(tokenId, newTokenURI);
        // Emit an event or further logic here if needed
    }

    function _setTokenURI(uint256 tokenId, string memory newTokenURI) internal {
        _tokenURIs[tokenId] = newTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    // Add additional functions here for trading, retiring certificates, or verifying ownership and amounts
}
