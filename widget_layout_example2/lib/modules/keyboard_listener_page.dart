import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class KeyboardListenerPage extends StatefulWidget {
  const KeyboardListenerPage({super.key});

  @override
  State<KeyboardListenerPage> createState() => _KeyboardListenerPageState();
}

class _KeyboardListenerPageState extends State<KeyboardListenerPage> {
  final FocusNode _listenerFocusNode = FocusNode(
    debugLabel: 'keyboard_listener_demo',
  );

  final List<String> _recentEvents = <String>[];

  Offset _dotOffset = const Offset(0, 0);
  int _shortcutCount = 0;
  bool _showGrid = true;
  String _lastKeyLabel = 'No key pressed yet';

  @override
  void initState() {
    super.initState();
    _listenerFocusNode.addListener(_handleFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _listenerFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _listenerFocusNode.removeListener(_handleFocusChange);
    _listenerFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return;
    }

    final LogicalKeyboardKey key = event.logicalKey;
    final String keyLabel = key.keyLabel.isEmpty
        ? key.debugName ?? key.toString()
        : key.keyLabel;

    setState(() {
      _lastKeyLabel = keyLabel;
      _recentEvents.insert(
        0,
        '${event.runtimeType}: ${key.debugName ?? keyLabel}',
      );
      if (_recentEvents.length > 8) {
        _recentEvents.removeLast();
      }

      const double step = 18;
      if (key == LogicalKeyboardKey.arrowUp) {
        _dotOffset = Offset(
          _dotOffset.dx,
          (_dotOffset.dy - step).clamp(-54, 54),
        );
      } else if (key == LogicalKeyboardKey.arrowDown) {
        _dotOffset = Offset(
          _dotOffset.dx,
          (_dotOffset.dy + step).clamp(-54, 54),
        );
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        _dotOffset = Offset(
          (_dotOffset.dx - step).clamp(-54, 54),
          _dotOffset.dy,
        );
      } else if (key == LogicalKeyboardKey.arrowRight) {
        _dotOffset = Offset(
          (_dotOffset.dx + step).clamp(-54, 54),
          _dotOffset.dy,
        );
      } else if (key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter) {
        _shortcutCount += 1;
      } else if (key == LogicalKeyboardKey.keyG) {
        _showGrid = !_showGrid;
      } else if (key == LogicalKeyboardKey.escape) {
        _dotOffset = Offset.zero;
        _shortcutCount = 0;
      }
    });
  }

  KeyEventResult _handleFocusKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.keyG ||
        key == LogicalKeyboardKey.escape) {
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('KeyboardListener Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'Listen to physical keyboard input with a focusable widget.',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This module demonstrates `KeyboardListener`, `FocusNode`, '
            '`autofocus`, `onKeyEvent`, arrow-key movement, and shortcut-like '
            'behaviors for Enter, Space, G, and Escape.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const _CodeSampleCard(),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Focusable Listener Surface',
            description:
                'Click the panel if it loses focus, then press keys on the keyboard. '
                'Only focused KeyboardListener widgets receive events.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: () => _listenerFocusNode.requestFocus(),
                      icon: const Icon(Icons.keyboard_outlined),
                      label: const Text('Focus Listener'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _listenerFocusNode.unfocus(),
                      icon: const Icon(Icons.blur_on_outlined),
                      label: const Text('Remove Focus'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Focus(
                  canRequestFocus: false,
                  skipTraversal: true,
                  onKeyEvent: _handleFocusKeyEvent,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _listenerFocusNode.requestFocus(),
                    child: KeyboardListener(
                      focusNode: _listenerFocusNode,
                      onKeyEvent: _handleKeyEvent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _listenerFocusNode.hasFocus
                              ? colorScheme.primaryContainer.withValues(
                                  alpha: 0.72,
                                )
                              : colorScheme.surfaceContainerHighest.withValues(
                                  alpha: 0.55,
                                ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _listenerFocusNode.hasFocus
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                            width: _listenerFocusNode.hasFocus ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  _listenerFocusNode.hasFocus
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: _listenerFocusNode.hasFocus
                                      ? colorScheme.primary
                                      : colorScheme.outline,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _listenerFocusNode.hasFocus
                                      ? 'Focused and listening'
                                      : 'Not focused',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Last key: $_lastKeyLabel',
                              style: theme.textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Click this panel to focus it, then try Arrow keys, Space, Enter, G, and Escape.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Arrow Key Movement',
            description:
                'KeyboardListener is useful for desktop-style interactions, game controls, editors, and custom focus surfaces.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Use the arrow keys to move the marker.',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.82),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              if (_showGrid)
                                CustomPaint(
                                  size: const Size(180, 180),
                                  painter: _GridPainter(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 120),
                                curve: Curves.easeOut,
                                left: 78 + _dotOffset.dx,
                                top: 78 + _dotOffset.dy,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.secondary,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: colorScheme.secondary.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Offset: (${_dotOffset.dx.toInt()}, ${_dotOffset.dy.toInt()})',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Shortcut Style Commands',
            description:
                'Use KeyboardListener to map physical keys to app-specific actions when you do not need the full Shortcuts/Actions system.',
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: <Widget>[
                _CommandTile(
                  title: 'Space or Enter',
                  value: 'Counter: $_shortcutCount',
                  subtitle: 'Press either key to increment the counter.',
                  accentColor: const Color(0xFF0F766E),
                ),
                _CommandTile(
                  title: 'G',
                  value: _showGrid ? 'Grid is visible' : 'Grid is hidden',
                  subtitle: 'Toggles the movement board background.',
                  accentColor: const Color(0xFFC2410C),
                ),
                _CommandTile(
                  title: 'Escape',
                  value: 'Reset board and counter',
                  subtitle:
                      'Returns the marker to center and clears the count.',
                  accentColor: const Color(0xFF7C3AED),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Recent Key Events',
            description:
                'A simple event log is useful when debugging keyboard input or teaching how key events flow through a focused widget.',
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _recentEvents.isEmpty
                      ? const <Widget>[
                          Text(
                            'No keyboard activity yet. Focus the panel and type.',
                          ),
                        ]
                      : _recentEvents
                            .map((String event) => Text(event))
                            .toList(),
                ),
              ),
            ),
          ),
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

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            height: 1.5,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('KeyboardListener('),
              Text('  focusNode: focusNode,'),
              Text('  autofocus: true,'),
              Text('  onKeyEvent: (KeyEvent event) {'),
              Text('    // handle arrows, Enter, Escape...'),
              Text('  },'),
              Text('  child: ... ,'),
              Text(')'),
            ],
          ),
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

class _CommandTile extends StatelessWidget {
  const _CommandTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accentColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1;

    const double step = 36;
    for (double offset = step; offset < size.width; offset += step) {
      canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
      canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
