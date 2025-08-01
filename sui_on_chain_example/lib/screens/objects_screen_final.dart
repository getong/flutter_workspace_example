import 'package:flutter/material.dart';
import '../services/sui_service_final.dart';

class ObjectsScreenFinal extends StatefulWidget {
  final SuiServiceFinal suiService;

  const ObjectsScreenFinal({super.key, required this.suiService});

  @override
  State<ObjectsScreenFinal> createState() => _ObjectsScreenFinalState();
}

class _ObjectsScreenFinalState extends State<ObjectsScreenFinal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _objects = [];
  List<Map<String, dynamic>> _coins = [];
  BigInt _balance = BigInt.zero;

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    if (widget.suiService.address == null) {
      await widget.suiService.initializeWallet();
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load objects, coins, and balance
      final futures = await Future.wait([
        widget.suiService.getOwnedObjects(),
        widget.suiService.getCoins(),
        widget.suiService.getBalance(),
      ]);

      final objectsResponse = futures[0] as List<Map<String, dynamic>>;
      final coinsResponse = futures[1] as List<Map<String, dynamic>>;
      final balanceResponse = futures[2] as BigInt;

      setState(() {
        _objects = objectsResponse;
        _coins = coinsResponse;
        _balance = balanceResponse;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildObjectsTab() {
    if (_objects.isEmpty) {
      return const Center(child: Text('No objects found'));
    }

    return ListView.builder(
      itemCount: _objects.length,
      itemBuilder: (context, index) {
        final objectWrapper = _objects[index];
        final object = objectWrapper['data'] as Map<String, dynamic>?;

        if (object == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text(
              'Object: ${(object['objectId'] ?? 'Unknown').toString().substring(0, 16)}...',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${object['type'] ?? 'Unknown'}'),
                Text('Version: ${object['version'] ?? 'Unknown'}'),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      'Object ID',
                      object['objectId']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Digest',
                      object['digest']?.toString() ?? 'Unknown',
                    ),
                    _buildInfoRow(
                      'Owner',
                      object['owner']?.toString() ?? 'Unknown',
                    ),
                    if (object['storageRebate'] != null)
                      _buildInfoRow(
                        'Storage Rebate',
                        object['storageRebate'].toString(),
                      ),
                    if (object['content'] != null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Content:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          object['content'].toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoinsTab() {
    if (_coins.isEmpty) {
      return const Center(child: Text('No coins found'));
    }

    return ListView.builder(
      itemCount: _coins.length,
      itemBuilder: (context, index) {
        final coin = _coins[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.monetization_on),
            title: Text('${coin['balance'] ?? '0'} MIST'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Object ID: ${(coin['coinObjectId'] ?? 'Unknown').toString().substring(0, 16)}...',
                ),
                Text('Version: ${coin['version'] ?? 'Unknown'}'),
                Text(
                  'Digest: ${(coin['digest'] ?? 'Unknown').toString().substring(0, 16)}...',
                ),
              ],
            ),
            trailing: Text(coin['coinType']?.toString() ?? 'Unknown'),
          ),
        );
      },
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Total Balance', '$_balance MIST'),
                  _buildInfoRow(
                    'Number of Objects',
                    _objects.length.toString(),
                  ),
                  _buildInfoRow('Number of Coins', _coins.length.toString()),
                  _buildInfoRow(
                    'Wallet Address',
                    widget.suiService.address ?? 'Not initialized',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Objects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._objects.take(3).map((objWrapper) {
                    final obj = objWrapper['data'] as Map<String, dynamic>?;
                    if (obj == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.inventory_2, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${(obj['objectId'] ?? 'Unknown').toString().substring(0, 16)}...',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            obj['type']?.toString().split('::').last ??
                                'Object',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_objects.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '... and ${_objects.length - 3} more objects',
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                    'This app demonstrates using the on_chain package to interact with the Sui blockchain via RPC calls. It includes wallet management, balance checking, object exploration, and transaction monitoring.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
        title: const Text('Blockchain Explorer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadAllData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Objects'),
            Tab(text: 'Coins'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAllData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildObjectsTab(),
                _buildCoinsTab(),
              ],
            ),
    );
  }
}
