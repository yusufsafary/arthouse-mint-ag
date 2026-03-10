// Arthouse Mint Agent - IPFS Upload via Pinata
// Synthesis Hackathon 2026

require('dotenv').config();

async function uploadToIPFS(imageBuffer, metadata) {
  try {
    // Step 1: Upload gambar ke IPFS
    const formData = new FormData();
    const blob = new Blob([imageBuffer], { type: 'image/png' });
    formData.append('file', blob, 'artwork.png');
    formData.append('pinataMetadata', JSON.stringify({
      name: metadata.name
    }));

    const imageResponse = await fetch(
      'https://api.pinata.cloud/pinning/pinFileToIPFS',
      {
        method: 'POST',
        headers: {
          'pinata_api_key': process.env.PINATA_API_KEY,
          'pinata_secret_api_key': process.env.PINATA_SECRET
        },
        body: formData
      }
    );

    const imageResult = await imageResponse.json();
    const imageURI = `ipfs://${imageResult.IpfsHash}`;
    console.log(`🖼️ Image uploaded: ${imageURI}`);

    // Step 2: Upload metadata ke IPFS
    const metadataResponse = await fetch(
      'https://api.pinata.cloud/pinning/pinJSONToIPFS',
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'pinata_api_key': process.env.PINATA_API_KEY,
          'pinata_secret_api_key': process.env.PINATA_SECRET
        },
        body: JSON.stringify({
          pinataContent: {
            name: metadata.name,
            description: metadata.description,
            image: imageURI,
            artist: metadata.artist,
            attributes: [
              {
                trait_type: 'Artist',
                value: metadata.artist
              },
              {
                trait_type: 'Hackathon',
                value: 'The Synthesis 2026'
              },
              {
                trait_type: 'Network',
                value: 'Base Mainnet'
              }
            ]
          },
          pinataMetadata: {
            name: `${metadata.name} - Metadata`
          }
        })
      }
    );

    const metadataResult = await metadataResponse.json();
    const tokenURI = `ipfs://${metadataResult.IpfsHash}`;
    console.log(`📋 Metadata uploaded: ${tokenURI}`);

    return tokenURI;

  } catch (error) {
    throw new Error(`IPFS upload failed: ${error.message}`);
  }
}
