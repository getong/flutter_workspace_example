enum AiUiKitCapabilityLayer { screen, message, input, feedback, theme }

class AiUiKitCapability {
  const AiUiKitCapability({
    required this.name,
    required this.layer,
    required this.role,
    required this.cleanArchitectureNote,
    required this.widgets,
  });

  final String name;
  final AiUiKitCapabilityLayer layer;
  final String role;
  final String cleanArchitectureNote;
  final List<String> widgets;
}

class AiUiKitChatTurn {
  const AiUiKitChatTurn({
    required this.id,
    required this.isUser,
    required this.text,
    this.isStreaming = false,
  });

  final String id;
  final bool isUser;
  final String text;
  final bool isStreaming;
}

class AiUiKitDemoSnapshot {
  const AiUiKitDemoSnapshot({
    required this.packageName,
    required this.summary,
    required this.architectureFlow,
    required this.capabilities,
    required this.initialConversation,
    required this.promptSuggestions,
  });

  final String packageName;
  final String summary;
  final List<String> architectureFlow;
  final List<AiUiKitCapability> capabilities;
  final List<AiUiKitChatTurn> initialConversation;
  final List<String> promptSuggestions;
}
