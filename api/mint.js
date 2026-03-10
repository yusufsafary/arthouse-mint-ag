// Arthouse Mint Agent - Mint API
// Synthesis Hackathon 2026

const { ethers } = require('ethers');
require('dotenv').config();

const CONTRACT_ABI = [
  "function mint(address to, string memory tokenURI) public payable returns (uint256)",
  "function tokenCounter() public view returns (uint256)",
  "function mintPrice() public view returns (uint256)",
  "event NFTMinted(address indexed artist, uint256 indexed tokenId, string tokenURI)"
];

async function mintNFT(artistWallet, tokenURI) {
  try {
    // Connect ke Base Network
    const provider = new ethers.JsonRpcProvider(
      process.env.BASE_RPC_URL
    );
    
    const signer = new ethers.Wallet(
      process.env.PRIVATE_KEY, 
      provider
    );

    // Connect ke smart contract
    const contract = new ethers.Contract(
      process.env.CONTRACT_ADDRESS,
      CONTRACT_ABI,
      signer
    );

    // Mint NFT
    const mintPrice = await contract.mintPrice();
    const tx = await contract.mint(artistWallet, tokenURI, {
      value: mintPrice
    });

    console.log(`⛓️ Transaction sent: ${tx.hash}`);
    const receipt = await tx.wait();
    console.log(`✅ Minted! Block: ${receipt.blockNumber}`);

    // Ambil tokenId dari event
    const event = receipt.logs[0];
    const tokenId = event.topics[2];

    return {
      tokenId: parseInt(tokenId, 16),
      txHash: tx.hash,
      blockNumber: receipt.blockNumber
    };

  } catch (error) {
    throw new Error(`Mint failed: ${error.message}`);
  }
}

module.exports = { mintNFT };
