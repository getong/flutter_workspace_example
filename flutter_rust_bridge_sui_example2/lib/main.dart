import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_sui_example2/src/rust/api/simple.dart';
import 'package:flutter_rust_bridge_sui_example2/src/rust/frb_generated.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter -> Rust -> Sui',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A6E8A)),
      ),
      home: const SuiBridgePage(),
    );
  }
}

class SuiBridgePage extends StatefulWidget {
  const SuiBridgePage({super.key});

  @override
  State<SuiBridgePage> createState() => _SuiBridgePageState();
}

class _SuiBridgePageState extends State<SuiBridgePage> {
  final TextEditingController _networkController = TextEditingController(
    text: 'mainnet',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '0x2',
  );

  String _networkResult = '';
  String _addressResult = '';
  bool _networkLoading = false;

  @override
  void dispose() {
    _networkController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchApiVersion() async {
    setState(() {
      _networkLoading = true;
      _networkResult = '';
    });

    try {
      final result = await hello(a: _networkController.text);
      if (!mounted) {
        return;
      }
      setState(() {
        _networkResult = result;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _networkResult = 'Rust call error: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _networkLoading = false;
        });
      }
    }
  }

  void _normalizeAddress() {
    final result = greet(name: _addressController.text);
    setState(() {
      _addressResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter -> Rust -> Sui')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('通过 flutter_rust_bridge 调用 Rust，并由 Rust 访问 Sui 网络。'),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1) 查询 Sui API 版本',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '输入 mainnet/testnet/devnet/localnet，或者完整 RPC URL。',
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _networkController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sui network or RPC URL',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: _networkLoading ? null : _fetchApiVersion,
                    child: Text(
                      _networkLoading ? '查询中...' : 'Flutter -> Rust -> Sui',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    _networkResult.isEmpty ? '结果会显示在这里' : _networkResult,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2) Sui 地址规范化',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sui address',
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _normalizeAddress,
                    child: const Text('调用 Rust 地址转换'),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    _addressResult.isEmpty ? '结果会显示在这里' : _addressResult,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
