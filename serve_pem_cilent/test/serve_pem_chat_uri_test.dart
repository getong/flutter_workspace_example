import 'package:flutter_test/flutter_test.dart';
import 'package:serve_pem_cilent/features/serve_pem/data/services/serve_pem_chat_uri.dart';

void main() {
  test(
    'buildServePemChatUri converts https endpoints into wss room routes',
    () {
      final uri = buildServePemChatUri(
        room: 'general-room_1',
        baseUrl: 'https://127.0.0.1:3030',
      );

      expect(uri.toString(), 'wss://127.0.0.1:3030/ws/general-room_1');
    },
  );

  test('normalizeServePemChatRoom strips unsupported characters', () {
    expect(normalizeServePemChatRoom(' general!!!room '), 'generalroom');
  });

  test('normalizeServePemChatRoom rejects empty results', () {
    expect(
      () => normalizeServePemChatRoom('!!!'),
      throwsA(isA<FormatException>()),
    );
  });
}
