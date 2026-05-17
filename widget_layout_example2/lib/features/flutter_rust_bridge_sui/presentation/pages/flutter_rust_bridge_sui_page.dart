import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_sui/data/repositories/frb_sui_bridge_repository.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_sui/domain/entities/sui_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_sui/domain/repositories/sui_bridge_repository.dart';

@RoutePage(name: RouteName.flutterRustBridgeSui)
class FlutterRustBridgeSuiPage extends StatefulWidget {
  const FlutterRustBridgeSuiPage({super.key});

  @override
  State<FlutterRustBridgeSuiPage> createState() =>
      _FlutterRustBridgeSuiPageState();
}

class _FlutterRustBridgeSuiPageState extends State<FlutterRustBridgeSuiPage> {
  _FlutterRustBridgeSuiPageState({SuiBridgeRepository? repository})
    : _repository = repository ?? FrbSuiBridgeRepository();

  final SuiBridgeRepository _repository;
  final TextEditingController _rpcController = TextEditingController(
    text: 'https://fullnode.mainnet.sui.io:443',
  );
  final TextEditingController _walletController = TextEditingController(
    text: '0x0000000000000000000000000000000000000000000000000000000000000002',
  );

  SuiDemoSnapshot? _snapshot;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _rpcController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final SuiDemoSnapshot snapshot = await _repository.fetchSnapshot(
        rpcUrl: _rpcController.text.trim(),
        walletAddress: _walletController.text.trim(),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _snapshot = snapshot;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_rust_bridge + sui Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'This module demonstrates a clean-architecture integration where Flutter calls Rust through flutter_rust_bridge, and Rust uses the Sui Rust SDK to read Sui network and account data.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'The example is intentionally read-only and low-friction: it fetches API version, current epoch state, gas price, validator count, and basic address-related counts from a Sui fullnode RPC endpoint.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sui read-only demo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The Rust side creates a Sui client, reads network metadata, governance info, and address-related counts, then returns plain data back to Flutter.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _rpcController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sui fullnode RPC URL',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _walletController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sui address',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _loading ? null : _load,
                        icon: const Icon(Icons.cloud_sync_outlined),
                        label: Text(_loading ? 'Loading...' : 'Fetch Sui Data'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loading
                            ? null
                            : () {
                                _rpcController.text =
                                    'https://fullnode.mainnet.sui.io:443';
                                _walletController.text =
                                    '0x0000000000000000000000000000000000000000000000000000000000000002';
                                _load();
                              },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset Sample'),
                      ),
                    ],
                  ),
                  if (_error != null) ...<Widget>[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SuiInfoCard(),
          if (_snapshot != null) ...<Widget>[
            const SizedBox(height: 16),
            _ResultCard(
              title: 'Network state',
              rows: <_ResultRow>[
                _ResultRow(label: 'RPC', value: _snapshot!.rpcUrl),
                _ResultRow(label: 'API version', value: _snapshot!.apiVersion),
                _ResultRow(
                  label: 'RPC methods',
                  value: _snapshot!.rpcMethodsCount,
                ),
                _ResultRow(
                  label: 'Current epoch',
                  value: _snapshot!.currentEpoch,
                ),
                _ResultRow(
                  label: 'Reference gas price',
                  value: _snapshot!.referenceGasPrice,
                ),
                _ResultRow(
                  label: 'Active validators',
                  value: _snapshot!.activeValidators,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ResultCard(
              title: 'Address-related counts',
              rows: <_ResultRow>[
                _ResultRow(label: 'Address', value: _snapshot!.walletAddress),
                _ResultRow(
                  label: 'Owned objects in page',
                  value: _snapshot!.ownedObjectsInPage,
                ),
                _ResultRow(
                  label: 'Stake positions',
                  value: _snapshot!.stakePositionCount,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ResultCard(
              title: 'What this shows',
              rows: <_ResultRow>[
                _ResultRow(label: 'Explanation', value: _snapshot!.explanation),
              ],
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _SuiInfoCard extends StatelessWidget {
  const _SuiInfoCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Why use flutter_rust_bridge + Rust + Sui SDK',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const <Widget>[
                _UseCaseChip(
                  icon: Icons.hub_outlined,
                  label: 'Typed Sui RPC access',
                ),
                _UseCaseChip(
                  icon: Icons.view_in_ar_outlined,
                  label: 'Read epoch and validator state',
                ),
                _UseCaseChip(
                  icon: Icons.inventory_2_outlined,
                  label: 'Count owned objects and stakes',
                ),
                _UseCaseChip(
                  icon: Icons.layers_outlined,
                  label: 'Keep Flutter UI separate',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'In this feature, Flutter owns the page and repository boundary, flutter_rust_bridge owns the FFI glue, and Rust owns the Sui SDK integration and RPC reading logic.',
            ),
          ],
        ),
      ),
    );
  }
}

class _UseCaseChip extends StatelessWidget {
  const _UseCaseChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.title, required this.rows});

  final String title;
  final List<_ResultRow> rows;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ...rows.map((_ResultRow row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      row.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      row.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ResultRow {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;
}
