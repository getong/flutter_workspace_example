import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_ui_kit/flutter_ai_ui_kit.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/data/repositories/flutter_ai_ui_kit_repository_impl.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/data/services/flutter_ai_ui_kit_catalog_service.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/domain/entities/flutter_ai_ui_kit_models.dart';
import 'package:widget_layout_example2/features/flutter_ai_ui_kit/presentation/view_models/flutter_ai_ui_kit_view_model.dart';

@RoutePage(name: RouteName.flutterAiUiKit)
class FlutterAiUiKitPage extends StatefulWidget {
  const FlutterAiUiKitPage({super.key});

  @override
  State<FlutterAiUiKitPage> createState() => _FlutterAiUiKitPageState();
}

class _FlutterAiUiKitPageState extends State<FlutterAiUiKitPage> {
  late final FlutterAiUiKitViewModel _viewModel = FlutterAiUiKitViewModel(
    repository: const FlutterAiUiKitRepositoryImpl(
      service: FlutterAiUiKitCatalogService(),
    ),
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (BuildContext context, Widget? child) {
        final ThemeData theme = Theme.of(context);
        final AiUiThemeData aiTheme =
            (theme.brightness == Brightness.dark
                    ? AiUiThemeData.dark()
                    : AiUiThemeData.light())
                .copyWith(
                  accentColor: theme.colorScheme.primary,
                  accentSecondary: theme.colorScheme.tertiary,
                  typingDotColor: theme.colorScheme.primary,
                  voiceWaveActiveColor: theme.colorScheme.primary,
                  cardRadius: 8,
                );

        return AiUiThemeScope(
          data: aiTheme,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('flutter_ai_ui_kit Module'),
              actions: <Widget>[
                IconButton(
                  onPressed: _viewModel.resetConversation,
                  tooltip: 'Reset conversation',
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: SelectionArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: <Widget>[
                  _IntroCard(snapshot: _viewModel.snapshot),
                  const SizedBox(height: 16),
                  _CapabilityCard(viewModel: _viewModel),
                  const SizedBox(height: 16),
                  _ChatPreviewCard(viewModel: _viewModel),
                  const SizedBox(height: 16),
                  _WidgetShowcaseCard(viewModel: _viewModel),
                  const SizedBox(height: 16),
                  _ArchitectureCard(snapshot: _viewModel.snapshot),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => context.router.replacePath(AppRoute.home.path),
              icon: const Icon(Icons.home),
              label: const Text('Home'),
            ),
          ),
        );
      },
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.snapshot});

  final AiUiKitDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Build AI chat UI without moving AI logic into widgets.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(snapshot.summary),
            const SizedBox(height: 12),
            const _CodeBlock(
              code: '''
AiUiThemeScope(
  data: AiUiThemeData.light(),
  child: ChatScreenScaffold(
    messages: viewModel.messages,
    isTyping: viewModel.isGenerating,
    onSend: viewModel.sendPrompt,
  ),
);
''',
            ),
          ],
        ),
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({required this.viewModel});

  final FlutterAiUiKitViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final AiUiKitCapability selected = viewModel.selectedCapability;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Capability Catalog',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final AiUiKitCapability capability
                    in viewModel.snapshot.capabilities)
                  ChoiceChip(
                    label: Text(capability.name),
                    selected: selected == capability,
                    onSelected: (bool isSelected) {
                      if (isSelected) {
                        viewModel.selectCapability(capability);
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _CapabilityDetails(capability: selected),
          ],
        ),
      ),
    );
  }
}

class _CapabilityDetails extends StatelessWidget {
  const _CapabilityDetails({required this.capability});

  final AiUiKitCapability capability;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _MetricRow(label: 'Layer', value: _formatLayer(capability.layer)),
            _MetricRow(label: 'Widgets', value: capability.widgets.join(', ')),
            const SizedBox(height: 8),
            Text(capability.role),
            const SizedBox(height: 8),
            Text(
              capability.cleanArchitectureNote,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatPreviewCard extends StatelessWidget {
  const _ChatPreviewCard({required this.viewModel});

  final FlutterAiUiKitViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages = viewModel.conversation
        .map(_toChatMessage)
        .toList(growable: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Package Widgets In The Presentation Layer',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'The chat below is backed by domain turns from the ViewModel. '
              'Only this widget maps them into flutter_ai_ui_kit ChatMessage '
              'objects.',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 520,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ChatScreenScaffold(
                  messages: messages,
                  isTyping: viewModel.isGenerating,
                  onSend: viewModel.sendPrompt,
                  onAttachment: () => _showSnack(
                    context,
                    'Attachment should call an app-owned repository.',
                  ),
                  onVoice: viewModel.toggleVoiceActive,
                  onMessageLongPress: (ChatMessage message) => _showSnack(
                    context,
                    'Long press can copy text or open message actions.',
                  ),
                  showAppBar: true,
                  appBarTitle: 'Clean Architecture Assistant',
                  appBarSubtitle: 'flutter_ai_ui_kit preview',
                  inputHintText: 'Ask about package responsibility...',
                  enableStreaming: false,
                  streamingSpeed: const Duration(milliseconds: 18),
                  emptyStateTitle: 'Ask about AI UI',
                  emptyStateSubtitle:
                      'Try the prompt cards to populate the ViewModel.',
                  promptCards: const <PromptCardConfig>[
                    PromptCardConfig(
                      icon: Icons.account_tree_outlined,
                      title: 'Boundary',
                      subtitle: 'Clean architecture placement',
                      promptText: 'Show clean architecture boundary',
                    ),
                    PromptCardConfig(
                      icon: Icons.widgets_outlined,
                      title: 'Widgets',
                      subtitle: 'Which components matter',
                      promptText: 'List widgets I should use',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ChatMessage _toChatMessage(AiUiKitChatTurn turn) {
    if (turn.isUser) {
      return ChatMessage.user(
        id: turn.id,
        text: _plainChatPreviewText(turn.text),
        senderName: 'Flutter App',
      );
    }

    return ChatMessage.assistant(
      id: turn.id,
      text: _plainChatPreviewText(turn.text),
      senderName: 'UI Kit Assistant',
      contentType: MessageContentType.text,
    );
  }

  String _plainChatPreviewText(String text) {
    return text
        .replaceAllMapped(RegExp(r'```[\s\S]*?```'), (Match match) {
          return match.group(0)!.replaceAll('```', '');
        })
        .replaceAllMapped(
          RegExp(r'^\s*[-*+]\s+', multiLine: true),
          (_) => 'Item: ',
        )
        .replaceAllMapped(RegExp(r'^#{1,6}\s+', multiLine: true), (_) => '')
        .replaceAllMapped(
          RegExp(r'\[(.*?)\]\((.*?)\)'),
          (Match match) => '${match.group(1)} (${match.group(2)})',
        )
        .replaceAllMapped(
          RegExp(r'`([^`]*)`'),
          (Match match) => match.group(1)!,
        )
        .replaceAllMapped(
          RegExp(r'\*\*([^*]*)\*\*'),
          (Match match) => match.group(1)!,
        )
        .replaceAllMapped(
          RegExp(r'\*([^*]*)\*'),
          (Match match) => match.group(1)!,
        );
  }
}

class _WidgetShowcaseCard extends StatelessWidget {
  const _WidgetShowcaseCard({required this.viewModel});

  final FlutterAiUiKitViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Reusable Components',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'These lower-level widgets are useful when the product already '
              'has its own shell but still needs AI-specific interactions.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool wide = constraints.maxWidth >= 760;
                final List<Widget> panels = <Widget>[
                  _ShowcasePanel(
                    title: 'PromptCard',
                    child: PromptCard(
                      icon: Icons.psychology_alt_outlined,
                      title: 'Summarize support thread',
                      subtitle: 'Turn messy context into next actions',
                      onTap: () => viewModel.sendSuggestion(
                        'Explain package responsibility',
                      ),
                    ),
                  ),
                  _ShowcasePanel(
                    title: 'StreamingText',
                    child: StreamingText(
                      key: ValueKey<String>(viewModel.selectedCapability.name),
                      text: viewModel.selectedCapability.role,
                      speed: const Duration(milliseconds: 14),
                      charsPerTick: 3,
                      useMarkdown: false,
                    ),
                  ),
                  _ShowcasePanel(
                    title: 'TypingIndicator',
                    child: TypingIndicator(
                      isVisible: true,
                      label: viewModel.isGenerating
                          ? 'Repository is responding'
                          : 'Ready for the next prompt',
                    ),
                  ),
                  _ShowcasePanel(
                    title: 'VoiceWave',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        VoiceWave(
                          isActive: viewModel.isVoiceActive,
                          barCount: 28,
                          maxBarHeight: 42,
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: viewModel.toggleVoiceActive,
                          icon: Icon(
                            viewModel.isVoiceActive
                                ? Icons.stop
                                : Icons.mic_none,
                          ),
                          label: Text(
                            viewModel.isVoiceActive
                                ? 'Stop voice state'
                                : 'Start voice state',
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ShowcasePanel(
                    title: 'MessageReactionBar',
                    child: MessageReactionBar(
                      selectedReactions: viewModel.selectedReactions,
                      onReactionToggled: viewModel.toggleReaction,
                    ),
                  ),
                  _ShowcasePanel(
                    title: 'PromptChipRow',
                    child: PromptChipRow(
                      padding: EdgeInsets.zero,
                      prompts: const <PromptChipData>[
                        PromptChipData(
                          label: 'Boundary',
                          icon: Icons.account_tree_outlined,
                        ),
                        PromptChipData(
                          label: 'Widgets',
                          icon: Icons.widgets_outlined,
                        ),
                        PromptChipData(
                          label: 'Production',
                          icon: Icons.rocket_launch_outlined,
                        ),
                      ],
                      onSelect: viewModel.sendSuggestion,
                    ),
                  ),
                ];

                if (!wide) {
                  return Column(
                    children: <Widget>[
                      for (int index = 0; index < panels.length; index += 1)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: index == panels.length - 1 ? 0 : 12,
                          ),
                          child: panels[index],
                        ),
                    ],
                  );
                }

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    for (final Widget panel in panels)
                      SizedBox(
                        width: (constraints.maxWidth - 12) / 2,
                        child: panel,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcasePanel extends StatelessWidget {
  const _ShowcasePanel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  const _ArchitectureCard({required this.snapshot});

  final AiUiKitDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Clean Architecture Placement',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (
              int index = 0;
              index < snapshot.architectureFlow.length;
              index += 1
            )
              Padding(
                padding: EdgeInsets.only(
                  bottom: index == snapshot.architectureFlow.length - 1 ? 0 : 8,
                ),
                child: _LayerRow(
                  label: 'Step ${index + 1}',
                  detail: snapshot.architectureFlow[index],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 92, child: Text(label)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.label, required this.detail});

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(detail)),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code.trim(),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    );
  }
}

String _formatLayer(AiUiKitCapabilityLayer layer) {
  return switch (layer) {
    AiUiKitCapabilityLayer.screen => 'Presentation screen',
    AiUiKitCapabilityLayer.message => 'Presentation message',
    AiUiKitCapabilityLayer.input => 'Presentation input',
    AiUiKitCapabilityLayer.feedback => 'Presentation feedback',
    AiUiKitCapabilityLayer.theme => 'Presentation theme',
  };
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
  );
}
