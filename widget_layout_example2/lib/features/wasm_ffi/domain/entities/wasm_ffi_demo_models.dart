class WasmFfiDemoResult {
  const WasmFfiDemoResult({
    required this.libraryName,
    required this.helloMessage,
    required this.intSize,
    required this.boolSize,
    required this.pointerSize,
    required this.assetPath,
    required this.availableSymbols,
  });

  final String libraryName;
  final String helloMessage;
  final int intSize;
  final int boolSize;
  final int pointerSize;
  final String assetPath;
  final List<String> availableSymbols;
}
