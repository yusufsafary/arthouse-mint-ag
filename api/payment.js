// Arthouse Mint Agent - Payment via x402
// Synthesis Hackathon 2026

require('dotenv').config();

async function createMintPayment(artistWallet) {
  try {
    const response = await fetch('https://api.x402.org/payment', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        receiver: artistWallet,
        amount: '0.001',
        currency: 'ETH',
        network: 'base',
        description: 'Arthouse NFT Mint Payment',
        metadata: {
          project: 'Arthouse Mint Agent',
          hackathon: 'The Synthesis 2026'
        }
      })
    });

    const payment = await response.json();

    console.log(`💰 Payment request created: ${payment.id}`);
    return payment;

  } catch (error) {
    throw new Error(`Payment failed: ${error.message}`);
  }
}

async function verifyPayment(paymentId) {
  try {
    const response = await fetch(
      `https://api.x402.org/payment/${paymentId}`,
      {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );

    const status = await response.json();
    return status.confirmed === true;

  } catch (error) {
    throw new Error(`Verify failed: ${error.message}`);
  }
}
