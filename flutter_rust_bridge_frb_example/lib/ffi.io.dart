import 'dart:io';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'bridge_generated.io.dart';

const base = 'flutter_rust_bridge_frb_example';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
late final dylib = loadLibForFlutter(path);
late final api = RustImpl(dylib);
