import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shader_graph/shader_graph.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.shaderGraph)
class ShaderGraphPage extends StatelessWidget {
  const ShaderGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('shader_graph Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'shader_graph lets Flutter drive single-pass shaders, multi-pass pipelines, widget inputs, keyboard textures, and animation control from normal widget code.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `ShaderSurface.auto`, `ShaderSurface.builder`, `ShaderBuffer`, `setUniform`, `feedWidgetInput`, `feedShader`, `feedKeyboard`, and `ShaderController` with local shader assets.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const <Widget>[
              _ApiChip(label: 'ShaderSurface.auto'),
              _ApiChip(label: 'ShaderSurface.builder'),
              _ApiChip(label: 'ShaderBuffer'),
              _ApiChip(label: 'setUniform'),
              _ApiChip(label: 'feedWidgetInput'),
              _ApiChip(label: 'feedShader'),
              _ApiChip(label: 'feedKeyboard'),
              _ApiChip(label: 'ShaderController'),
            ],
          ),
          const SizedBox(height: 24),
          const _SinglePassShaderDemo(),
          const SizedBox(height: 20),
          const _WidgetInputShaderDemo(),
          const SizedBox(height: 20),
          const _BuilderShaderDemo(),
          const SizedBox(height: 20),
          const _KeyboardInputShaderDemo(),
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

class _SinglePassShaderDemo extends StatefulWidget {
  const _SinglePassShaderDemo();

  @override
  State<_SinglePassShaderDemo> createState() => _SinglePassShaderDemoState();
}

class _SinglePassShaderDemoState extends State<_SinglePassShaderDemo> {
  static const List<Color> _palette = <Color>[
    Color(0xFF63D5FF),
    Color(0xFFFF8A5B),
    Color(0xFF7DFFB4),
    Color(0xFFF6D365),
  ];

  final ShaderController _heroController = ShaderController();
  late final ShaderBuffer _heroBuffer = ShaderBuffer(
    'shaders/shader_graph/aurora_auto.frag',
  );

  bool _heroPaused = false;
  int _paletteIndex = 0;
  double _pulseStrength = 0.58;

  @override
  void initState() {
    super.initState();
    _syncHeroBuffer();
  }

  void _syncHeroBuffer() {
    _heroBuffer
      ..setUniform(0, _pulseStrength)
      ..setUniform(1, _palette[_paletteIndex]);
  }

  void _toggleHeroPlayback() {
    setState(() {
      _heroPaused = !_heroPaused;
      if (_heroPaused) {
        _heroController.pause();
      } else {
        _heroController.resume();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return _DemoSection(
      title: 'Single-pass Surface',
      description:
          'A reusable `ShaderBuffer` powers an animated hero panel. The slider updates a custom uniform, the palette chips push a `Color` uniform, and the button drives `ShaderController.pause()` / `resume()`.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ShaderSurface.auto(
                _heroBuffer,
                shaderController: _heroController,
                upSideDown: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              FilledButton.icon(
                onPressed: _toggleHeroPlayback,
                icon: Icon(
                  _heroPaused ? Icons.play_arrow_rounded : Icons.pause,
                ),
                label: Text(_heroPaused ? 'Resume shader' : 'Pause shader'),
              ),
              Text(
                'Drag on the shader to move the highlight hotspot.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Pulse Strength',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _pulseStrength,
            min: 0.1,
            max: 1.3,
            onChanged: (double value) {
              setState(() {
                _pulseStrength = value;
                _syncHeroBuffer();
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Accent Palette',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List<Widget>.generate(_palette.length, (int index) {
              final Color color = _palette[index];
              return ChoiceChip(
                label: Text('Theme ${index + 1}'),
                selectedColor: color.withValues(alpha: 0.22),
                avatar: CircleAvatar(backgroundColor: color),
                selected: _paletteIndex == index,
                onSelected: (bool selected) {
                  if (!selected) {
                    return;
                  }
                  setState(() {
                    _paletteIndex = index;
                    _syncHeroBuffer();
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          const _CodeBlock(
            code:
                "final heroBuffer = ShaderBuffer('shaders/shader_graph/aurora_auto.frag')\n"
                "  ..setUniform(0, pulseStrength)\n"
                "  ..setUniform(1, accentColor);\n\n"
                "ShaderSurface.auto(\n"
                "  heroBuffer,\n"
                "  shaderController: heroController,\n"
                "  upSideDown: false,\n"
                ")",
          ),
        ],
      ),
    );
  }
}

class _WidgetInputShaderDemo extends StatefulWidget {
  const _WidgetInputShaderDemo();

  @override
  State<_WidgetInputShaderDemo> createState() => _WidgetInputShaderDemoState();
}

class _WidgetInputShaderDemoState extends State<_WidgetInputShaderDemo> {
  late final ShaderBuffer _widgetInputBuffer = ShaderBuffer(
    'shaders/shader_graph/widget_input.frag',
  )..feedWidgetInput(const _ShaderGraphSourceCard());

  double _widgetWarp = 0.42;

  @override
  void initState() {
    super.initState();
    _widgetInputBuffer.setUniform(0, _widgetWarp);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return _DemoSection(
      title: 'Widget Input Surface',
      description:
          'A normal Flutter widget is rendered into a texture and sampled by the shader. This uses the string DSL, so the widget is attached with `.feed(...)` before it reaches `ShaderSurface.auto`.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ShaderSurface.auto(_widgetInputBuffer, upSideDown: false),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Widget Warp',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _widgetWarp,
            min: 0.0,
            max: 1.0,
            onChanged: (double value) {
              setState(() {
                _widgetWarp = value;
                _widgetInputBuffer.setUniform(0, _widgetWarp);
              });
            },
          ),
          const SizedBox(height: 16),
          const _CodeBlock(
            code:
                "final inputBuffer = ShaderBuffer('shaders/shader_graph/widget_input.frag')\n"
                "  ..feedWidgetInput(const ShaderGraphSourceCard())\n"
                "  ..setUniform(0, widgetWarp);\n\n"
                "ShaderSurface.auto(inputBuffer, upSideDown: false)",
          ),
        ],
      ),
    );
  }
}

class _BuilderShaderDemo extends StatefulWidget {
  const _BuilderShaderDemo();

  @override
  State<_BuilderShaderDemo> createState() => _BuilderShaderDemoState();
}

class _BuilderShaderDemoState extends State<_BuilderShaderDemo> {
  double _builderEnergy = 0.74;
  double _builderBlend = 0.48;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return _DemoSection(
      title: 'Builder + Multi-pass Composition',
      description:
          'This section rebuilds a small graph with `ShaderSurface.builder`. The first pass generates an animated texture, and the second pass composites that buffer with another Flutter widget input.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ShaderSurface.builder(
                () {
                  final ShaderBuffer bufferA = ShaderBuffer(
                    'shaders/shader_graph/buffer_a.frag',
                  )..setUniform(0, _builderEnergy);
                  final ShaderBuffer composite =
                      ShaderBuffer('shaders/shader_graph/composite.frag')
                        ..feedShader(bufferA)
                        ..feedWidgetInput(const _MetricsBoard())
                        ..setUniform(0, _builderBlend);
                  return <ShaderBuffer>[bufferA, composite];
                },
                key: ValueKey<String>(
                  'multi-pass-${_builderEnergy.toStringAsFixed(2)}-${_builderBlend.toStringAsFixed(2)}',
                ),
                upSideDown: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pass A Energy',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _builderEnergy,
            min: 0.0,
            max: 1.0,
            onChanged: (double value) {
              setState(() {
                _builderEnergy = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Composite Blend',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _builderBlend,
            min: 0.0,
            max: 1.0,
            onChanged: (double value) {
              setState(() {
                _builderBlend = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const _CodeBlock(
            code:
                "ShaderSurface.builder(() {\n"
                "  final bufferA = ShaderBuffer('shaders/shader_graph/buffer_a.frag')\n"
                "    ..setUniform(0, builderEnergy);\n"
                "  final composite = ShaderBuffer('shaders/shader_graph/composite.frag')\n"
                "    ..feedShader(bufferA)\n"
                "    ..feedWidgetInput(const MetricsBoard())\n"
                "    ..setUniform(0, builderBlend);\n"
                "  return [bufferA, composite];\n"
                "}, upSideDown: false)",
          ),
        ],
      ),
    );
  }
}

class _KeyboardInputShaderDemo extends StatefulWidget {
  const _KeyboardInputShaderDemo();

  @override
  State<_KeyboardInputShaderDemo> createState() =>
      _KeyboardInputShaderDemoState();
}

class _KeyboardInputShaderDemoState extends State<_KeyboardInputShaderDemo> {
  late final ShaderBuffer _keyboardBuffer =
      'shaders/shader_graph/keyboard_showcase.frag'.shaderBuffer
        ..feedKeyboard();

  @override
  Widget build(BuildContext context) {
    return _DemoSection(
      title: 'Keyboard Texture Input',
      description:
          'The shader samples the keyboard texture generated by `feedKeyboard()`. Tap the panel below, then press `W`, `A`, `S`, `D`, arrow keys, or space to light up the controls.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ShaderSurface.auto(_keyboardBuffer, upSideDown: false),
            ),
          ),
          const SizedBox(height: 16),
          const _CodeBlock(
            code:
                "final keyboardBuffer = 'shaders/shader_graph/keyboard_showcase.frag'\n"
                "    .shaderBuffer\n"
                "  ..feedKeyboard();\n\n"
                "ShaderSurface.auto(keyboardBuffer, upSideDown: false)",
          ),
        ],
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _ApiChip extends StatelessWidget {
  const _ApiChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _ShaderGraphSourceCard extends StatelessWidget {
  const _ShaderGraphSourceCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF0F172A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Flutter Widget Input',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This card is drawn by Flutter first, then sampled inside a shader as iChannel0.',
              style: TextStyle(color: Color(0xFFDCE7FF), fontSize: 16),
            ),
            const Spacer(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const <Widget>[
                _MetricPill(
                  label: 'Texture Source',
                  value: 'Widget',
                  color: Color(0xFF7DD3FC),
                ),
                _MetricPill(
                  label: 'Upload Path',
                  value: 'feedWidgetInput',
                  color: Color(0xFFF9A8D4),
                ),
                _MetricPill(
                  label: 'Surface',
                  value: 'ShaderSurface.auto',
                  color: Color(0xFFFDE68A),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsBoard extends StatelessWidget {
  const _MetricsBoard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF111827), Color(0xFF134E4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Builder Overlay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'A second Flutter widget is composited with the animated pass buffer.',
              style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Row(
              children: <Widget>[
                Expanded(
                  child: _MetricPill(
                    label: 'Pipeline',
                    value: '2 Passes',
                    color: Color(0xFF5EEAD4),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MetricPill(
                    label: 'Inputs',
                    value: 'Buffer + Widget',
                    color: Color(0xFF93C5FD),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: <Widget>[
                Expanded(
                  child: _MetricPill(
                    label: 'Frame Sync',
                    value: 'Live',
                    color: Color(0xFFFDE68A),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _MetricPill(
                    label: 'API',
                    value: 'ShaderSurface.builder',
                    color: Color(0xFFFCA5A5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFD1D5DB),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
