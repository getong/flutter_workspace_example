import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_solana/data/repositories/frb_solana_bridge_repository.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_solana/domain/entities/solana_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_solana/domain/repositories/solana_bridge_repository.dart';

@RoutePage(name: RouteName.flutterRustBridgeSolana)
class FlutterRustBridgeSolanaPage extends StatefulWidget {
  const FlutterRustBridgeSolanaPage({super.key});

  @override
  State<FlutterRustBridgeSolanaPage> createState() =>
      _FlutterRustBridgeSolanaPageState();
}

class _FlutterRustBridgeSolanaPageState
    extends State<FlutterRustBridgeSolanaPage> {
  _FlutterRustBridgeSolanaPageState({SolanaBridgeRepository? repository})
    : _repository = repository ?? FrbSolanaBridgeRepository();

  final SolanaBridgeRepository _repository;
  final TextEditingController _rpcController = TextEditingController(
    text: 'https://api.mainnet-beta.solana.com',
  );
  final TextEditingController _walletController = TextEditingController(
    text: 'Vote111111111111111111111111111111111111111',
  );

  SolanaDemoSnapshot? _snapshot;
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
      final SolanaDemoSnapshot snapshot = await _repository.fetchSnapshot(
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
      appBar: AppBar(title: const Text('flutter_rust_bridge + solana Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'This module demonstrates a clean-architecture integration where Flutter calls Rust through flutter_rust_bridge, and Rust uses Solana RPC crates to read Solana chain data.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The practical effect is similar to the Ethereum example: Flutter keeps UI and feature boundaries, while Rust owns typed blockchain access. This time the target chain is Solana.',
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
                      'Solana read-only demo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The Rust side fetches latest slot, block height, epoch, transaction count, and wallet SOL balance from a Solana RPC endpoint.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _rpcController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Solana RPC URL',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _walletController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Wallet / account address',
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
                          label: Text(
                            _loading ? 'Loading...' : 'Fetch Solana Data',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _loading
                              ? null
                              : () {
                                  _rpcController.text =
                                      'https://api.mainnet-beta.solana.com';
                                  _walletController.text =
                                      'Vote111111111111111111111111111111111111111';
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
            const _SolanaInfoCard(),
            if (_snapshot != null) ...<Widget>[
              const SizedBox(height: 16),
              _ResultCard(
                title: 'Chain state',
                rows: <_ResultRow>[
                  _ResultRow(label: 'RPC', value: _snapshot!.rpcUrl),
                  _ResultRow(
                    label: 'Latest slot',
                    value: '${_snapshot!.latestSlot}',
                  ),
                  _ResultRow(
                    label: 'Block height',
                    value: '${_snapshot!.blockHeight}',
                  ),
                  _ResultRow(label: 'Epoch', value: '${_snapshot!.epoch}'),
                  _ResultRow(
                    label: 'Transaction count',
                    value:
                        _snapshot!.transactionCount?.toString() ??
                        'Unavailable',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ResultCard(
                title: 'Wallet SOL balance',
                rows: <_ResultRow>[
                  _ResultRow(label: 'Wallet', value: _snapshot!.walletAddress),
                  _ResultRow(
                    label: 'Lamports',
                    value: '${_snapshot!.lamports}',
                  ),
                  _ResultRow(label: 'SOL', value: _snapshot!.solBalance),
                  _ResultRow(label: 'Commitment', value: _snapshot!.commitment),
                ],
              ),
              const SizedBox(height: 16),
              _ResultCard(
                title: 'What this shows',
                rows: <_ResultRow>[
                  _ResultRow(
                    label: 'Explanation',
                    value: _snapshot!.explanation,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _SolanaInfoCard extends StatelessWidget {
  const _SolanaInfoCard();

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
              'Why use flutter_rust_bridge + Rust + Solana crates',
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
                  label: 'Typed Solana RPC access',
                ),
                _UseCaseChip(
                  icon: Icons.payments_outlined,
                  label: 'Read SOL balances',
                ),
                _UseCaseChip(
                  icon: Icons.timeline_outlined,
                  label: 'Read slot and epoch state',
                ),
                _UseCaseChip(
                  icon: Icons.layers_outlined,
                  label: 'Keep Flutter UI separate',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'In this feature, Flutter owns the page and repository boundary, flutter_rust_bridge owns the FFI glue, and Rust owns the Solana RPC logic and crate integration.',
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
