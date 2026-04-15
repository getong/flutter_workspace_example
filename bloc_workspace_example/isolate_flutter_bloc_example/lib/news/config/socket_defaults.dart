import 'package:flutter/foundation.dart';

String defaultWebSocketUrl() {
  if (kIsWeb) {
    return 'ws://127.0.0.1:3000/ws';
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android => 'ws://10.0.2.2:3000/ws',
    _ => 'ws://127.0.0.1:3000/ws',
  };
}
