import 'package:widget_layout_example2/modules/wasm_ffi_demo_models.dart';

class WasmFfiDemoRuntime {
  const WasmFfiDemoRuntime();

  static const String assetPath = 'assets/wasm/wasm_ffi/native_example.wasm';

  bool get isSupported => false;

  String get supportMessage =>
      'wasm_ffi only supports Flutter web. This page still documents the API, '
      'but the live demo activates when the app runs in a browser.';

  Future<WasmFfiDemoResult> loadStandaloneExample() {
    throw UnsupportedError(supportMessage);
  }
}
