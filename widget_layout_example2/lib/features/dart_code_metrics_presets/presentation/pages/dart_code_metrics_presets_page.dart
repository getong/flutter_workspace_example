import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/data/repositories/dart_code_metrics_preset_repository_impl.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/data/services/dart_code_metrics_preset_catalog_service.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/entities/dart_code_metrics_preset_models.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/presentation/view_models/dart_code_metrics_presets_view_model.dart';

@RoutePage(name: RouteName.dartCodeMetricsPresets)
class DartCodeMetricsPresetsPage extends StatefulWidget {
  const DartCodeMetricsPresetsPage({super.key});

  @override
  State<DartCodeMetricsPresetsPage> createState() =>
      _DartCodeMetricsPresetsPageState();
}

class _DartCodeMetricsPresetsPageState
    extends State<DartCodeMetricsPresetsPage> {
  late final DartCodeMetricsPresetsViewModel _viewModel =
      DartCodeMetricsPresetsViewModel(
        repository: DartCodeMetricsPresetRepositoryImpl(
          service: DartCodeMetricsPresetCatalogService(),
        ),
      );

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
          appBar: AppBar(title: const Text('dart_code_metrics_presets Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const _IntroCard(),
                const SizedBox(height: 16),
                _PresetFilterCard(viewModel: _viewModel),
                const SizedBox(height: 16),
                for (final DcmPreset preset
                    in _viewModel.visiblePresets) ...<Widget>[
                  _PresetCard(preset: preset),
                  const SizedBox(height: 12),
                ],
                _ConfigCard(config: _viewModel.guide.recommendedConfig),
                const SizedBox(height: 16),
                _ArchitectureCard(
                  notes: _viewModel.guide.cleanArchitectureNotes,
                ),
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
              'Use DCM presets as a development-time quality gate.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'dart_code_metrics_presets provides YAML rule sets for DCM. It '
              'should stay in dev_dependencies because it configures analysis '
              'and CI, not runtime behavior. This module documents which '
              'presets are useful and where they sit in a clean architecture.',
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetFilterCard extends StatelessWidget {
  const _PresetFilterCard({required this.viewModel});

  final DartCodeMetricsPresetsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Preset Catalog',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ChoiceChip(
                  label: const Text('All'),
                  selected: viewModel.audienceFilter == null,
                  onSelected: (bool selected) {
                    if (selected) {
                      viewModel.selectAudience(null);
                    }
                  },
                ),
                for (final DcmPresetAudience audience
                    in DcmPresetAudience.values)
                  ChoiceChip(
                    label: Text(formatDcmPresetAudience(audience)),
                    selected: viewModel.audienceFilter == audience,
                    onSelected: (bool selected) {
                      if (selected) {
                        viewModel.selectAudience(audience);
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({required this.preset});

  final DcmPreset preset;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    preset.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Chip(label: Text(formatDcmPresetAudience(preset.audience))),
              ],
            ),
            const SizedBox(height: 8),
            Text(preset.packagePath),
            const SizedBox(height: 12),
            Text(preset.purpose),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final String check in preset.exampleChecks)
                  Chip(label: Text(check)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigCard extends StatelessWidget {
  const _ConfigCard({required this.config});

  final String config;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Suggested DCM Configuration',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'Add this under analysis_options.yaml when DCM is enabled in the '
              'toolchain. Keep it separate from flutter_lints because DCM reads '
              'the dart_code_metrics section.',
            ),
            const SizedBox(height: 12),
            _CodeBlock(code: config),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Clean Architecture Placement',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final String note in notes)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(note),
              ),
            const SizedBox(height: 8),
            const _LayerRow(
              label: 'Domain',
              detail:
                  'DcmPreset and DcmPresetGuide model quality policies without '
                  'depending on DCM packages.',
            ),
            SizedBox(height: 8),
            const _LayerRow(
              label: 'Data',
              detail:
                  'DartCodeMetricsPresetCatalogService exposes static preset '
                  'metadata and configuration snippets.',
            ),
            SizedBox(height: 8),
            const _LayerRow(
              label: 'Presentation',
              detail:
                  'The page and ViewModel let developers inspect which preset '
                  'applies to each architecture concern.',
            ),
          ],
        ),
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
