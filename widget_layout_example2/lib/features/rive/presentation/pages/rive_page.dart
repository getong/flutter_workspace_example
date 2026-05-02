import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:widget_layout_example2/app_navigation.dart';

// ignore_for_file: experimental_member_use

const String _riveSampleUrl = 'https://cdn.rive.app/animations/vehicles.riv';

@RoutePage(name: RouteName.rive)
class RivePage extends StatefulWidget {
  const RivePage({super.key});

  @override
  State<RivePage> createState() => _RivePageState();
}

class _RivePageState extends State<RivePage> {
  late final rive.FileLoader _builderLoader = rive.FileLoader.fromUrl(
    _riveSampleUrl,
    riveFactory: rive.Factory.rive,
  );

  rive.File? _manualFile;
  rive.RiveWidgetController? _manualController;
  Object? _manualError;
  bool _manualLoading = true;

  @override
  void initState() {
    super.initState();
    _loadManualPreview();
  }

  @override
  void dispose() {
    _builderLoader.dispose();
    _manualController?.dispose();
    _manualFile?.dispose();
    super.dispose();
  }

  Future<void> _loadManualPreview() async {
    try {
      final rive.File? file = await rive.File.url(
        _riveSampleUrl,
        riveFactory: rive.Factory.flutter,
      );
      if (!mounted) {
        file?.dispose();
        return;
      }
      if (file == null) {
        throw StateError('Rive returned a null file for $_riveSampleUrl');
      }

      final rive.RiveWidgetController controller = rive.RiveWidgetController(
        file,
      );

      setState(() {
        _manualFile = file;
        _manualController = controller;
        _manualLoading = false;
        _manualError = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _manualLoading = false;
        _manualError = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('rive Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Use `rive` to load interactive `.riv` graphics from a URL, an asset, or an already loaded file.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates `RiveWidgetBuilder`, `RiveWidget`, '
              '`FileLoader.fromUrl`, `File.url`, renderer selection, '
              '`RivePanel`, shared textures, loading states, and error '
              'handling with current `0.14.x` runtime patterns.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(
              title: '1. Builder-managed loading',
              code: r'''
final fileLoader = FileLoader.fromAsset(
  'assets/vehicles.riv',
  riveFactory: Factory.rive,
);

RiveWidgetBuilder(
  fileLoader: fileLoader,
  builder: (context, state) => switch (state) {
    RiveLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
    RiveFailed() => Text(state.error.toString()),
    RiveLoaded() => RiveWidget(
        controller: state.controller,
        fit: Fit.contain,
      ),
  },
);
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: '2. Manual file lifecycle',
              code: r'''
final file = await File.url(
  'https://cdn.rive.app/animations/vehicles.riv',
  riveFactory: Factory.flutter,
);

final controller = RiveWidgetController(file!);

@override
void dispose() {
  controller.dispose();
  file.dispose();
  super.dispose();
}
''',
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: '3. Shared texture with RivePanel',
              code: r'''
RivePanel(
  child: Row(
    children: [
      Expanded(
        child: RiveWidget(
          controller: state.controller,
          useSharedTexture: true,
          drawOrder: 1,
        ),
      ),
    ],
  ),
);
''',
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Live Demo A: Builder-managed network file',
              description:
                  'A `FileLoader` owns the remote `.riv` file and '
                  '`RiveWidgetBuilder` handles loading, controller creation, '
                  'resource reuse, and failure states.',
              child: SizedBox(
                height: 240,
                child: rive.RiveWidgetBuilder(
                  fileLoader: _builderLoader,
                  onFailed: (Object error, StackTrace stackTrace) {
                    debugPrint('rive builder failed: $error');
                  },
                  builder: (BuildContext context, rive.RiveState state) {
                    return switch (state) {
                      rive.RiveLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      rive.RiveFailed() => _RiveErrorPanel(error: state.error),
                      rive.RiveLoaded() => DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Color(0xFFE0F2FE),
                              Color(0xFFDCFCE7),
                              Color(0xFFFFF7ED),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: rive.RiveWidget(
                            controller: state.controller,
                            fit: rive.Fit.contain,
                          ),
                        ),
                      ),
                    };
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Live Demo B: Manual `File.url` + `RiveWidget`',
              description:
                  'This version mirrors situations where your app caches a file, '
                  'passes it across widgets, or needs explicit disposal rules.',
              child: SizedBox(
                height: 220,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildManualPreview(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Live Demo C: `RivePanel` shared texture gallery',
              description:
                  'Multiple Rive widgets can draw into one shared texture for '
                  'better scaling when a screen shows many animations at once.',
              child: SizedBox(
                height: 250,
                child: rive.RivePanel(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _SharedTextureTile(
                          title: 'Preview A',
                          fileLoader: _builderLoader,
                          drawOrder: 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SharedTextureTile(
                          title: 'Preview B',
                          fileLoader: _builderLoader,
                          drawOrder: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SharedTextureTile(
                          title: 'Preview C',
                          fileLoader: _builderLoader,
                          drawOrder: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'When to use which API',
              description:
                  'Choose the lower-level or higher-level widget based on who '
                  'owns the file lifecycle in your feature.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  _UsageBullet(
                    title: 'Use `RiveWidgetBuilder`',
                    body:
                        'when the page can let the widget load the file and own failure/loading UI.',
                  ),
                  SizedBox(height: 10),
                  _UsageBullet(
                    title: 'Use `RiveWidget` directly',
                    body:
                        'when a repository, cache layer, or parent widget already owns the loaded file.',
                  ),
                  SizedBox(height: 10),
                  _UsageBullet(
                    title: 'Use `RivePanel`',
                    body:
                        'when many animated thumbnails appear together and you want one shared texture.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _CodeSampleCard(
              title: 'Official sample URL used on this page',
              code: r'''
const riveUrl = 'https://cdn.rive.app/animations/vehicles.riv';
''',
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

  Widget _buildManualPreview() {
    if (_manualLoading) {
      return const Center(
        key: ValueKey<String>('loading'),
        child: CircularProgressIndicator(),
      );
    }

    if (_manualError != null || _manualController == null) {
      return _RiveErrorPanel(
        key: const ValueKey<String>('error'),
        error: _manualError ?? StateError('Manual controller was not created.'),
      );
    }

    return Container(
      key: const ValueKey<String>('loaded'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFFF8FAFC),
      ),
      padding: const EdgeInsets.all(20),
      child: rive.RiveWidget(
        controller: _manualController!,
        fit: rive.Fit.contain,
      ),
    );
  }
}

class _SharedTextureTile extends StatelessWidget {
  const _SharedTextureTile({
    required this.title,
    required this.fileLoader,
    required this.drawOrder,
  });

  final String title;
  final rive.FileLoader fileLoader;
  final int drawOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.white.withValues(alpha: 0.60),
            Colors.white.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: rive.RiveWidgetBuilder(
                fileLoader: fileLoader,
                builder: (BuildContext context, rive.RiveState state) {
                  return switch (state) {
                    rive.RiveLoading() => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    rive.RiveFailed() => const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                    ),
                    rive.RiveLoaded() => rive.RiveWidget(
                      controller: state.controller,
                      fit: rive.Fit.contain,
                      useSharedTexture: true,
                      drawOrder: drawOrder,
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Color(0xFFE2E8F0),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageBullet extends StatelessWidget {
  const _UsageBullet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.check_circle_outline, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <InlineSpan>[
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RiveErrorPanel extends StatelessWidget {
  const _RiveErrorPanel({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 28),
          const SizedBox(height: 12),
          Text(
            'Rive file failed to load',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'If this device is offline, the code samples above still show the expected API usage.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
