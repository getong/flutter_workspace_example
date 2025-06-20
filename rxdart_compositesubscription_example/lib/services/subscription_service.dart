import 'dart:async';
import 'package:rxdart/rxdart.dart';

class SubscriptionService {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();
  final PublishSubject<String> _buttonClickSubject = PublishSubject<String>();
  final PublishSubject<String> _textInputSubject = PublishSubject<String>();

  bool _isActive = false;

  // Getters for streams
  Stream<String> get buttonClickStream => _buttonClickSubject.stream;
  Stream<String> get textInputStream => _textInputSubject.stream;
  bool get isActive => _isActive;

  void addButtonClick(String buttonName) {
    _buttonClickSubject.add(buttonName);
  }

  void addTextInput(String text) {
    _textInputSubject.add(text);
  }

  void startSubscriptions({
    required Function(int) onTimerTick,
    required Function(String) onButtonClick,
    required Function(String) onTextInput,
    required Function(String) onCombinedEvent,
  }) {
    if (_isActive) return;

    _isActive = true;

    // Timer stream
    final timerSubscription = Stream.periodic(
      const Duration(seconds: 1),
      (count) => count,
    ).listen(onTimerTick);

    // Button click stream
    final buttonSubscription = _buttonClickSubject.stream.listen(onButtonClick);

    // Text input stream with debounce
    final textSubscription = _textInputSubject.stream
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen(onTextInput);

    // Combined stream
    final combinedSubscription = Rx.merge([
      Stream.periodic(const Duration(seconds: 3)).map((_) => 'Timer tick'),
      _buttonClickSubject.stream.map((btn) => 'Button: $btn'),
    ]).listen(onCombinedEvent);

    // Add all to composite subscription
    _compositeSubscription.add(timerSubscription);
    _compositeSubscription.add(buttonSubscription);
    _compositeSubscription.add(textSubscription);
    _compositeSubscription.add(combinedSubscription);
  }

  void stopAllSubscriptions() {
    _compositeSubscription.clear();
    _isActive = false;
  }

  void dispose() {
    _compositeSubscription.dispose();
    _buttonClickSubject.close();
    _textInputSubject.close();
  }
}
