import 'dart:math';

import '../../domain/entities/advice.dart';

class FallbackAdviceService {
  final Random _random = Random();
  int? _lastIndex;

  static const List<String> _fallbackMessages = [
    'Start simple, then make the next small improvement.',
    'If the network is flaky, keep the UI useful anyway.',
    'Prefer clear boundaries between data, domain, and presentation.',
    'Make the failure mode helpful before making it clever.',
    'A working fallback is better than a polished dead end.',
  ];

  Advice getRandomAdvice() {
    var index = _random.nextInt(_fallbackMessages.length);

    if (_fallbackMessages.length > 1 && _lastIndex == index) {
      index = (index + 1) % _fallbackMessages.length;
    }

    _lastIndex = index;

    return Advice(
      id: 9000 + index,
      message: _fallbackMessages[index],
      source: 'Local fallback',
      author: 'App',
    );
  }
}
