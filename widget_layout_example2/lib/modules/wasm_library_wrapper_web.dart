import 'package:wasm_ffi/ffi.dart' as ffi;
import 'package:wasm_ffi/ffi_utils.dart';

/// Web implementation of WASM library wrapper with actual FFI calls
class WasmLibraryWrapper {
  final ffi.DynamicLibrary library;
  final _NativeExampleBindings _bindings;

  WasmLibraryWrapper._(this.library)
    : _bindings = _NativeExampleBindings(library);

  /// Factory constructor to load WASM library from asset path
  static Future<WasmLibraryWrapper> create(String libPath) async {
    final ffi.DynamicLibrary library = await ffi.DynamicLibrary.open(libPath);
    return WasmLibraryWrapper._(library);
  }

  /// Call hello function with string marshalling
  String callHello(String name) {
    return using((Arena arena) {
      final cString = name.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final result = _bindings.hello(cString);
      try {
        return result.cast<Utf8>().toDartString();
      } finally {
        _bindings.freeMemory(result);
      }
    }, library.allocator);
  }

  /// Get library name from WASM
  String getLibraryName() =>
      _bindings.getLibraryName().cast<Utf8>().toDartString();

  /// Get size of int type
  int getIntSize() => _bindings.intSize();

  /// Get size of bool type
  int getBoolSize() => _bindings.boolSize();

  /// Get size of pointer type
  int getPointerSize() => _bindings.pointerSize();

  /// Check static initialization
  bool isStaticInitialized() => _bindings.staticInitCheck() != 0;
}

/// FFI Bindings for native WASM example
class _NativeExampleBindings {
  _NativeExampleBindings(ffi.DynamicLibrary dynamicLibrary)
    : _lookup = dynamicLibrary.lookup;

  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
  _lookup;

  /// Get library name
  ffi.Pointer<ffi.Char> getLibraryName() => _getLibraryName();

  late final _getLibraryNamePtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>(
        'getLibraryName',
      );
  late final _getLibraryName = _getLibraryNamePtr
      .asFunction<ffi.Pointer<ffi.Char> Function()>();

  /// Hello world function - takes a name string and returns a greeting
  ffi.Pointer<ffi.Char> hello(ffi.Pointer<ffi.Char> text) => _hello(text);

  late final _helloPtr =
      _lookup<
        ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)
        >
      >('hello');
  late final _hello = _helloPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>)>();

  /// Free memory allocated by library
  void freeMemory(ffi.Pointer<ffi.Char> buffer) => _freeMemory(buffer);

  late final _freeMemoryPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Char>)>>(
        'freeMemory',
      );
  late final _freeMemory = _freeMemoryPtr
      .asFunction<void Function(ffi.Pointer<ffi.Char>)>();

  /// Get size of int
  int intSize() => _intSize();

  late final _intSizePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'intSize',
  );
  late final _intSize = _intSizePtr.asFunction<int Function()>();

  /// Get size of bool
  int boolSize() => _boolSize();

  late final _boolSizePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'boolSize',
  );
  late final _boolSize = _boolSizePtr.asFunction<int Function()>();

  /// Get size of pointer
  int pointerSize() => _pointerSize();

  late final _pointerSizePtr = _lookup<ffi.NativeFunction<ffi.Int Function()>>(
    'pointerSize',
  );
  late final _pointerSize = _pointerSizePtr.asFunction<int Function()>();

  /// Check static initialization
  int staticInitCheck() => _staticInitCheck();

  late final _staticInitCheckPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('static_init_check');
  late final _staticInitCheck = _staticInitCheckPtr
      .asFunction<int Function()>();
}
