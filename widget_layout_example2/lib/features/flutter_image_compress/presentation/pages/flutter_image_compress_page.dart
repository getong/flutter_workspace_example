import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/data/repositories/flutter_image_compress_repository.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/data/services/flutter_image_compress_service.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/domain/entities/image_compression_models.dart';
import 'package:widget_layout_example2/features/flutter_image_compress/presentation/view_models/flutter_image_compress_view_model.dart';

@RoutePage(name: RouteName.flutterImageCompress)
class FlutterImageCompressPage extends StatefulWidget {
  const FlutterImageCompressPage({super.key});

  @override
  State<FlutterImageCompressPage> createState() =>
      _FlutterImageCompressPageState();
}

class _FlutterImageCompressPageState extends State<FlutterImageCompressPage> {
  late final FlutterImageCompressViewModel _viewModel =
      FlutterImageCompressViewModel(
        repository: FlutterImageCompressRepository(
          service: FlutterImageCompressService(),
        ),
      );

  @override
  void initState() {
    super.initState();
    _viewModel.compress();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: const Text('flutter_image_compress Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const _IntroCard(),
                const SizedBox(height: 16),
                _ControlsCard(viewModel: _viewModel),
                const SizedBox(height: 16),
                _ResultCard(viewModel: _viewModel),
                const SizedBox(height: 16),
                const _ArchitectureCard(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.router.replacePath(AppRoute.home.path),
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
        );
      },
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Compress image bytes before upload, cache, or preview.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'flutter_image_compress is a plugin boundary. Keep it in the '
              'data layer because it talks to platform codecs and returns raw '
              'image bytes. The domain layer should describe compression '
              'intent and results without depending on Flutter widgets.',
            ),
            const SizedBox(height: 12),
            const _CodeBlock(
              code: '''
final bytes = await FlutterImageCompress.compressAssetImage(
  assetPath,
  minWidth: 900,
  minHeight: 600,
  quality: 72,
  format: CompressFormat.jpeg,
  keepExif: false,
);
''',
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsCard extends StatelessWidget {
  const _ControlsCard({required this.viewModel});

  final FlutterImageCompressViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ImageCompressionRequest request = viewModel.request;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Compression Request',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text('Asset: ${request.assetPath}'),
            const SizedBox(height: 16),
            Text('Quality: ${request.quality}'),
            Slider(
              value: request.quality.toDouble(),
              min: 10,
              max: 95,
              divisions: 17,
              label: '${request.quality}',
              onChanged: viewModel.isCompressing
                  ? null
                  : viewModel.updateQuality,
            ),
            const SizedBox(height: 8),
            Text('Max dimension: ${request.minWidth}px'),
            Slider(
              value: request.minWidth.toDouble(),
              min: 320,
              max: 1600,
              divisions: 16,
              label: '${request.minWidth}px',
              onChanged: viewModel.isCompressing
                  ? null
                  : viewModel.updateMaxSize,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final ImageCompressionFormat format
                    in ImageCompressionFormat.values)
                  ChoiceChip(
                    label: Text(formatImageCompressionFormat(format)),
                    selected: request.format == format,
                    onSelected: viewModel.isCompressing
                        ? null
                        : (bool selected) {
                            if (selected) {
                              viewModel.updateFormat(format);
                            }
                          },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Keep EXIF metadata'),
              subtitle: const Text(
                'Usually false for privacy and smaller uploads.',
              ),
              value: request.keepExif,
              onChanged: viewModel.isCompressing
                  ? null
                  : viewModel.updateKeepExif,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: viewModel.isCompressing ? null : viewModel.compress,
              icon: viewModel.isCompressing
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.compress),
              label: const Text('Compress Asset'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.viewModel});

  final FlutterImageCompressViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ImageCompressionResult? result = viewModel.result;
    final String? errorMessage = viewModel.errorMessage;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Repository Output',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (errorMessage != null)
              Text(errorMessage, style: TextStyle(color: Colors.red.shade700))
            else if (result == null)
              const Text('Compression has not completed yet.')
            else ...<Widget>[
              _MetricRow(label: 'Original', value: result.originalSizeLabel),
              _MetricRow(
                label: 'Compressed',
                value: result.compressedSizeLabel,
              ),
              _MetricRow(label: 'Saved', value: result.savedSizeLabel),
              _MetricRow(label: 'Result ratio', value: result.ratioLabel),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  result.compressedBytes,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SectionTitle('Clean Architecture Placement'),
            SizedBox(height: 12),
            _LayerRow(
              label: 'Domain',
              detail:
                  'ImageCompressionRequest and ImageCompressionResult express '
                  'business intent: target size, quality, format, metadata, '
                  'and output metrics.',
            ),
            SizedBox(height: 8),
            _LayerRow(
              label: 'Data',
              detail:
                  'FlutterImageCompressService wraps the platform plugin. '
                  'FlutterImageCompressRepository loads the source bytes and '
                  'maps raw output into a domain result.',
            ),
            SizedBox(height: 8),
            _LayerRow(
              label: 'Presentation',
              detail:
                  'FlutterImageCompressViewModel owns UI state and commands; '
                  'the page only renders controls and results.',
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          SizedBox(width: 120, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.label, required this.detail});

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(detail)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(code, style: const TextStyle(fontFamily: 'monospace')),
    );
  }
}
