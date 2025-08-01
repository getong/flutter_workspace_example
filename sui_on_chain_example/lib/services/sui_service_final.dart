import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SuiServiceFinal {
  final String nodeUrl;
  String? _address;

  SuiServiceFinal({bool useLocalDevnet = true})
    : nodeUrl = useLocalDevnet
          ? 'http://192.168.31.136:9000'
          : 'https://fullnode.devnet.sui.io:443';

  Future<void> initializeWallet([String? privateKeyHex]) async {
    try {
      // For demo purposes, use a fixed test address
      _address =
          privateKeyHex ??
          '0x4ec5a9eefc0bb86027a6f3ba718793957de73d3a7a0c45ee0e5c92a7f3c1a2e7';

      if (!_address!.startsWith('0x')) {
        _address = '0x$_address';
      }
    } catch (e) {
      throw Exception('Failed to initialize wallet: $e');
    }
  }

  String? get address => _address;

  // Get balance using direct RPC call
  Future<BigInt> getBalance() async {
    if (_address == null) {
      throw Exception('Wallet not initialized');
    }

    try {
      final response = await _makeRpcCall('suix_getBalance', [_address]);
      final totalBalance = response['result']['totalBalance'] as String;
      return BigInt.parse(totalBalance);
    } catch (e) {
      throw Exception('Failed to get balance: $e');
    }
  }

  // Get all balances using direct RPC call
  Future<List<Map<String, dynamic>>> getAllBalances() async {
    if (_address == null) {
      throw Exception('Wallet not initialized');
    }

    try {
      final response = await _makeRpcCall('suix_getAllBalances', [_address]);
      return List<Map<String, dynamic>>.from(response['result']);
    } catch (e) {
      throw Exception('Failed to get all balances: $e');
    }
  }

  // Get coins using direct RPC call
  Future<List<Map<String, dynamic>>> getCoins() async {
    if (_address == null) {
      throw Exception('Wallet not initialized');
    }

    try {
      final response = await _makeRpcCall('suix_getCoins', [_address]);
      return List<Map<String, dynamic>>.from(response['result']['data']);
    } catch (e) {
      throw Exception('Failed to get coins: $e');
    }
  }

  // Get owned objects using direct RPC call
  Future<List<Map<String, dynamic>>> getOwnedObjects() async {
    if (_address == null) {
      throw Exception('Wallet not initialized');
    }

    try {
      final response = await _makeRpcCall('suix_getOwnedObjects', [
        _address,
        {
          'showContent': true,
          'showDisplay': true,
          'showMetadata': true,
          'showOwner': true,
          'showPreviousTransaction': true,
          'showStorageRebate': true,
          'showType': true,
        },
      ]);
      return List<Map<String, dynamic>>.from(response['result']['data']);
    } catch (e) {
      throw Exception('Failed to get owned objects: $e');
    }
  }

  // Get object details using direct RPC call
  Future<Map<String, dynamic>?> getObject(String objectId) async {
    try {
      final response = await _makeRpcCall('sui_getObject', [
        objectId,
        {
          'showContent': true,
          'showDisplay': true,
          'showMetadata': true,
          'showOwner': true,
          'showPreviousTransaction': true,
          'showStorageRebate': true,
          'showType': true,
        },
      ]);
      return response['result'];
    } catch (e) {
      throw Exception('Failed to get object: $e');
    }
  }

  // Get transaction details using direct RPC call
  Future<Map<String, dynamic>?> getTransactionBlock(String digest) async {
    try {
      final response = await _makeRpcCall('sui_getTransactionBlock', [
        digest,
        {
          'showBalanceChanges': true,
          'showEffects': true,
          'showEvents': true,
          'showInput': true,
          'showObjectChanges': true,
          'showRawInput': true,
        },
      ]);
      return response['result'];
    } catch (e) {
      throw Exception('Failed to get transaction block: $e');
    }
  }

  // Get current gas price using direct RPC call
  Future<BigInt> getReferenceGasPrice() async {
    try {
      final response = await _makeRpcCall('suix_getReferenceGasPrice', []);
      return BigInt.parse(response['result'].toString());
    } catch (e) {
      throw Exception('Failed to get gas price: $e');
    }
  }

  // Request airdrop using HTTP call to faucet
  Future<void> requestAirdrop() async {
    if (_address == null) {
      throw Exception('Wallet not initialized');
    }

    try {
      // Try multiple faucet endpoints
      final faucetEndpoints = [
        'http://192.168.31.136:9123/gas',
        'http://192.168.31.136:5003/gas',
        'http://192.168.31.136:9123/gas',
      ];

      bool success = false;
      String lastError = '';

      for (final endpoint in faucetEndpoints) {
        try {
          final url = Uri.parse(endpoint);
          final response = await http
              .post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'FixedAmountRequest': {'recipient': _address},
                }),
              )
              .timeout(const Duration(seconds: 5));

          if (response.statusCode == 201 || response.statusCode == 200) {
            success = true;
            break;
          }
          lastError = 'HTTP ${response.statusCode}: ${response.body}';
        } catch (e) {
          lastError = e.toString();
          continue;
        }
      }

      if (!success) {
        // Try RPC-based faucet as final fallback
        try {
          await _makeRpcCall('sui_requestFaucet', [_address]);
        } catch (rpcError) {
          throw Exception(
            'All faucet endpoints failed. Last error: $lastError',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to request airdrop: $e');
    }
  }

  // Mock transfer (returns fake transaction hash)
  Future<String> transferSui({
    required String recipientAddress,
    required BigInt amount,
  }) async {
    if (_address == null) {
      throw Exception('Wallet not initialized');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock transaction hash
    return '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}mock${amount.toString()}';
  }

  // Generate mock wallet data
  static Future<Map<String, String>> generateWalletFromMnemonic({
    String? mnemonic,
  }) async {
    // Generate mock data
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'mnemonic':
          mnemonic ??
          'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about',
      'privateKey': '0x${timestamp.toRadixString(16).padLeft(64, '0')}',
      'address': '0x${(timestamp * 2).toRadixString(16).padLeft(64, '0')}',
    };
  }

  // Make direct RPC call without on_chain package dependencies
  Future<Map<String, dynamic>> _makeRpcCall(
    String method,
    List<dynamic> params,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(nodeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': method,
          'params': params,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception('RPC error: ${data['error']['message']}');
      }

      return data;
    } catch (e) {
      throw Exception('RPC call failed: $e');
    }
  }
}
