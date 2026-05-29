import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/entities/flutter_ai_ui_kit_models.dart';

abstract interface class FlutterAiUiKitRepository {
  AiUiKitDemoSnapshot loadSnapshot();

  AiUiKitChatTurn buildAssistantReply(String userPrompt);
}
