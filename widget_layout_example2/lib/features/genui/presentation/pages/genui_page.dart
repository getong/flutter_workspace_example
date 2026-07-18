import 'dart:async';
import 'dart:convert';

import 'package:a2ui_core/a2ui_core.dart' as a2ui;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.genui)
class GenuiPage extends StatelessWidget {
  const GenuiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('genui Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const <Widget>[
          _OverviewCard(),
          SizedBox(height: 16),
          _PromptAndCapabilitiesCard(),
          SizedBox(height: 16),
          _SurfaceControllerCard(),
          SizedBox(height: 16),
          _ConversationCard(),
          SizedBox(height: 16),
          _ParserCard(),
          SizedBox(height: 16),
          _CatalogShowcaseCard(),
          SizedBox(height: 96),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Build dynamic Flutter interfaces from structured model output.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This page demonstrates `Catalog`, `SurfaceController`, `Surface`, '
                '`UpdateComponents`, `UpdateDataModel`, `PromptBuilder`, '
                '`A2uiParserTransformer`, `A2uiTransportAdapter`, '
                '`Conversation`, and `DebugCatalogView` from the `genui` package.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const <Widget>[
                  Chip(label: Text('Catalog')),
                  Chip(label: Text('SurfaceController')),
                  Chip(label: Text('Surface')),
                  Chip(label: Text('PromptBuilder')),
                  Chip(label: Text('A2uiParserTransformer')),
                  Chip(label: Text('A2uiTransportAdapter')),
                  Chip(label: Text('Conversation')),
                  Chip(label: Text('DebugCatalogView')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptAndCapabilitiesCard extends StatelessWidget {
  const _PromptAndCapabilitiesCard();

  @override
  Widget build(BuildContext context) {
    final Catalog catalog = _buildDebugCatalog();
    final String chatPrompt = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: <String>[
        PromptFragments.acknowledgeUser(),
        PromptFragments.requireAtLeastOneSubmitElement(),
        PromptFragments.currentDate(),
      ],
    ).systemPromptJoined();
    final String customPrompt = PromptBuilder.custom(
      catalog: catalog,
      allowedOperations: SurfaceOperations.createAndUpdate(dataModel: true),
      systemPromptFragments: <String>[
        'You are prototyping an internal admin tool.',
        PromptFragments.uiGenerationRestriction(),
      ],
      technicalPossibilities: const TechnicalPossibilities(
        functionCall: false,
        toolCall: false,
      ),
      clientDataModel: const <String, Object?>{
        'role': 'designer',
        'workspace': 'widget_layout_example2',
      },
    ).systemPromptJoined();
    final String capabilities = _prettyJson(
      A2UiClientCapabilities.fromCatalogs(<Catalog>[catalog]).toJson(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'PromptBuilder + Client Capabilities',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'genui needs both UI schema instructions and a description of the '
              'catalogs the client can render. The snippets below are generated '
              'directly from package APIs.',
            ),
            const SizedBox(height: 16),
            _CodePanel(title: 'Chat Prompt', text: chatPrompt),
            const SizedBox(height: 12),
            _CodePanel(title: 'Custom Prompt', text: customPrompt),
            const SizedBox(height: 12),
            _CodePanel(title: 'A2UI Client Capabilities', text: capabilities),
          ],
        ),
      ),
    );
  }
}

class _SurfaceControllerCard extends StatefulWidget {
  const _SurfaceControllerCard();

  @override
  State<_SurfaceControllerCard> createState() => _SurfaceControllerCardState();
}

class _SurfaceControllerCardState extends State<_SurfaceControllerCard> {
  static const String _surfaceId = 'genui-surface-studio';

  late final SurfaceController _controller;
  late final StreamSubscription<SurfaceUpdate> _surfaceSubscription;
  late final StreamSubscription<ChatMessage> _submitSubscription;

  final List<String> _logEntries = <String>[];

  @override
  void initState() {
    super.initState();
    _controller = SurfaceController(
      catalogs: <Catalog>[_buildSurfaceCatalog()],
    );
    _surfaceSubscription = _controller.surfaceUpdates.listen(
      _handleSurfaceUpdate,
    );
    _submitSubscription = _controller.onSubmit.listen(_handleSubmitMessage);
    _loadProfileSurface();
  }

  @override
  void dispose() {
    _surfaceSubscription.cancel();
    _submitSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleSurfaceUpdate(SurfaceUpdate update) {
    final String message = switch (update) {
      SurfaceAdded(:final surfaceId) => 'Surface added: $surfaceId',
      ComponentsUpdated(:final surfaceId, :final definition) =>
        'Components updated on $surfaceId (${definition.components.length} components)',
      SurfaceRemoved(:final surfaceId) => 'Surface removed: $surfaceId',
    };
    _appendLog(message);
  }

  void _handleSubmitMessage(ChatMessage message) {
    final String payload = message.parts
        .map((Part part) => part.toString())
        .join(' | ');
    _appendLog('onSubmit emitted: $payload');
  }

  void _appendLog(String message) {
    if (!mounted) {
      return;
    }
    setState(() {
      _logEntries.insert(0, '${_timeLabel()}  $message');
      if (_logEntries.length > 12) {
        _logEntries.removeRange(12, _logEntries.length);
      }
    });
  }

  void _loadProfileSurface() {
    _controller.handleMessage(
      a2ui.UpdateDataModelMessage(
        surfaceId: _surfaceId,
        value: <String, Object?>{
          'summary':
              'The summary card is bound to `/summary` in the data model.',
          'profile': <String, Object?>{'name': 'Flutter GenUI', 'ready': true},
        },
      ),
    );
    _controller.handleMessage(
      a2ui.UpdateComponentsMessage(
        surfaceId: _surfaceId,
        components: _componentsToJson(_profileComponents()),
      ),
    );
    _controller.handleMessage(
      a2ui.CreateSurfaceMessage(
        surfaceId: _surfaceId,
        catalogId: basicCatalogId,
        sendDataModel: true,
      ),
    );
    _appendLog(
      'Buffered `UpdateDataModel` and `UpdateComponents`, then created the surface.',
    );
  }

  void _loadStatusSurface() {
    _controller.handleMessage(
      a2ui.UpdateDataModelMessage(
        surfaceId: _surfaceId,
        value: <String, Object?>{
          'headline': 'Agent-ready release checklist',
          'summary':
              'This alternate surface reuses the same surfaceId with new components.',
          'checks': <String, Object?>{'docsReady': false, 'testsReady': true},
        },
      ),
    );
    _controller.handleMessage(
      a2ui.UpdateComponentsMessage(
        surfaceId: _surfaceId,
        components: _componentsToJson(_statusComponents()),
      ),
    );
    _controller.handleMessage(
      a2ui.CreateSurfaceMessage(
        surfaceId: _surfaceId,
        catalogId: basicCatalogId,
        sendDataModel: true,
      ),
    );
    _appendLog('Swapped the UI definition for the same surface.');
  }

  void _updateSummary() {
    _controller.handleMessage(
      a2ui.UpdateDataModelMessage(
        surfaceId: _surfaceId,
        path: '/summary',
        value:
            'Updated at ${DateTime.now().toIso8601String()}. The bound `Text` '
            'widget rebuilt from the data model change.',
      ),
    );
    _appendLog('Sent `UpdateDataModel` for `/summary`.');
  }

  void _toggleReadyFlag() {
    final bool current =
        _controller
            .contextFor(_surfaceId)
            .dataModel
            .getValue<bool>(DataPath('/profile/ready')) ??
        _controller
            .contextFor(_surfaceId)
            .dataModel
            .getValue<bool>(DataPath('/checks/docsReady')) ??
        false;

    final DataPath path =
        _controller
                .contextFor(_surfaceId)
                .dataModel
                .getValue<bool>(DataPath('/profile/ready')) !=
            null
        ? DataPath('/profile/ready')
        : DataPath('/checks/docsReady');

    _controller.handleMessage(
      a2ui.UpdateDataModelMessage(
        surfaceId: _surfaceId,
        path: path.toString(),
        value: !current,
      ),
    );
    _appendLog('Toggled `${path.toString()}` through `UpdateDataModel`.');
  }

  void _deleteSurface() {
    _controller.handleMessage(a2ui.DeleteSurfaceMessage(surfaceId: _surfaceId));
    _appendLog('Deleted the surface.');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'SurfaceController + Surface',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'This section drives a surface directly with `CreateSurface`, '
              '`UpdateComponents`, `UpdateDataModel`, and `DeleteSurface` '
              'messages. The generated button widgets emit `onSubmit` messages '
              'back through the controller.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.tonal(
                  onPressed: _loadProfileSurface,
                  child: const Text('Load Profile Surface'),
                ),
                FilledButton.tonal(
                  onPressed: _loadStatusSurface,
                  child: const Text('Load Status Surface'),
                ),
                OutlinedButton(
                  onPressed: _updateSummary,
                  child: const Text('Update Data Model'),
                ),
                OutlinedButton(
                  onPressed: _toggleReadyFlag,
                  child: const Text('Toggle Boolean Path'),
                ),
                OutlinedButton(
                  onPressed: _deleteSurface,
                  child: const Text('Delete Surface'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Surface(
                surfaceContext: _controller.contextFor(_surfaceId),
                defaultBuilder: (BuildContext context) => const Center(
                  child: Text('Create a surface to preview it here.'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _EventLog(title: 'Controller Log', entries: _logEntries),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends StatefulWidget {
  const _ConversationCard();

  @override
  State<_ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<_ConversationCard> {
  static const String _surfaceId = 'genui-conversation-surface';

  late final SurfaceController _controller;
  late final A2uiTransportAdapter _transport;
  late final Conversation _conversation;
  late final StreamSubscription<ConversationEvent> _eventSubscription;
  late final TextEditingController _promptController;

  final List<String> _events = <String>[];
  int _requestCount = 0;
  String _lastPrompt = 'Generate a release summary card';

  @override
  void initState() {
    super.initState();
    _controller = SurfaceController(
      catalogs: <Catalog>[_buildSurfaceCatalog()],
    );
    _transport = A2uiTransportAdapter(onSend: _fakeAgentResponse);
    _conversation = Conversation(
      controller: _controller,
      transport: _transport,
    );
    _promptController = TextEditingController(text: _lastPrompt);
    _eventSubscription = _conversation.events.listen(_handleConversationEvent);
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    _promptController.dispose();
    _conversation.dispose();
    _transport.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fakeAgentResponse(ChatMessage message) async {
    _requestCount += 1;
    final int requestNumber = _requestCount;

    _transport.addChunk(
      'Assistant turn $requestNumber received. Building a surface for '
      '"$_lastPrompt".',
    );
    await Future<void>.delayed(const Duration(milliseconds: 120));

    _transport.addChunk('''```json
{
  "version": "v0.9",
  "createSurface": {
    "surfaceId": "$_surfaceId",
    "catalogId": "$basicCatalogId",
    "sendDataModel": true
  }
}
```''');
    await Future<void>.delayed(const Duration(milliseconds: 120));

    _transport.addChunk('''```json
{
  "version": "v0.9",
  "updateDataModel": {
    "surfaceId": "$_surfaceId",
    "path": "/reply",
    "value": "Request $requestNumber was generated for: $_lastPrompt"
  }
}
```''');
    await Future<void>.delayed(const Duration(milliseconds: 120));

    _transport.addChunk('''```json
{
  "version": "v0.9",
  "updateComponents": {
    "surfaceId": "$_surfaceId",
    "components": [
      {
        "id": "root",
        "component": "List",
        "children": ["headline", "reply", "followUpButton"]
      },
      {
        "id": "headline",
        "component": "Text",
        "text": "### Conversation-driven surface"
      },
      {
        "id": "reply",
        "component": "Text",
        "text": {"path": "/reply"}
      },
      {
        "id": "followUpButton",
        "component": "Button",
        "child": "followUpLabel",
        "action": {
          "event": {"name": "follow_up_requested"}
        }
      },
      {
        "id": "followUpLabel",
        "component": "Text",
        "text": "Ask the fake agent again"
      }
    ]
  }
}
```''');

    if (message.parts.isNotEmpty) {
      _appendEvent(
        'Transport handled a message with ${message.parts.length} part(s).',
      );
    }
  }

  void _handleConversationEvent(ConversationEvent event) {
    final String label = switch (event) {
      ConversationWaiting() => 'Conversation waiting for transport response',
      ConversationContentReceived(:final text) => 'Text chunk: $text',
      ConversationSurfaceAdded(:final surfaceId) => 'Surface added: $surfaceId',
      ConversationComponentsUpdated(:final surfaceId) =>
        'Surface updated: $surfaceId',
      ConversationSurfaceRemoved(:final surfaceId) =>
        'Surface removed: $surfaceId',
      ConversationError(:final error) => 'Conversation error: $error',
    };
    _appendEvent(label);
  }

  void _appendEvent(String message) {
    if (!mounted) {
      return;
    }
    setState(() {
      _events.insert(0, '${_timeLabel()}  $message');
      if (_events.length > 14) {
        _events.removeRange(14, _events.length);
      }
    });
  }

  Future<void> _sendPrompt() async {
    final String prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      return;
    }
    setState(() {
      _lastPrompt = prompt;
    });
    await _conversation.sendRequest(ChatMessage.user(prompt));
  }

  void _clearConversationSurface() {
    _controller.handleMessage(a2ui.DeleteSurfaceMessage(surfaceId: _surfaceId));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Conversation + A2uiTransportAdapter',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'This section uses a fake transport callback to simulate an agent. '
              'The adapter receives streamed text and fenced JSON A2UI messages, '
              'and `Conversation` coordinates the response lifecycle.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Prompt to fake agent',
                hintText: 'Describe the UI the model should generate',
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<ConversationState>(
              valueListenable: _conversation.state,
              builder:
                  (
                    BuildContext context,
                    ConversationState state,
                    Widget? child,
                  ) {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(label: Text('Waiting: ${state.isWaiting}')),
                        Chip(label: Text('Surfaces: ${state.surfaces.length}')),
                        Chip(
                          label: Text(
                            state.latestText.isEmpty
                                ? 'Latest text: none yet'
                                : 'Latest text: ${state.latestText}',
                          ),
                        ),
                      ],
                    );
                  },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _sendPrompt,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Request'),
                ),
                OutlinedButton.icon(
                  onPressed: _clearConversationSurface,
                  icon: const Icon(Icons.layers_clear_outlined),
                  label: const Text('Clear Surface'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<ConversationState>(
              valueListenable: _conversation.state,
              builder:
                  (
                    BuildContext context,
                    ConversationState state,
                    Widget? child,
                  ) {
                    if (state.surfaces.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Send a prompt to let the fake backend create a surface.',
                        ),
                      );
                    }

                    return Column(
                      children: state.surfaces
                          .map(
                            (String surfaceId) => Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Surface(
                                surfaceContext: _controller.contextFor(
                                  surfaceId,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
            ),
            const SizedBox(height: 16),
            _EventLog(title: 'Conversation Events', entries: _events),
          ],
        ),
      ),
    );
  }
}

class _ParserCard extends StatefulWidget {
  const _ParserCard();

  @override
  State<_ParserCard> createState() => _ParserCardState();
}

class _ParserCardState extends State<_ParserCard> {
  late final TextEditingController _controller;
  final List<String> _results = <String>[];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _parserSample);
    _parse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _parse() async {
    final List<String> results = <String>[];
    final Stream<String> source = Stream<String>.fromIterable(
      _chunkText(_controller.text, chunkSize: 36),
    );

    await for (final GenerationEvent event in source.transform(
      const A2uiParserTransformer(),
    )) {
      switch (event) {
        case TextEvent(:final text):
          results.add('TextEvent -> ${text.trim()}');
        case A2uiMessageEvent(:final message):
          results.add(
            '${message.runtimeType} -> ${_prettyJson(_messageToJson(message))}',
          );
      }
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _results
        ..clear()
        ..addAll(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'A2uiParserTransformer',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'Paste streamed text and JSON blocks here. The parser splits plain '
              'text from structured A2UI messages.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              minLines: 8,
              maxLines: 14,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Chunk stream sample',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.tonal(
                  onPressed: _parse,
                  child: const Text('Parse Sample'),
                ),
                OutlinedButton(
                  onPressed: () {
                    _controller.text = _parserSample;
                    _parse();
                  },
                  child: const Text('Reset Sample'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _CodePanel(
              title: 'Parsed Events',
              text: _results.isEmpty
                  ? 'No parser events yet.'
                  : _results.join('\n\n'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogShowcaseCard extends StatelessWidget {
  const _CatalogShowcaseCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'DebugCatalogView',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              'The built-in catalog viewer renders example data for each catalog '
              'item. This is useful while designing a safe widget vocabulary for '
              'an agent.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 520,
              child: DebugCatalogView(
                catalog: _buildDebugCatalog(),
                itemHeight: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventLog extends StatelessWidget {
  const _EventLog({required this.title, required this.entries});

  final String title;
  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              const Text('No events yet.')
            else
              ...entries.map(
                (String entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Catalog _buildSurfaceCatalog() {
  return BasicCatalogItems.asCatalog();
}

Catalog _buildDebugCatalog() {
  return BasicCatalogItems.asCatalog().copyWithout(
    itemsToRemove: <CatalogItem>[
      BasicCatalogItems.audioPlayer,
      BasicCatalogItems.video,
      BasicCatalogItems.image,
      BasicCatalogItems.modal,
      BasicCatalogItems.tabs,
      BasicCatalogItems.dateTimeInput,
      BasicCatalogItems.slider,
      BasicCatalogItems.choicePicker,
    ],
    catalogId: 'com.example.widget_layout_example2.genui.debug',
    systemPromptFragments: <String>[
      BasicCatalogItems.basicCatalogRules,
      PromptFragments.acknowledgeUser(),
      PromptFragments.requireAtLeastOneSubmitElement(),
    ],
  );
}

List<Component> _profileComponents() {
  return const <Component>[
    Component(
      id: 'root',
      type: 'List',
      properties: <String, Object?>{
        'children': <String>[
          'title',
          'intro',
          'summaryCard',
          'nameField',
          'readyCheck',
          'toolbar',
        ],
      },
    ),
    Component(
      id: 'title',
      type: 'Text',
      properties: <String, Object?>{'text': '# Generated profile editor'},
    ),
    Component(
      id: 'intro',
      type: 'Text',
      properties: <String, Object?>{
        'text':
            'The controller created this interface from structured component messages.',
      },
    ),
    Component(
      id: 'summaryCard',
      type: 'Card',
      properties: <String, Object?>{'child': 'summaryBody'},
    ),
    Component(
      id: 'summaryBody',
      type: 'Text',
      properties: <String, Object?>{
        'text': <String, Object?>{'path': '/summary'},
      },
    ),
    Component(
      id: 'nameField',
      type: 'TextField',
      properties: <String, Object?>{
        'label': 'Project name',
        'value': <String, Object?>{'path': '/profile/name'},
        'checks': <Object?>[
          <String, Object?>{
            'message': 'Project name is required',
            'condition': <String, Object?>{
              'call': 'required',
              'args': <String, Object?>{
                'value': <String, Object?>{'path': '/profile/name'},
              },
            },
          },
        ],
      },
    ),
    Component(
      id: 'readyCheck',
      type: 'CheckBox',
      properties: <String, Object?>{
        'label': 'Ready for the next agent iteration',
        'value': <String, Object?>{'path': '/profile/ready'},
      },
    ),
    Component(
      id: 'toolbar',
      type: 'Row',
      properties: <String, Object?>{
        'children': <String>['saveButton', 'previewButton'],
      },
    ),
    Component(
      id: 'saveButton',
      type: 'Button',
      properties: <String, Object?>{
        'child': 'saveLabel',
        'action': <String, Object?>{
          'event': <String, Object?>{'name': 'save_profile'},
        },
      },
    ),
    Component(
      id: 'saveLabel',
      type: 'Text',
      properties: <String, Object?>{'text': 'Save profile'},
    ),
    Component(
      id: 'previewButton',
      type: 'Button',
      properties: <String, Object?>{
        'child': 'previewLabel',
        'action': <String, Object?>{
          'event': <String, Object?>{'name': 'preview_prompt'},
        },
      },
    ),
    Component(
      id: 'previewLabel',
      type: 'Text',
      properties: <String, Object?>{'text': 'Preview prompt'},
    ),
  ];
}

List<Component> _statusComponents() {
  return const <Component>[
    Component(
      id: 'root',
      type: 'List',
      properties: <String, Object?>{
        'children': <String>[
          'headline',
          'summary',
          'divider',
          'docsReady',
          'testsReady',
          'shipButton',
        ],
      },
    ),
    Component(
      id: 'headline',
      type: 'Text',
      properties: <String, Object?>{
        'text': <String, Object?>{'path': '/headline'},
      },
    ),
    Component(
      id: 'summary',
      type: 'Text',
      properties: <String, Object?>{
        'text': <String, Object?>{'path': '/summary'},
      },
    ),
    Component(id: 'divider', type: 'Divider', properties: <String, Object?>{}),
    Component(
      id: 'docsReady',
      type: 'CheckBox',
      properties: <String, Object?>{
        'label': 'Documentation reviewed',
        'value': <String, Object?>{'path': '/checks/docsReady'},
      },
    ),
    Component(
      id: 'testsReady',
      type: 'CheckBox',
      properties: <String, Object?>{
        'label': 'Regression tests passing',
        'value': <String, Object?>{'path': '/checks/testsReady'},
      },
    ),
    Component(
      id: 'shipButton',
      type: 'Button',
      properties: <String, Object?>{
        'child': 'shipButtonLabel',
        'action': <String, Object?>{
          'event': <String, Object?>{'name': 'ship_release'},
        },
      },
    ),
    Component(
      id: 'shipButtonLabel',
      type: 'Text',
      properties: <String, Object?>{'text': 'Ship release'},
    ),
  ];
}

String _prettyJson(Object value) {
  return const JsonEncoder.withIndent('  ').convert(value);
}

Map<String, Object?> _messageToJson(a2ui.A2uiMessage message) {
  return message.toJson();
}

List<Map<String, dynamic>> _componentsToJson(List<Component> components) {
  return components.map((Component component) => component.toJson()).toList();
}

String _timeLabel() {
  final DateTime now = DateTime.now();
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  return '${twoDigits(now.hour)}:${twoDigits(now.minute)}:${twoDigits(now.second)}';
}

Iterable<String> _chunkText(String text, {required int chunkSize}) sync* {
  for (int index = 0; index < text.length; index += chunkSize) {
    final int end = (index + chunkSize).clamp(0, text.length);
    yield text.substring(index, end);
  }
}

const String _parserSample = '''
The model can speak in plain text first.

```json
{
  "version": "v0.9",
  "createSurface": {
    "surfaceId": "parser-demo",
    "catalogId": "https://a2ui.org/specification/v0_9/standard_catalog.json",
    "sendDataModel": true
  }
}
```

Then it can stream another block.

```json
{
  "version": "v0.9",
  "updateDataModel": {
    "surfaceId": "parser-demo",
    "path": "/title",
    "value": "Parsed from a markdown JSON block"
  }
}
```
''';
