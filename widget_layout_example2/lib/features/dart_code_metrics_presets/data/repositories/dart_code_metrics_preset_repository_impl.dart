import 'package:widget_layout_example2/features/dart_code_metrics_presets/data/services/dart_code_metrics_preset_catalog_service.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/entities/dart_code_metrics_preset_models.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/repositories/dart_code_metrics_preset_repository.dart';

class DartCodeMetricsPresetRepositoryImpl
    implements DartCodeMetricsPresetRepository {
  const DartCodeMetricsPresetRepositoryImpl({required this.service});

  final DartCodeMetricsPresetCatalogService service;

  @override
  DcmPresetGuide loadGuide() {
    return service.loadGuide();
  }
}
