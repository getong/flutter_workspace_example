import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sui_service_final.dart';

class TransactionMonitorFinal extends StatefulWidget {
  final SuiServiceFinal suiService;

  const TransactionMonitorFinal({super.key, required this.suiService});

  @override
  State<TransactionMonitorFinal> createState() =>
      _TransactionMonitorFinalState();
}

class _TransactionMonitorFinalState extends State<TransactionMonitorFinal> {
  final TextEditingController _digestController = TextEditingController();
  final TextEditingController _objectIdController = TextEditingController();

  Map<String, dynamic>? _transactionDetails;
  Map<String, dynamic>? _objectDetails;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _digestController.dispose();
    _objectIdController.dispose();
    super.dispose();
  }

  Future<void> _getTransactionDetails() async {
    final digest = _digestController.text.trim();
    if (digest.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a transaction digest';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _transactionDetails = null;
    });

    try {
      final details = await widget.suiService.getTransactionBlock(digest);
      setState(() {
        _transactionDetails = details;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get transaction: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getObjectDetails() async {
    final objectId = _objectIdController.text.trim();
    if (objectId.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an object ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _objectDetails = null;
    });

    try {
      final details = await widget.suiService.getObject(objectId);
      setState(() {
        _objectDetails = details;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get object: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTransactionDetailsCard() {
    if (_transactionDetails == null) return const SizedBox.shrink();

    final tx = _transactionDetails!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Transaction Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: tx['digest']?.toString() ?? ''),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Digest copied!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Digest', tx['digest']?.toString() ?? 'Unknown'),
            if (tx['timestampMs'] != null)
              _buildInfoRow(
                'Timestamp',
                DateTime.fromMillisecondsSinceEpoch(
                  tx['timestampMs'] as int,
                ).toString(),
              ),
            if (tx['effects'] != null)
              _buildInfoRow(
                'Status',
                (tx['effects'] as Map<String, dynamic>)['status']?.toString() ??
                    'Unknown',
              ),
            if (tx['effects'] != null &&
                (tx['effects'] as Map<String, dynamic>)['gasUsed'] != null)
              _buildInfoRow(
                'Gas Used',
                (tx['effects'] as Map<String, dynamic>)['gasUsed'].toString(),
              ),
            if (tx['balanceChanges'] != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Balance Changes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...(tx['balanceChanges'] as List)
                  .take(3)
                  .map(
                    (change) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        '${change['coinType'] ?? 'Unknown'}: ${change['amount'] ?? '0'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Transaction data retrieved via on_chain package',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectDetailsCard() {
    if (_objectDetails == null) return const SizedBox.shrink();

    final obj = _objectDetails!;
    final data = obj['data'] as Map<String, dynamic>?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Object Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: data?['objectId']?.toString() ?? ''),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Object ID copied!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (data != null) ...[
              _buildInfoRow(
                'Object ID',
                data['objectId']?.toString() ?? 'Unknown',
              ),
              _buildInfoRow(
                'Version',
                data['version']?.toString() ?? 'Unknown',
              ),
              _buildInfoRow('Digest', data['digest']?.toString() ?? 'Unknown'),
              if (data['type'] != null)
                _buildInfoRow('Type', data['type'].toString()),
              if (data['owner'] != null)
                _buildInfoRow('Owner', data['owner'].toString()),
              if (data['storageRebate'] != null)
                _buildInfoRow(
                  'Storage Rebate',
                  data['storageRebate'].toString(),
                ),
              if (data['display'] != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Display Properties:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data['display'].toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              const Text(
                'Object data retrieved via on_chain package',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ] else ...[
              const Text(
                'Object not found or has no data',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Monitor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                      'Query Transaction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _digestController,
                      decoration: const InputDecoration(
                        labelText: 'Transaction Digest',
                        hintText: 'Enter transaction hash/digest',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _getTransactionDetails,
                      child: const Text('Get Transaction Details'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Query Object',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _objectIdController,
                      decoration: const InputDecoration(
                        labelText: 'Object ID',
                        hintText: 'Enter object identifier',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _getObjectDetails,
                      child: const Text('Get Object Details'),
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
                          'on_chain Package Integration',
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
                      'This monitor uses the on_chain package to make RPC calls to the Sui blockchain. It demonstrates querying transaction blocks and objects using direct HTTP RPC calls.',
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

            if (_transactionDetails != null) ...[
              const SizedBox(height: 16),
              _buildTransactionDetailsCard(),
            ],

            if (_objectDetails != null) ...[
              const SizedBox(height: 16),
              _buildObjectDetailsCard(),
            ],
          ],
        ),
      ),
    );
  }
}
