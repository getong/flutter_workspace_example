/// Stub implementation for non-web platforms
abstract class WasmLibraryWrapper {
  static Future<WasmLibraryWrapper> create(String libPath) {
    throw UnsupportedError('wasm_ffi only supports Flutter web');
  }

  /// Call hello function with string name
  String callHello(String name) => 'Hello, $name! (web only)';

  /// Get library name from WASM
  String getLibraryName() => 'wasm_ffi demo (not available on this platform)';

  /// Get size of int type
  int getIntSize() => 4;

  /// Get size of bool type
  int getBoolSize() => 1;

  /// Get size of pointer type
  int getPointerSize() => 8;

  /// Check static initialization
  bool isStaticInitialized() => false;
}
