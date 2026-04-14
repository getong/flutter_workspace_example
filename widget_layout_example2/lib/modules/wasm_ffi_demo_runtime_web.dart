import 'package:wasm_ffi/ffi.dart' as ffi;
import 'package:wasm_ffi/ffi_utils.dart';
import 'package:widget_layout_example2/modules/wasm_ffi_demo_models.dart';

class WasmFfiDemoRuntime {
  const WasmFfiDemoRuntime();

  static const String assetPath = 'assets/wasm/wasm_ffi/native_example.wasm';

  bool get isSupported => true;

  String get supportMessage =>
      'Interactive example is active on Flutter web. The page loads a '
      'standalone `.wasm` asset with `DynamicLibrary.open`, marshals UTF-8 '
      'strings, and calls typed exports through wasm_ffi.';

  Future<WasmFfiDemoResult> loadStandaloneExample() async {
    final ffi.DynamicLibrary library = await ffi.DynamicLibrary.open(assetPath);
    final _NativeExampleBindings bindings = _NativeExampleBindings(library);

    final String helloMessage = using((Arena arena) {
      final ffi.Pointer<ffi.Char> name = 'Flutter Web'
          .toNativeUtf8(allocator: arena)
          .cast<ffi.Char>();
      final ffi.Pointer<ffi.Char> response = bindings.hello(name);
      try {
        return response.cast<Utf8>().toDartString();
      } finally {
        bindings.freeMemory(response);
      }
    }, library.allocator);

    final List<String> availableSymbols = <String>[
      'getLibraryName',
      'hello',
      'freeMemory',
      'intSize',
      'boolSize',
      'pointerSize',
      'static_init_check',
      '__wasm_call_ctors',
    ].where(library.providesSymbol).toList()..sort();

    return WasmFfiDemoResult(
      libraryName: bindings.getLibraryName().cast<Utf8>().toDartString(),
      helloMessage: helloMessage,
      intSize: bindings.intSize(),
      boolSize: bindings.boolSize(),
      pointerSize: bindings.pointerSize(),
      assetPath: assetPath,
      availableSymbols: availableSymbols,
    );
  }
}

class _NativeExampleBindings {
  _NativeExampleBindings(ffi.DynamicLibrary dynamicLibrary)
    : _lookup = dynamicLibrary.lookup;

  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
  _lookup;

  ffi.Pointer<ffi.Char> getLibraryName() => _getLibraryName();

  late final _getLibraryNamePtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>(
        'getLibraryName',
      );
  late final _getLibraryName = _getLibraryNamePtr
      .asFunction<ffi.Pointer<ffi.Char> Function()>();

  ffi.Pointer<ffi.Char> hello(ffi.Pointer<ffi.Char> text) => _hello(text);

  late final _helloPtr =
      _lookup<
        ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)
        >
      >('hello');
  late final _hello = _helloPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>();

  void freeMemory(ffi.Pointer<ffi.Char> buffer) => _freeMemory(buffer);

  late final _freeMemoryPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char>)>>(
        'freeMemory',
      );
  late final _freeMemory = _freeMemoryPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>)>();

  int intSize() => _intSize();

  late final _intSizePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'intSize',
  );
  late final _intSize = _intSizePtr.asFunction<int Function()>();

  int boolSize() => _boolSize();

  late final _boolSizePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'boolSize',
  );
  late final _boolSize = _boolSizePtr.asFunction<int Function()>();

  int pointerSize() => _pointerSize();

  late final _pointerSizePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'pointerSize',
  );
  late final _pointerSize = _pointerSizePtr.asFunction<int Function()>();

  int staticInitCheck() => _staticInitCheck();

  late final _staticInitCheckPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('static_init_check');
  late final _staticInitCheck = _staticInitCheckPtr
      .asFunction<int Function()>();
}
