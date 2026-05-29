import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/entities/flutter_ai_ui_kit_models.dart';

class FlutterAiUiKitCatalogService {
  const FlutterAiUiKitCatalogService();

  AiUiKitDemoSnapshot loadSnapshot() {
    return const AiUiKitDemoSnapshot(
      packageName: 'flutter_ai_ui_kit',
      summary:
          'A presentation-layer UI kit for AI chat screens. It supplies ready '
          'chat layout, message bubbles, streaming text, prompt cards, voice '
          'wave feedback, reaction controls, and theme tokens while leaving '
          'model calls, persistence, and orchestration in app-owned layers.',
      architectureFlow: <String>[
        'Presentation owns widgets: ChatScreenScaffold, ChatBubble, '
            'GlassInputField, StreamingText, TypingIndicator, VoiceWave.',
        'ViewModel owns UI state: message list, selected capability, '
            'generation flag, reactions, and command methods.',
        'Domain names the feature contract: snapshot, capability, and chat '
            'turn models describe what the UI should explain.',
        'Data supplies demo catalog content. In a production app this layer '
            'would call an AI repository, local cache, or analytics service.',
      ],
      capabilities: <AiUiKitCapability>[
        AiUiKitCapability(
          name: 'Complete AI chat surface',
          layer: AiUiKitCapabilityLayer.screen,
          role:
              'Builds a ready-to-use AI conversation page with app bar, empty '
              'state, prompt suggestions, message list, typing state, input '
              'bar, and scroll-to-bottom behavior.',
          cleanArchitectureNote:
              'Keep it in presentation. Pass domain chat turns converted to '
              'ChatMessage objects from the ViewModel.',
          widgets: <String>['ChatScreenScaffold', 'PromptCardConfig'],
        ),
        AiUiKitCapability(
          name: 'Assistant and user messages',
          layer: AiUiKitCapabilityLayer.message,
          role:
              'Renders polished chat bubbles with roles, avatars, timestamps, '
              'markdown/code support, copy behavior, and entrance animations.',
          cleanArchitectureNote:
              'Map domain messages to ChatMessage at the presentation edge; '
              'do not let package models leak into repositories.',
          widgets: <String>['ChatBubble', 'ChatMessage'],
        ),
        AiUiKitCapability(
          name: 'Streaming response feedback',
          layer: AiUiKitCapabilityLayer.feedback,
          role:
              'Shows token-style response reveal and a typing indicator so an '
              'AI request feels active before the final text is committed.',
          cleanArchitectureNote:
              'ViewModel exposes isGenerating and final text; the widget layer '
              'chooses StreamingText or TypingIndicator.',
          widgets: <String>['StreamingText', 'TypingIndicator'],
        ),
        AiUiKitCapability(
          name: 'Composer and voice affordance',
          layer: AiUiKitCapabilityLayer.input,
          role:
              'Provides a chat composer with send, attachment, and voice '
              'buttons, plus a waveform for recording or speaking states.',
          cleanArchitectureNote:
              'Callbacks become ViewModel commands; services handle files, '
              'speech capture, and permissions behind repositories.',
          widgets: <String>['GlassInputField', 'VoiceWave'],
        ),
        AiUiKitCapability(
          name: 'Quick prompts and reactions',
          layer: AiUiKitCapabilityLayer.feedback,
          role:
              'Adds suggestion cards and emoji reactions that make common AI '
              'workflows discoverable and capture lightweight feedback.',
          cleanArchitectureNote:
              'Prompt/reaction selections are UI events; persist or report '
              'them through use cases when the product needs it.',
          widgets: <String>['PromptCard', 'MessageReactionBar'],
        ),
        AiUiKitCapability(
          name: 'AI-specific theme tokens',
          layer: AiUiKitCapabilityLayer.theme,
          role:
              'Supplies light/dark AiUiThemeData tokens for bubbles, input, '
              'surfaces, accents, prompt cards, typing dots, and voice waves.',
          cleanArchitectureNote:
              'Wrap only the feature subtree with AiUiThemeScope so package '
              'styling stays isolated from app-wide Material theme choices.',
          widgets: <String>['AiUiThemeScope', 'AiUiThemeData'],
        ),
      ],
      initialConversation: <AiUiKitChatTurn>[
        AiUiKitChatTurn(
          id: 'assistant-intro',
          isUser: false,
          text:
              'This demo keeps `flutter_ai_ui_kit` in the presentation layer. '
              'The ViewModel owns state, the repository provides explanatory '
              'domain data, and the package renders the chat experience.',
        ),
        AiUiKitChatTurn(
          id: 'user-question',
          isUser: true,
          text: 'What does this package do in a clean architecture app?',
        ),
        AiUiKitChatTurn(
          id: 'assistant-architecture',
          isUser: false,
          isStreaming: true,
          text:
              'It accelerates the AI chat UI: full chat scaffold, markdown '
              'bubbles, streaming text, typing indicator, prompt cards, voice '
              'wave, reactions, and theme tokens. API calls and persistence '
              'still belong in data repositories.',
        ),
      ],
      promptSuggestions: <String>[
        'Explain package responsibility',
        'Show clean architecture boundary',
        'List widgets I should use',
        'Describe production integration',
      ],
    );
  }

  AiUiKitChatTurn buildAssistantReply(String userPrompt) {
    final String normalized = userPrompt.toLowerCase();
    final String text;

    if (normalized.contains('boundary') ||
        normalized.contains('architecture') ||
        normalized.contains('clean')) {
      text =
          'Clean architecture boundary:\n\n'
          '- Domain: app-owned chat entities and AI use cases\n'
          '- Data: model APIs, persistence, attachments, telemetry\n'
          '- Presentation: ViewModel state plus `flutter_ai_ui_kit` widgets\n\n'
          'The package should render state, not become the source of truth.';
    } else if (normalized.contains('widget') ||
        normalized.contains('component') ||
        normalized.contains('use')) {
      text =
          'Core widgets to reach for:\n\n'
          '- `ChatScreenScaffold` for the complete screen\n'
          '- `ChatBubble` for custom message rows\n'
          '- `StreamingText` and `TypingIndicator` for generation feedback\n'
          '- `GlassInputField`, `VoiceWave`, `PromptCard`, and '
          '`MessageReactionBar` for input and interaction polish';
    } else if (normalized.contains('production') ||
        normalized.contains('api') ||
        normalized.contains('repository')) {
      text =
          'Production integration usually keeps the AI request behind a '
          'repository or use case. The ViewModel sends user prompts, listens '
          'for generated output, maps domain turns to `ChatMessage`, and lets '
          '`flutter_ai_ui_kit` handle the visual state.';
    } else {
      text =
          '`flutter_ai_ui_kit` is useful when the product needs an AI chat '
          'surface quickly without hand-building bubbles, composer controls, '
          'typing feedback, streaming text, prompt cards, reactions, and theme '
          'tokens. The business rules remain in your app layers.';
    }

    return AiUiKitChatTurn(
      id: 'assistant-${DateTime.now().microsecondsSinceEpoch}',
      isUser: false,
      isStreaming: true,
      text: text,
    );
  }
}
