# 🎨 Arthouse Mint Agent

> AI Agent that helps traditional artists in Indonesia — and underserved creators worldwide — mint and sell NFT art on Base Network via WhatsApp or Telegram. Zero Web3 knowledge needed. Wallet auto-created. Payment in crypto or local currency.

**Synthesis Hackathon 2026** | Theme: **Agents that Pay**

---

## 🌟 What is Arthouse?

Arthouse is an AI agent that bridges the gap between traditional artists in underserved communities and the global Web3 economy. Starting in Indonesia — home to millions of batik makers, wayang craftsmen, and painters — with a model that can scale to any country where talented creators are locked out of digital markets.

**The entire experience happens inside WhatsApp or Telegram** — apps artists already use every day. Arthouse automatically creates a custodial wallet for each artist, handles all gas fees, uploads artwork to IPFS, mints the NFT on Base, and delivers payment in crypto or converted to local fiat currency.

No wallets to configure. No gas fees to understand. No crypto knowledge needed. Just send a photo and get paid.

---

## 🔥 The Problem

There are an estimated **300 million traditional artists and craftspeople** in the Global South — Indonesia, India, West Africa, Latin America — creating world-class work with no access to global buyers.

In Indonesia alone: batik makers in Solo, wayang craftsmen in Yogyakarta, painters in Bali. Masterpieces sold for pennies at local markets because there's no bridge to the people who would pay 100x more online.

Web3 promises permissionless participation for anyone, anywhere. But the onboarding wall is still brutal: setting up a wallet, buying crypto for gas, understanding IPFS, navigating smart contracts. Even the best existing tools like Zora or OpenSea assume the user is already Web3-native.

**Arthouse assumes nothing.** If you can send a WhatsApp message, you can sell an NFT to a collector in New York, Tokyo, or Berlin.

---

## ✅ How It Works

```
Artist sends photo via WhatsApp / Telegram
             ↓
Arthouse Agent receives message
             ↓
Auto-creates custodial wallet for artist (first time only)
             ↓
Uploads image to IPFS via Pinata
             ↓
Mints ERC-721 NFT on Base Mainnet
             ↓
Buyer pays via x402 Protocol (on-chain, no middleman)
             ↓
Artist chooses: receive crypto OR Rupiah via QRIS
```

The agent handles **every on-chain action autonomously** — the artist only ever touches a chat interface they already know.

---

## 🏗️ Architecture

```
arthouse-mint-ag/
├── agent/
│   ├── index.js        # Agent entry point & conversation loop
│   ├── prompts.js      # System prompts & agent personality
│   └── handlers.js     # Action handlers (mint, upload, pay)
├── contracts/
│   └── ArthouseNFT.sol # ERC-721 smart contract on Base
├── api/
│   ├── mint.js         # NFT minting logic
│   ├── payment.js      # x402 payment integration
│   └── upload.js       # IPFS upload via Pinata
├── package.json
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Agent Platform | A0x (Arthouse Agent) |
| Blockchain | Base Mainnet |
| NFT Standard | ERC-721 |
| Payment Protocol | x402 |
| Storage | IPFS via Pinata |
| Smart Contract | Solidity |
| Runtime | Node.js |

---

## 🚀 Getting Started

### Prerequisites

- Node.js v18+
- A wallet with Base ETH (for gas)
- Pinata account → [pinata.cloud](https://pinata.cloud)

### Installation

```bash
git clone https://github.com/yusufsafary/arthouse-mint-ag
cd arthouse-mint-ag
npm install
```

### Environment Setup

Create a `.env` file in the root directory:

```env
PRIVATE_KEY=your_wallet_private_key
BASE_RPC_URL=https://mainnet.base.org
CONTRACT_ADDRESS=your_deployed_contract_address
PINATA_API_KEY=your_pinata_api_key
PINATA_SECRET=your_pinata_secret
SYNTHESIS_API_KEY=your_synthesis_api_key
```

> ⚠️ **Never commit your `.env` file to GitHub!**

### Deploy Smart Contract

```bash
# Deploy ArthouseNFT.sol to Base Mainnet
npx hardhat run scripts/deploy.js --network base
```

Save the contract address to `CONTRACT_ADDRESS` in your `.env`.

### Run the Agent

```bash
node agent/index.js
```

---

## 💬 Example Conversation

```
[WhatsApp]

Artist: "Halo, saya mau jual lukisan batik saya"

Arthouse: "Halo! Kirimkan foto lukisannya dan aku akan 
           bantu jual sebagai NFT ke kolektor di seluruh 
           dunia. Tidak perlu paham crypto — aku yang 
           urus semuanya! 🎨"

Artist: [sends photo]

Arthouse: "Bagus sekali! Judul karyanya apa, dan 
           harga berapa yang kamu inginkan?"

Artist: "Batik Parang Kusumo, harga 0.05 ETH"

Arthouse: "Baik! Sedang memproses...
           ✅ Wallet otomatis dibuat untukmu
           ✅ Gambar tersimpan di IPFS (permanent)
           ✅ NFT berhasil di-mint di Base!
           
           🔗 Lihat NFT-mu: basescan.org/tx/0x...
           🌍 Karyamu sekarang bisa dibeli siapapun 
              di seluruh dunia.
           
           Mau terima pembayaran dalam crypto 
           atau Rupiah via QRIS?"

Artist: "Rupiah saja"

Arthouse: "Siap! Begitu NFT terjual, dana akan 
           otomatis dikonversi dan dikirim ke QRIS-mu."
```

---

## 🔗 On-Chain Activity

View all Arthouse transactions on Base:
👉 [basescan.org](https://basescan.org)

---

## 🤝 Why Base + x402?

- **Base** provides low-cost, fast transactions — ideal for artists who can't afford high gas fees
- **x402 Protocol** enables agent-native payments: transparent, verifiable, and settlement without a middleman
- **IPFS via Pinata** ensures artwork is stored permanently and decentralized

---

## 📋 Roadmap

- [x] Smart contract deployment (ArthouseNFT.sol)
- [x] IPFS upload integration
- [x] Agent conversation flow
- [x] x402 payment integration
- [ ] Multi-language support (Bahasa Indonesia, Javanese)
- [ ] Mobile-friendly interface for village artists
- [ ] Batch minting for art collections
- [ ] Royalty splits for artist communities

---

## 👤 Team

**Yusup Sapari** (Founder) + **Arthouse Agent**

- Twitter/X: [@arthousebase](https://x.com/arthousebase)
- Hackathon: [Synthesis 2026](https://synthesis.md)

---

## 📄 License

MIT — Open source, because art should be free.

---

*Membawa seni desa ke blockchain, satu NFT dalam satu waktu. 🎨*
