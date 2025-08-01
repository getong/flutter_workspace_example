# Sui Flutter Example App

This Flutter application demonstrates how to interact with the Sui blockchain using the `on_chain` package. It includes wallet management, balance checking, token transfers, and object viewing functionality.

## Features

- Initialize wallet with private key
- View wallet address and balance
- Request testnet/devnet airdrops
- Transfer SUI tokens
- View owned objects
- Support for both local devnet and remote networks

## Prerequisites

1. **Flutter SDK** installed (3.8.1 or higher)
2. **Sui CLI** installed for running local devnet
3. **Dart SDK** compatible with Flutter version

## Setting up Sui Local Devnet

1. Install Sui CLI if you haven't already:
```bash
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui
```

2. Start the local Sui network:
```bash
sui start --force-regenesis
```

This will start a local Sui network on `http://127.0.0.1:9000`

3. The local network will provide you with test accounts and private keys. You can use these or the default one provided in the app.

## Running the Flutter App

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## App Structure

- **lib/config/sui_config.dart** - Sui network configuration
- **lib/services/sui_service.dart** - Core Sui blockchain interactions
- **lib/screens/wallet_screen.dart** - Wallet management UI
- **lib/screens/objects_screen.dart** - View owned objects
- **lib/main.dart** - App entry point and navigation

## Usage

1. **Initialize Wallet**: 
   - Launch the app
   - Enter a private key or use the default one
   - Click "Initialize Wallet"

2. **Request Airdrop**:
   - After wallet initialization
   - Click "Request Airdrop" to receive test SUI tokens

3. **Transfer SUI**:
   - Enter recipient address
   - Enter amount in MIST (1 SUI = 1,000,000,000 MIST)
   - Click "Send Transaction"

4. **View Objects**:
   - Navigate to the "Objects" tab
   - View all objects owned by your wallet

## Network Configuration

By default, the app connects to local devnet (`http://127.0.0.1:9000`). To use testnet or devnet, modify the `useLocalDevnet` parameter in:
- `lib/screens/wallet_screen.dart`
- `lib/main.dart`

## Important Notes

- Always ensure your local Sui devnet is running before using the app in local mode
- The default private key is for testing only - never use it on mainnet
- Transaction amounts are in MIST (smallest unit of SUI)
- The app currently supports basic SUI transfers and object viewing
