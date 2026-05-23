import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/entities/dart_code_metrics_preset_models.dart';
import 'package:widget_layout_example2/features/dart_code_metrics_presets/domain/repositories/dart_code_metrics_preset_repository.dart';

class DartCodeMetricsPresetsViewModel extends ChangeNotifier {
  DartCodeMetricsPresetsViewModel({
    required DartCodeMetricsPresetRepository repository,
  }) : _repository = repository;

  final DartCodeMetricsPresetRepository _repository;

  late DcmPresetGuide _guide = _repository.loadGuide();
  DcmPresetGuide get guide => _guide;

  DcmPresetAudience? _audienceFilter;
  DcmPresetAudience? get audienceFilter => _audienceFilter;

  List<DcmPreset> get visiblePresets {
    final DcmPresetAudience? filter = _audienceFilter;
    if (filter == null) {
      return _guide.presets;
    }
    return _guide.presets
        .where((DcmPreset preset) => preset.audience == filter)
        .toList(growable: false);
  }

  void selectAudience(DcmPresetAudience? audience) {
    _audienceFilter = audience;
    notifyListeners();
  }

  void reload() {
    _guide = _repository.loadGuide();
    notifyListeners();
  }
}
