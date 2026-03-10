// Arthouse Mint Agent - Handlers
// Synthesis Hackathon 2026

const { uploadToIPFS } = require('../api/upload');
const { createMintPayment } = require('../api/payment');
const { mintNFT } = require('../api/mint');

async function handleMintRequest(artName, artDescription, userWallet, imageBuffer) {
  try {
    console.log(`🎨 Processing mint for: ${artName}`);

    // Step 1: Upload ke IPFS
    console.log('📤 Uploading to IPFS...');
    const tokenURI = await uploadToIPFS(imageBuffer, {
      name: artName,
      description: artDescription,
      artist: userWallet
    });

    // Step 2: Buat payment via x402
    console.log('💰 Creating payment request...');
    const payment = await createMintPayment(userWallet);

    // Step 3: Mint NFT
    console.log('⛓️ Minting NFT on Base...');
    const tokenId = await mintNFT(userWallet, tokenURI);

    return {
      success: true,
      tokenId,
      tokenURI,
      message: `🎉 NFT "${artName}" berhasil di-mint! Token ID: ${tokenId}`
    };

  } catch (error) {
    return {
      success: false,
      message: `❌ Gagal mint: ${error.message}`
    };
  }
}

module.exports = { handleMintRequest
