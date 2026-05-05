import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' show LinkPreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterLinkPreviewer)
class FlutterLinkPreviewerPage extends StatefulWidget {
  const FlutterLinkPreviewerPage({super.key});

  @override
  State<FlutterLinkPreviewerPage> createState() =>
      _FlutterLinkPreviewerPageState();
}

class _FlutterLinkPreviewerPageState extends State<FlutterLinkPreviewerPage> {
  final TextEditingController _messageController = TextEditingController(
    text: 'Flutter 官网 https://flutter.dev 可以直接生成链接预览。',
  );

  final Map<String, LinkPreviewData> _previewCache =
      <String, LinkPreviewData>{};

  String _messageText = 'Flutter 官网 https://flutter.dev 可以直接生成链接预览。';
  String _statusText = 'Waiting for preview fetch.';
  bool _hideImage = false;
  bool _hideDescription = false;
  bool _enableAnimation = true;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _handleMessageChanged() {
    setState(() {
      _messageText = _messageController.text;
      _statusText = 'Editing text. Preview will use the first detected link.';
    });
  }

  void _applySample(String text) {
    _messageController.text = text;
    _messageController.selection = TextSelection.collapsed(
      offset: _messageController.text.length,
    );
  }

  void _clearMessage() {
    _messageController.clear();
    setState(() {
      _statusText = 'Message cleared.';
    });
  }

  void _handlePreviewFetched(String text, LinkPreviewData data) {
    setState(() {
      _previewCache[text] = data;
      _statusText = 'Preview fetched: ${data.title ?? data.link}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final LinkPreviewData? cachedPreview = _previewCache[_messageText];

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_link_previewer Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flutter_link_previewer scans a text string, finds the first URL, fetches metadata such as title, description, and image, then renders a preview card. A common pattern is to cache LinkPreviewData so rebuilds do not refetch the same link.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Live Text Input',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Edit the text below. The widget will look for the first link in the message and preview it.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _messageController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message text',
                        hintText:
                            'Type text with a URL such as https://flutter.dev',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton(
                          onPressed: () => _applySample(
                            'OpenAI 平台文档 https://platform.openai.com/docs 展示了一个典型的链接预览场景。',
                          ),
                          child: const Text('Use Docs Sample'),
                        ),
                        OutlinedButton(
                          onPressed: () => _applySample(
                            'GitHub 仓库 https://github.com/flutter/flutter 常见于社区内容分享。',
                          ),
                          child: const Text('Use GitHub Sample'),
                        ),
                        TextButton(
                          onPressed: _clearMessage,
                          child: const Text('Clear Text'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Current text: ${_messageText.isEmpty ? '(empty)' : _messageText}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Basic LinkPreview Usage',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This example passes text, cached preview data, and an onLinkPreviewDataFetched callback. That is the core integration pattern for this package.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _messageText.isEmpty
                                ? 'No message yet.'
                                : _messageText,
                          ),
                          const SizedBox(height: 12),
                          LinkPreview(
                            text: _messageText,
                            linkPreviewData: cachedPreview,
                            onLinkPreviewDataFetched: (LinkPreviewData data) {
                              _handlePreviewFetched(_messageText, data);
                            },
                            parentContent: _messageText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Status: $_statusText',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Customize Preview Rendering',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The package exposes display flags and style parameters so you can trim the card for different UI contexts.',
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilterChip(
                          label: const Text('Hide image'),
                          selected: _hideImage,
                          onSelected: (bool value) {
                            setState(() {
                              _hideImage = value;
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('Hide description'),
                          selected: _hideDescription,
                          onSelected: (bool value) {
                            setState(() {
                              _hideDescription = value;
                            });
                          },
                        ),
                        FilterChip(
                          label: const Text('Enable animation'),
                          selected: _enableAnimation,
                          onSelected: (bool value) {
                            setState(() {
                              _enableAnimation = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: LinkPreview(
                        text: _messageText,
                        linkPreviewData: cachedPreview,
                        onLinkPreviewDataFetched: (LinkPreviewData data) {
                          _handlePreviewFetched(_messageText, data);
                        },
                        parentContent: _messageText,
                        hideImage: _hideImage,
                        hideDescription: _hideDescription,
                        enableAnimation: _enableAnimation,
                        borderRadius: 12,
                        sideBorderWidth: 5,
                        sideBorderColor: Theme.of(context).colorScheme.primary,
                        insidePadding: const EdgeInsets.fromLTRB(
                          12,
                          10,
                          10,
                          10,
                        ),
                        outsidePadding: EdgeInsets.zero,
                        titleTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        descriptionTextStyle: TextStyle(
                          color: Colors.blueGrey.shade700,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Why Cache LinkPreviewData',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'If the preview data is saved in state, the widget can rebuild without making the same network request again for unchanged text. In chat or feed UIs, you would usually persist this data with the message model.',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cached entries: ${_previewCache.length}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cachedPreview == null
                          ? 'No cached preview for the current text yet.'
                          : 'Cached current title: ${cachedPreview.title ?? cachedPreview.link}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
