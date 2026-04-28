import '../../../../core/network/server_base_url.dart';

String normalizeServePemChatRoom(String room) {
  final trimmed = room.trim();
  if (trimmed.isEmpty || trimmed.length > 64) {
    throw const FormatException(
      'Room is required and must be 64 characters or fewer.',
    );
  }

  final normalized = trimmed
      .split('')
      .where(
        (character) =>
            _isAsciiLetterOrDigit(character) ||
            character == '-' ||
            character == '_' ||
            character == '.',
      )
      .join();

  if (normalized.isEmpty) {
    throw const FormatException(
      'Room may only contain ASCII letters, digits, ".", "_" or "-".',
    );
  }

  return normalized;
}

Uri buildServePemChatUri({required String room, String? baseUrl}) {
  final normalizedRoom = normalizeServePemChatRoom(room);
  final baseUri = Uri.parse(baseUrl ?? resolveServePemBaseUrl());
  final scheme = switch (baseUri.scheme) {
    'https' => 'wss',
    'http' => 'ws',
    'wss' => 'wss',
    'ws' => 'ws',
    _ => throw FormatException(
      'Unsupported server URL scheme "${baseUri.scheme}".',
    ),
  };

  final pathSegments = [
    ...baseUri.pathSegments.where((segment) => segment.isNotEmpty),
    'ws',
    normalizedRoom,
  ];

  return baseUri.replace(
    scheme: scheme,
    pathSegments: pathSegments,
    query: null,
    fragment: null,
  );
}

bool _isAsciiLetterOrDigit(String value) {
  final codeUnit = value.codeUnitAt(0);
  return (codeUnit >= 48 && codeUnit <= 57) ||
      (codeUnit >= 65 && codeUnit <= 90) ||
      (codeUnit >= 97 && codeUnit <= 122);
}
