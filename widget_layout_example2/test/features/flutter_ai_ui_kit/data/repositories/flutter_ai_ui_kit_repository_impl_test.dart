import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/data/repositories/flutter_ai_ui_kit_repository_impl.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/data/services/flutter_ai_ui_kit_catalog_service.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/entities/flutter_ai_ui_kit_models.dart';

void main() {
  group('FlutterAiUiKitRepositoryImpl', () {
    late FlutterAiUiKitRepositoryImpl repository;

    setUp(() {
      repository = const FlutterAiUiKitRepositoryImpl(
        service: FlutterAiUiKitCatalogService(),
      );
    });

    test('loads package responsibilities and clean architecture notes', () {
      final AiUiKitDemoSnapshot snapshot = repository.loadSnapshot();

      expect(snapshot.packageName, 'flutter_ai_ui_kit');
      expect(snapshot.capabilities, hasLength(greaterThanOrEqualTo(6)));
      expect(snapshot.architectureFlow.join(' '), contains('Presentation'));
      expect(snapshot.architectureFlow.join(' '), contains('ViewModel'));
      expect(
        snapshot.capabilities.expand((AiUiKitCapability item) => item.widgets),
        containsAll(<String>[
          'ChatScreenScaffold',
          'StreamingText',
          'GlassInputField',
          'AiUiThemeScope',
        ]),
      );
    });

    test('builds architecture-focused assistant replies', () {
      final AiUiKitChatTurn reply = repository.buildAssistantReply(
        'Show clean architecture boundary',
      );

      expect(reply.isUser, isFalse);
      expect(reply.isStreaming, isTrue);
      expect(reply.text, contains('Domain'));
      expect(reply.text, contains('Data'));
      expect(reply.text, contains('Presentation'));
    });
  });
}
