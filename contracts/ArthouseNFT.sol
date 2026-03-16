// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ArthouseNFT
 * @dev ERC-721 contract for Arthouse Mint Agent
 *      Helps traditional artists mint and sell art on Base Network
 *      Synthesis Hackathon 2026 — Theme: Agents that Pay
 */
contract ArthouseNFT is ERC721URIStorage, Ownable {

    // ── State ─────────────────────────────────────────────────────────────

    uint256 private _tokenIdCounter;

    // Price per mint in wei (can be updated by owner)
    uint256 public mintPrice;

    // Maps tokenId → artist wallet address
    mapping(uint256 => address) public tokenArtist;

    // Maps tokenId → sale price set by artist
    mapping(uint256 => uint256) public tokenPrice;

    // Tracks if a token is listed for sale
    mapping(uint256 => bool) public isListed;

    // Royalty percentage for artist on secondary sales (in basis points, e.g. 500 = 5%)
    uint256 public royaltyBps = 500;

    // ── Events ────────────────────────────────────────────────────────────

    event Minted(
        uint256 indexed tokenId,
        address indexed artist,
        string tokenURI,
        uint256 timestamp
    );

    event Listed(
        uint256 indexed tokenId,
        address indexed artist,
        uint256 price
    );

    event Sold(
        uint256 indexed tokenId,
        address indexed from,
        address indexed to,
        uint256 price
    );

    event PriceUpdated(uint256 indexed tokenId, uint256 newPrice);

    // ── Constructor ───────────────────────────────────────────────────────

    constructor(uint256 _mintPrice) ERC721("Arthouse", "ART") Ownable(msg.sender) {
        mintPrice = _mintPrice;
    }

    // ── Core Functions ────────────────────────────────────────────────────

    /**
     * @notice Mint a new NFT for an artist
     * @param artistWallet  The wallet address of the artist
     * @param uri           IPFS metadata URI (e.g. ipfs://Qm...)
     * @param salePrice     Initial listing price in wei (0 = not listed)
     */
    function mintForArtist(
        address artistWallet,
        string calldata uri,
        uint256 salePrice
    ) external payable returns (uint256) {
        require(msg.value >= mintPrice, "Insufficient mint fee");
        require(artistWallet != address(0), "Invalid artist address");
        require(bytes(uri).length > 0, "URI cannot be empty");

        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;

        _safeMint(artistWallet, tokenId);
        _setTokenURI(tokenId, uri);

        tokenArtist[tokenId] = artistWallet;

        if (salePrice > 0) {
            tokenPrice[tokenId] = salePrice;
            isListed[tokenId] = true;
            emit Listed(tokenId, artistWallet, salePrice);
        }

        emit Minted(tokenId, artistWallet, uri, block.timestamp);

        return tokenId;
    }

    /**
     * @notice Buy a listed NFT
     * @param tokenId  The token to purchase
     */
    function buyNFT(uint256 tokenId) external payable {
        require(isListed[tokenId], "Token not listed for sale");
        require(msg.value >= tokenPrice[tokenId], "Insufficient payment");

        address seller = ownerOf(tokenId);
        address artist = tokenArtist[tokenId];
        uint256 price = tokenPrice[tokenId];

        // Calculate royalty for original artist on secondary sales
        uint256 royalty = 0;
        if (seller != artist) {
            royalty = (price * royaltyBps) / 10000;
            payable(artist).transfer(royalty);
        }

        // Pay seller
        payable(seller).transfer(price - royalty);

        // Transfer NFT
        isListed[tokenId] = false;
        _transfer(seller, msg.sender, tokenId);

        emit Sold(tokenId, seller, msg.sender, price);
    }

    /**
     * @notice List or relist a token for sale
     * @param tokenId   Token to list
     * @param price     Sale price in wei
     */
    function listToken(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        require(price > 0, "Price must be greater than 0");

        tokenPrice[tokenId] = price;
        isListed[tokenId] = true;

        emit Listed(tokenId, msg.sender, price);
    }

    /**
     * @notice Delist a token from sale
     */
    function delistToken(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        isListed[tokenId] = false;
    }

    // ── Owner Functions ───────────────────────────────────────────────────

    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function setRoyaltyBps(uint256 _royaltyBps) external onlyOwner {
        require(_royaltyBps <= 1000, "Max royalty is 10%");
        royaltyBps = _royaltyBps;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");
        payable(owner()).transfer(balance);
    }

    // ── View Functions ────────────────────────────────────────────────────

    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }

    function getTokenInfo(uint256 tokenId) external view returns (
        address artist,
        uint256 price,
        bool listed,
        string memory uri
    ) {
        return (
            tokenArtist[tokenId],
            tokenPrice[tokenId],
            isListed[tokenId],
            tokenURI(tokenId)
        );
    }
}
