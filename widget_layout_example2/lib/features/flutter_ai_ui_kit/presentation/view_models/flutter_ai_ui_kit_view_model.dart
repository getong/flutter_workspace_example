import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/entities/flutter_ai_ui_kit_models.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/repositories/flutter_ai_ui_kit_repository.dart';

class FlutterAiUiKitViewModel extends ChangeNotifier {
  FlutterAiUiKitViewModel({required FlutterAiUiKitRepository repository})
    : _repository = repository {
    _snapshot = _repository.loadSnapshot();
    _selectedCapability = _snapshot.capabilities.first;
    _conversation = List<AiUiKitChatTurn>.of(_snapshot.initialConversation);
  }

  final FlutterAiUiKitRepository _repository;
  bool _isDisposed = false;

  late final AiUiKitDemoSnapshot _snapshot;
  AiUiKitDemoSnapshot get snapshot => _snapshot;

  late AiUiKitCapability _selectedCapability;
  AiUiKitCapability get selectedCapability => _selectedCapability;

  late List<AiUiKitChatTurn> _conversation;
  List<AiUiKitChatTurn> get conversation =>
      List<AiUiKitChatTurn>.unmodifiable(_conversation);

  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  bool _isVoiceActive = false;
  bool get isVoiceActive => _isVoiceActive;

  final Set<String> _selectedReactions = <String>{'👍'};
  Set<String> get selectedReactions =>
      Set<String>.unmodifiable(_selectedReactions);

  void selectCapability(AiUiKitCapability capability) {
    if (identical(capability, _selectedCapability)) {
      return;
    }

    _selectedCapability = capability;
    notifyListeners();
  }

  Future<void> sendPrompt(String text) async {
    final String prompt = text.trim();
    if (prompt.isEmpty || _isGenerating) {
      return;
    }

    _conversation = <AiUiKitChatTurn>[
      ..._conversation,
      AiUiKitChatTurn(
        id: 'user-${DateTime.now().microsecondsSinceEpoch}',
        isUser: true,
        text: prompt,
      ),
    ];
    _isGenerating = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (_isDisposed) {
      return;
    }

    _conversation = <AiUiKitChatTurn>[
      ..._conversation,
      _repository.buildAssistantReply(prompt),
    ];
    _isGenerating = false;
    notifyListeners();
  }

  void sendSuggestion(String prompt) {
    unawaited(sendPrompt(prompt));
  }

  void toggleVoiceActive() {
    _isVoiceActive = !_isVoiceActive;
    notifyListeners();
  }

  void toggleReaction(String emoji) {
    if (_selectedReactions.contains(emoji)) {
      _selectedReactions.remove(emoji);
    } else {
      _selectedReactions.add(emoji);
    }
    notifyListeners();
  }

  void resetConversation() {
    _conversation = List<AiUiKitChatTurn>.of(_snapshot.initialConversation);
    _isGenerating = false;
    _isVoiceActive = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
