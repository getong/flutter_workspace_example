import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/entities/dart_code_metrics_preset_models.dart';

abstract interface class DartCodeMetricsPresetRepository {
  DcmPresetGuide loadGuide();
}
