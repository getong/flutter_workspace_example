enum DcmPresetAudience { wholeApp, flutterUi, architecture, pubspec }

class DcmPreset {
  const DcmPreset({
    required this.name,
    required this.packagePath,
    required this.audience,
    required this.purpose,
    required this.exampleChecks,
  });

  final String name;
  final String packagePath;
  final DcmPresetAudience audience;
  final String purpose;
  final List<String> exampleChecks;
}

class DcmPresetGuide {
  const DcmPresetGuide({
    required this.presets,
    required this.recommendedConfig,
    required this.cleanArchitectureNotes,
  });

  final List<DcmPreset> presets;
  final String recommendedConfig;
  final List<String> cleanArchitectureNotes;
}

String formatDcmPresetAudience(DcmPresetAudience audience) {
  switch (audience) {
    case DcmPresetAudience.wholeApp:
      return 'Whole app';
    case DcmPresetAudience.flutterUi:
      return 'Flutter UI';
    case DcmPresetAudience.architecture:
      return 'Architecture';
    case DcmPresetAudience.pubspec:
      return 'Pubspec';
  }
}
