import 'package:widget_layout_example2/features/flutter_ai_ui_kit/data/services/flutter_ai_ui_kit_catalog_service.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/entities/flutter_ai_ui_kit_models.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/repositories/flutter_ai_ui_kit_repository.dart';

class FlutterAiUiKitRepositoryImpl implements FlutterAiUiKitRepository {
  const FlutterAiUiKitRepositoryImpl({required this.service});

  final FlutterAiUiKitCatalogService service;

  @override
  AiUiKitDemoSnapshot loadSnapshot() {
    return service.loadSnapshot();
  }

  @override
  AiUiKitChatTurn buildAssistantReply(String userPrompt) {
    return service.buildAssistantReply(userPrompt);
  }
}
