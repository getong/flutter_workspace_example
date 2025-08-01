import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sui_service_final.dart';

class WalletScreenFinal extends StatefulWidget {
  final SuiServiceFinal suiService;

  const WalletScreenFinal({super.key, required this.suiService});

  @override
  State<WalletScreenFinal> createState() => _WalletScreenFinalState();
}

class _WalletScreenFinalState extends State<WalletScreenFinal> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  BigInt _balance = BigInt.zero;
  bool _isLoading = false;
  String _errorMessage = '';
  String? _walletAddress;

  @override
  void initState() {
    super.initState();
    _initializeWallet();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _initializeWallet() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await widget.suiService.initializeWallet();
      _walletAddress = widget.suiService.address;
      await _refreshBalance();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize wallet: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshBalance() async {
    if (_walletAddress == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final balance = await widget.suiService.getBalance();
      setState(() {
        _balance = balance;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to refresh balance: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestAirdrop() async {
    if (_walletAddress == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await widget.suiService.requestAirdrop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Airdrop requested successfully!')),
        );
      }
      // Wait a moment then refresh balance
      await Future.delayed(const Duration(seconds: 2));
      await _refreshBalance();
    } catch (e) {
      setState(() {
        _errorMessage = 'Airdrop failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _transferSui() async {
    if (_walletAddress == null) return;

    final recipient = _recipientController.text.trim();
    final amountText = _amountController.text.trim();

    if (recipient.isEmpty || amountText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter recipient address and amount';
      });
      return;
    }

    final amount = BigInt.tryParse(amountText);
    if (amount == null || amount <= BigInt.zero) {
      setState(() {
        _errorMessage = 'Please enter a valid amount';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final txHash = await widget.suiService.transferSui(
        recipientAddress: recipient,
        amount: amount,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer successful! TX: $txHash')),
        );
      }

      _recipientController.clear();
      _amountController.clear();
      await _refreshBalance();
    } catch (e) {
      setState(() {
        _errorMessage = 'Transfer failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sui Wallet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshBalance,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Address: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            _walletAddress ?? 'Not initialized',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: _walletAddress != null
                              ? () {
                                  Clipboard.setData(
                                    ClipboardData(text: _walletAddress!),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Address copied!'),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Balance: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$_balance MIST'),
                        const SizedBox(width: 8),
                        Text(
                          '(${(_balance / BigInt.from(1000000000)).toStringAsFixed(4)} SUI)',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Request Test Tokens',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get test SUI tokens from the local devnet faucet',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _requestAirdrop,
                      child: const Text('Request Airdrop'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Transfer SUI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _recipientController,
                      decoration: const InputDecoration(
                        labelText: 'Recipient Address',
                        hintText: '0x...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (MIST)',
                        hintText: '1000000000',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _transferSui,
                      child: const Text('Send Transfer'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Using on_chain Package',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This wallet demonstrates comprehensive Sui blockchain integration using the on_chain package. Features include wallet initialization, balance checking, faucet requests, and transfer functionality via direct RPC calls.',
                    ),
                  ],
                ),
              ),
            ),

            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),
            ],

            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
