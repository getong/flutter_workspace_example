import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/web3_bloc.dart';
import '../bloc/web3_event.dart';
import '../bloc/web3_state.dart';
import '../models/web3_demo_models.dart';
import '../services/web3_demo_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _addressController;
  late final TextEditingController _tokenController;
  late final TextEditingController _privateKeyController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: Web3DemoService.sampleAddress);
    _tokenController =
        TextEditingController(text: Web3DemoService.sampleTokenAddress);
    _privateKeyController =
        TextEditingController(text: Web3DemoService.samplePrivateKey);
    _messageController =
        TextEditingController(text: Web3DemoService.samplePersonalMessage);

    context.read<Web3Bloc>().add(const LoadWeb3Overview());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Reload all demos',
            onPressed: () {
              context.read<Web3Bloc>().add(const LoadWeb3Overview());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<Web3Bloc, Web3State>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(context, state),
              const SizedBox(height: 16),
              _buildControls(context),
              const SizedBox(height: 16),
              if (state.overviewError != null)
                _ErrorBanner(message: state.overviewError!),
              if (state.isOverviewLoading && state.sections.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ...state.orderedSections.map(_buildSectionCard),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Web3State state) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'web3dart 功能演示台',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '当前页面尽量覆盖 web3dart 的常见能力：节点访问、账户查询、合约 ABI 编码、只读调用、日志读取、消息签名、原始交易签名。',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(
                  context,
                  label: 'Overview Loading',
                  value: state.isOverviewLoading ? 'Yes' : 'No',
                ),
                _buildChip(
                  context,
                  label: 'Sections',
                  value: state.sections.length.toString(),
                ),
                _buildChip(
                  context,
                  label: 'RPC',
                  value: 'Ethereum Mainnet Public RPC',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '交互式 Demo Controls',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Ethereum Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () {
                    context.read<Web3Bloc>().add(
                          InspectAddressRequested(_addressController.text.trim()),
                        );
                  },
                  child: const Text('查询地址'),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.read<Web3Bloc>().add(
                          DemonstrateEncodingRequested(
                            tokenAddress: _tokenController.text.trim(),
                            recipientAddress: _addressController.text.trim(),
                          ),
                        );
                  },
                  child: const Text('重跑编码演示'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'ERC20 Token Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () {
                    context.read<Web3Bloc>().add(
                          InspectTokenRequested(
                            tokenAddress: _tokenController.text.trim(),
                            ownerAddress: _addressController.text.trim(),
                          ),
                        );
                  },
                  child: const Text('查询 ERC20'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _privateKeyController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Demo Private Key',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Personal Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                context.read<Web3Bloc>().add(
                      InspectWalletRequested(
                        privateKey: _privateKeyController.text.trim(),
                        message: _messageController.text,
                      ),
                    );
              },
              child: const Text('重跑签名演示'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(Web3SectionStatus status) {
    final section = status.section;
    final title = section?.title ?? 'Loading...';
    final subtitle = section?.subtitle ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(subtitle),
                      ],
                    ],
                  ),
                ),
                if (status.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            if (status.error != null) ...[
              const SizedBox(height: 12),
              _ErrorBanner(message: status.error!),
            ],
            if (section != null) ...[
              if (section.fields.isNotEmpty) ...[
                const SizedBox(height: 16),
                ...section.fields.map(_buildFieldRow),
              ],
              if (section.lines.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...section.lines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $line'),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(Web3DemoField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          SelectableText(field.value),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _tokenController.dispose();
    _privateKeyController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}
