import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_ethereum/data/repositories/frb_ethereum_bridge_repository.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_ethereum/domain/entities/ethereum_demo_snapshot.dart';
import 'package:widget_layout_example2/features/flutter_rust_bridge_ethereum/domain/repositories/ethereum_bridge_repository.dart';

@RoutePage(name: RouteName.flutterRustBridgeEthereum)
class FlutterRustBridgeEthereumPage extends StatefulWidget {
  const FlutterRustBridgeEthereumPage({super.key});

  @override
  State<FlutterRustBridgeEthereumPage> createState() =>
      _FlutterRustBridgeEthereumPageState();
}

class _FlutterRustBridgeEthereumPageState
    extends State<FlutterRustBridgeEthereumPage> {
  _FlutterRustBridgeEthereumPageState({EthereumBridgeRepository? repository})
    : _repository = repository ?? FrbEthereumBridgeRepository();

  final EthereumBridgeRepository _repository;
  final TextEditingController _rpcController = TextEditingController(
    text: 'https://ethereum-rpc.publicnode.com',
  );
  final TextEditingController _walletController = TextEditingController(
    text: '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045',
  );
  final TextEditingController _tokenController = TextEditingController(
    text: '0xA0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
  );

  EthereumDemoSnapshot? _snapshot;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _rpcController.dispose();
    _walletController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final EthereumDemoSnapshot snapshot = await _repository.fetchSnapshot(
        rpcUrl: _rpcController.text.trim(),
        walletAddress: _walletController.text.trim(),
        erc20TokenAddress: _tokenController.text.trim(),
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
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_rust_bridge + alloy Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'This module demonstrates a clean-architecture integration where Flutter calls Rust through flutter_rust_bridge, and Rust uses alloy to read Ethereum chain data.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'The practical effect is that Flutter keeps the UI and feature wiring, while Rust handles typed blockchain access. This is useful when you want performance, Rust ecosystem crates, or shared native logic beyond Dart.',
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
                    'Ethereum read-only demo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The Rust side fetches latest block number, native ETH balance, and ERC-20 token metadata/balance from a public RPC endpoint using alloy.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _rpcController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ethereum RPC URL',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _walletController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Wallet address',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ERC-20 token address',
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
                          _loading ? 'Loading...' : 'Fetch On-chain Data',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loading
                            ? null
                            : () {
                                _rpcController.text =
                                    'https://ethereum-rpc.publicnode.com';
                                _walletController.text =
                                    '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045';
                                _tokenController.text =
                                    '0xA0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
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
          const _FrbInfoCard(),
          if (_snapshot != null) ...<Widget>[
            const SizedBox(height: 16),
            _ResultCard(
              title: 'Chain state',
              rows: <_ResultRow>[
                _ResultRow(label: 'RPC', value: _snapshot!.rpcUrl),
                _ResultRow(
                  label: 'Latest block',
                  value: _snapshot!.latestBlockNumber,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ResultCard(
              title: 'Wallet native balance',
              rows: <_ResultRow>[
                _ResultRow(label: 'Wallet', value: _snapshot!.walletAddress),
                _ResultRow(
                  label: 'Balance (wei)',
                  value: _snapshot!.nativeBalanceWei,
                ),
                _ResultRow(
                  label: 'Balance (ETH)',
                  value: _snapshot!.nativeBalanceEth,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ResultCard(
              title: 'ERC-20 token balance',
              rows: <_ResultRow>[
                _ResultRow(label: 'Token', value: _snapshot!.tokenAddress),
                _ResultRow(label: 'Symbol', value: _snapshot!.tokenSymbol),
                _ResultRow(
                  label: 'Decimals',
                  value: '${_snapshot!.tokenDecimals}',
                ),
                _ResultRow(
                  label: 'Raw balance',
                  value: _snapshot!.tokenBalanceRaw,
                ),
                _ResultRow(
                  label: 'Formatted balance',
                  value: _snapshot!.tokenBalanceFormatted,
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

class _FrbInfoCard extends StatelessWidget {
  const _FrbInfoCard();

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
              'Why use flutter_rust_bridge + Rust + alloy',
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
                  icon: Icons.link_outlined,
                  label: 'Typed Ethereum RPC access',
                ),
                _UseCaseChip(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Wallet and token reads',
                ),
                _UseCaseChip(
                  icon: Icons.memory_outlined,
                  label: 'Rust ecosystem integration',
                ),
                _UseCaseChip(
                  icon: Icons.layers_outlined,
                  label: 'Keep Flutter UI separate',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'In this feature, Flutter owns the page and repository boundary, flutter_rust_bridge owns the FFI glue, Rust owns the blockchain request logic, and alloy provides typed Ethereum primitives and provider APIs.',
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
