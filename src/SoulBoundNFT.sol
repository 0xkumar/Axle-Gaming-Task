//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract SoulBoundNFT is ERC721, Ownable {
    // Counter for token IDs
    uint256 private _tokenIdCounter;
    
    // Mapping to store token URIs
    mapping(uint256 => string) private _tokenURIs;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) Ownable(msg.sender) {}

    /**
     * @dev Allows the contract owner to mint a new SoulBound NFT to a recipient
     * @param to The address that will receive the NFT
     * @param uri The token URI for the NFT metadata
     */
    function safeMint(address to, string memory uri) public onlyOwner {
        require(balanceOf(to) == 0, "Recipient already has a SoulBound NFT");
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /**
     * @dev Internal function to set the token URI
     */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_ownerOf(tokenId) != address(0), "URI set for nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    /**
     * @dev Override the tokenURI function to return custom URIs
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    /**
     * @dev Override _update to prevent transfers
     */
    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
        address from = _ownerOf(tokenId);
        
        // If this is a mint operation (from = address(0)), allow it
        if (from == address(0)) {
            return super._update(to, tokenId, auth);
        }
        
        // For all other operations (transfers, burns), revert
        revert("SoulBoundNFT: Token transfers are disabled");
    }

    /**
     * @dev Disable approval functions
     */
    function approve(address/* to*/, uint256/* tokenId*/) public virtual override {
        revert("SoulBoundNFT: Token approvals are disabled");
    }

    function setApprovalForAll(address/* operator*/, bool/* approved*/) public virtual override {
        revert("SoulBoundNFT: Token approvals are disabled");
    }
}