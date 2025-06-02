import 'package:flutter/material.dart';
import 'package:solana/solana.dart';
import 'package:solana/dto.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solana Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SolanaHomePage(title: 'Solana Flutter Demo'),
    );
  }
}

class SolanaHomePage extends StatefulWidget {
  const SolanaHomePage({super.key, required this.title});

  final String title;

  @override
  State<SolanaHomePage> createState() => _SolanaHomePageState();
}

class _SolanaHomePageState extends State<SolanaHomePage> {
  late SolanaClient _solanaClient;
  Wallet? _wallet;
  double _balance = 0.0;
  bool _isLoading = false;
  String _status = 'Disconnected';
  static const Duration _networkTimeout = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    _initializeSolana();
  }

  void _initializeSolana() {
    // Initialize Solana client with devnet
    _solanaClient = SolanaClient(
      rpcUrl: Uri.parse('https://api.devnet.solana.com'),
      websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
    );
    _generateWallet();
  }

  Future<void> _generateWallet() async {
    setState(() {
      _isLoading = true;
      _status = 'Generating wallet...';
    });

    try {
      // Generate a new wallet
      final mnemonic = bip39.generateMnemonic();
      _wallet = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
      
      setState(() {
        _status = 'Wallet generated';
        _isLoading = false;
      });
      
      _getBalance();
    } catch (e) {
      setState(() {
        _status = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _getBalance() async {
    if (_wallet == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Fetching balance...';
    });

    try {
      final balance = await _solanaClient.rpcClient
          .getBalance(_wallet!.address)
          .timeout(_networkTimeout);
      setState(() {
        _balance = balance.value / lamportsPerSol;
        _status = 'Connected to Solana Devnet';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = e.toString().contains('TimeoutException') 
            ? 'Error: Network timeout after ${_networkTimeout.inSeconds}s'
            : 'Error fetching balance: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _requestAirdrop() async {
    if (_wallet == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Requesting airdrop...';
    });

    try {
      final signature = await _solanaClient.rpcClient
          .requestAirdrop(
            _wallet!.address,
            lamportsPerSol, // 1 SOL
          )
          .timeout(_networkTimeout);
      
      setState(() {
        _status = 'Airdrop requested: $signature';
      });
      
      // Wait a moment then refresh balance
      await Future.delayed(const Duration(seconds: 2));
      await _getBalance();
    } catch (e) {
      setState(() {
        _status = e.toString().contains('TimeoutException')
            ? 'Airdrop failed: Network timeout after ${_networkTimeout.inSeconds}s'
            : 'Airdrop failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (_wallet != null) ...[
                      Text('Address: ${_wallet!.address}'),
                      const SizedBox(height: 8),
                      Text(
                        'Balance: ${_balance.toStringAsFixed(4)} SOL',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Status: $_status',
                      style: TextStyle(
                        color: _status.contains('Error') ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: _generateWallet,
                    child: const Text('New Wallet'),
                  ),
                  ElevatedButton(
                    onPressed: _getBalance,
                    child: const Text('Refresh Balance'),
                  ),
                  ElevatedButton(
                    onPressed: _requestAirdrop,
                    child: const Text('Request Airdrop'),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About This Demo',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '• This demo connects to Solana Devnet\n'
                        '• Generate a new wallet with a random keypair\n'
                        '• Check wallet balance\n'
                        '• Request SOL airdrop (devnet only)\n'
                        '• All operations use the solana dart package',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
