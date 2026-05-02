import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.focusableActionDetector)
class FocusableActionDetectorPage extends StatelessWidget {
  const FocusableActionDetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusableActionDetector Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FocusableActionDetector combines focus, hover, shortcuts, and actions in one widget. It is useful for building custom controls that still behave well with mouse and keyboard input.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _ActionDetectorExampleCard(
              title: 'Keyboard-Activatable Command Tile',
              description:
                  'Enter and Space trigger ActivateIntent while hover and focus highlights update the custom tile.',
              api:
                  'Uses: FocusableActionDetector + ActivateIntent + highlight callbacks',
              child: _CommandTilePreview(),
            ),
            const SizedBox(height: 16),
            const _ActionDetectorExampleCard(
              title: 'Custom Shortcut Intent',
              description:
                  'You can bind your own intent and action so a custom surface responds to app-specific shortcuts.',
              api: 'Uses: shortcuts + actions + custom Intent class',
              child: _FavoriteShortcutPreview(),
            ),
            const SizedBox(height: 16),
            const _ActionDetectorExampleCard(
              title: 'Focus Status Readout',
              description:
                  'This example uses focus changes and hover changes to expose the current interaction state for a reusable control.',
              api: 'Uses: onFocusChange + onShowHoverHighlight + mouseCursor',
              child: _InteractionStatusPreview(),
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

class _CommandTilePreview extends StatefulWidget {
  const _CommandTilePreview();

  @override
  State<_CommandTilePreview> createState() => _CommandTilePreviewState();
}

class _CommandTilePreviewState extends State<_CommandTilePreview> {
  bool _hovered = false;
  bool _focused = false;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final bool active = _hovered || _focused;

    return FocusableActionDetector(
      autofocus: true,
      mouseCursor: SystemMouseCursors.click,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) {
            setState(() => _count += 1);
            return null;
          },
        ),
      },
      onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
      onShowFocusHighlight: (bool value) => setState(() => _focused = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: active ? Colors.indigo.shade50 : Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? Colors.indigo : Colors.blueGrey.shade200,
            width: active ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: active ? Colors.indigo : Colors.blueGrey,
              foregroundColor: Colors.white,
              child: const Icon(Icons.keyboard_command_key),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Open Command Palette',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Activated $_count time${_count == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Text('Enter / Space'),
          ],
        ),
      ),
    );
  }
}

class _ToggleFavoriteIntent extends Intent {
  const _ToggleFavoriteIntent();
}

class _FavoriteShortcutPreview extends StatefulWidget {
  const _FavoriteShortcutPreview();

  @override
  State<_FavoriteShortcutPreview> createState() =>
      _FavoriteShortcutPreviewState();
}

class _FavoriteShortcutPreviewState extends State<_FavoriteShortcutPreview> {
  bool _starred = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyD, control: true):
            _ToggleFavoriteIntent(),
      },
      actions: <Type, Action<Intent>>{
        _ToggleFavoriteIntent: CallbackAction<_ToggleFavoriteIntent>(
          onInvoke: (_ToggleFavoriteIntent intent) {
            setState(() => _starred = !_starred);
            return null;
          },
        ),
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              _starred ? Icons.star_rounded : Icons.star_border_rounded,
              color: Colors.amber.shade700,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _starred
                    ? 'Dashboard pinned to favorites'
                    : 'Press Ctrl + D while focused to pin this dashboard',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractionStatusPreview extends StatefulWidget {
  const _InteractionStatusPreview();

  @override
  State<_InteractionStatusPreview> createState() =>
      _InteractionStatusPreviewState();
}

class _InteractionStatusPreviewState extends State<_InteractionStatusPreview> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final String status = _focused
        ? 'Focused'
        : _hovered
        ? 'Hovered'
        : 'Idle';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FocusableActionDetector(
          mouseCursor: SystemMouseCursors.precise,
          onShowHoverHighlight: (bool value) =>
              setState(() => _hovered = value),
          onFocusChange: (bool value) => setState(() => _focused = value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _focused
                  ? Colors.teal.shade50
                  : _hovered
                  ? Colors.cyan.shade50
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Move the mouse here or focus this surface with Tab.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Current state: $status'),
      ],
    );
  }
}

class _ActionDetectorExampleCard extends StatelessWidget {
  const _ActionDetectorExampleCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
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
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
