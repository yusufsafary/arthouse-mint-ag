// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Arthouse Mint Agent - NFT Smart Contract
// Synthesis Hackathon 2026

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArthouseNFT is ERC721, Ownable {
    uint256 public tokenCounter;
    uint256 public mintPrice = 0.001 ether;
    
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint256[]) public artistTokens;

    event NFTMinted(
        address indexed artist,
        uint256 indexed tokenId,
        string tokenURI
    );

    constructor() ERC721("Arthouse", "ART") Ownable(msg.sender) {}

    function mint(
        address to, 
        string memory tokenURI
    ) public payable returns (uint256) {
        require(msg.value >= mintPrice, "Insufficient payment");
        
        uint256 tokenId = tokenCounter;
        _safeMint(to, tokenId);
        _tokenURIs[tokenId] = tokenURI;
        artistTokens[to].push(tokenId);
        tokenCounter++;

        emit NFTMinted(to, tokenId, tokenURI);
        return tokenId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function getArtistTokens(
        address artist
    ) public view returns (uint256[] memory) {
        return artistTokens[artist];
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
