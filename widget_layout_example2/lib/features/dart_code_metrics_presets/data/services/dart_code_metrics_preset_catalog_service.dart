import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/entities/dart_code_metrics_preset_models.dart';

class DartCodeMetricsPresetCatalogService {
  DcmPresetGuide loadGuide() {
    return const DcmPresetGuide(
      presets: <DcmPreset>[
        DcmPreset(
          name: 'Recommended',
          packagePath: 'package:dart_code_metrics_presets/recommended.yaml',
          audience: DcmPresetAudience.wholeApp,
          purpose:
              'Starts with rules focused on likely bugs, unsafe patterns, and '
              'maintainability problems. This is the conservative default.',
          exampleChecks: <String>[
            'avoid-dynamic',
            'avoid-duplicate-exports',
            'prefer-return-await',
            'dispose-fields',
          ],
        ),
        DcmPreset(
          name: 'Flutter All',
          packagePath: 'package:dart_code_metrics_presets/flutter_all.yaml',
          audience: DcmPresetAudience.flutterUi,
          purpose:
              'Adds Flutter-specific UI rules for widget structure, lifecycle, '
              'BuildContext usage, and common rendering mistakes.',
          exampleChecks: <String>[
            'always-remove-listener',
            'avoid-unnecessary-setstate',
            'use-closest-build-context',
            'prefer-using-list-view',
          ],
        ),
        DcmPreset(
          name: 'Metrics Recommended',
          packagePath:
              'package:dart_code_metrics_presets/metrics_recommended.yaml',
          audience: DcmPresetAudience.architecture,
          purpose:
              'Adds threshold-based complexity metrics that make large methods, '
              'deep widget trees, and over-coupled classes visible in review.',
          exampleChecks: <String>[
            'cyclomatic-complexity: 15',
            'source-lines-of-code: 60',
            'widgets-nesting-level: 8',
            'number-of-methods: 10',
          ],
        ),
        DcmPreset(
          name: 'Pub',
          packagePath: 'package:dart_code_metrics_presets/pub.yaml',
          audience: DcmPresetAudience.pubspec,
          purpose:
              'Checks package metadata and dependency hygiene. It belongs in '
              'the same quality gate as analyzer and tests, not in app logic.',
          exampleChecks: <String>[
            'pubspec rules',
            'dependency hygiene',
            'metadata consistency',
          ],
        ),
      ],
      recommendedConfig: '''
dart_code_metrics:
  extends:
    - package:dart_code_metrics_presets/recommended.yaml
    - package:dart_code_metrics_presets/flutter_all.yaml
    - package:dart_code_metrics_presets/metrics_recommended.yaml
  rules:
    - prefer-single-widget-per-file: false
''',
      cleanArchitectureNotes: <String>[
        'Domain layer stays independent from DCM and contains only policy concepts such as presets and intended checks.',
        'Data layer acts as a catalog of static tool configuration because dart_code_metrics_presets is a dev dependency.',
        'Presentation layer explains and previews the quality gate; it does not execute DCM from the app.',
        'CI or local scripts should run DCM beside dart analyze and flutter test so architecture drift is caught before merge.',
      ],
    );
  }
}
