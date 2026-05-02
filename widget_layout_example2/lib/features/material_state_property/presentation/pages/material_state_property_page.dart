import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.materialStateProperty)
class MaterialStatePropertyPage extends StatelessWidget {
  const MaterialStatePropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MaterialStateProperty Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'MaterialStateProperty is the state-aware value pattern used by Material components such as buttons, checkboxes, and themes. In current Flutter APIs, the same behavior is powered by WidgetStateProperty, so the examples use that implementation to avoid deprecated code.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _MaterialStateExampleCard(
              title: 'State-Resolved FilledButton',
              description:
                  'Background color, foreground color, and overlay color can all react to pressed, hovered, focused, and disabled states.',
              api: 'Uses: WidgetStateProperty.resolveWith inside ButtonStyle',
              child: _ResolvedButtonPreview(),
            ),
            const SizedBox(height: 16),
            const _MaterialStateExampleCard(
              title: 'Checkbox Fill And Overlay Colors',
              description:
                  'Selection state and disabled state can each provide their own visual treatment.',
              api: 'Uses: state-aware fillColor and overlayColor',
              child: _CheckboxStatePreview(),
            ),
            const SizedBox(height: 16),
            const _MaterialStateExampleCard(
              title: 'OutlinedButton Border And Cursor',
              description:
                  'You can resolve borders, cursors, and text colors from the same state set to keep interactions consistent.',
              api:
                  'Uses: WidgetStateProperty for side, foregroundColor, and mouseCursor',
              child: _OutlinedStatePreview(),
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

class _ResolvedButtonPreview extends StatefulWidget {
  const _ResolvedButtonPreview();

  @override
  State<_ResolvedButtonPreview> createState() => _ResolvedButtonPreviewState();
}

class _ResolvedButtonPreviewState extends State<_ResolvedButtonPreview> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FilledButton(
          onPressed: _enabled ? () {} : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey.shade400;
              }
              if (states.contains(WidgetState.pressed)) {
                return Colors.indigo.shade900;
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.indigo.shade600;
              }
              return Colors.indigo;
            }),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) =>
                  states.contains(WidgetState.pressed) ? Colors.white24 : null,
            ),
          ),
          child: const Text('Deploy Release'),
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _enabled,
          onChanged: (bool value) => setState(() => _enabled = value),
          title: const Text('Enabled'),
        ),
      ],
    );
  }
}

class _CheckboxStatePreview extends StatefulWidget {
  const _CheckboxStatePreview();

  @override
  State<_CheckboxStatePreview> createState() => _CheckboxStatePreviewState();
}

class _CheckboxStatePreviewState extends State<_CheckboxStatePreview> {
  bool _checked = true;
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckboxListTile(
          value: _checked,
          onChanged: _enabled
              ? (bool? value) => setState(() => _checked = value ?? false)
              : null,
          title: const Text('Send me weekly product updates'),
          fillColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade400;
            }
            if (states.contains(WidgetState.selected)) {
              return Colors.green.shade600;
            }
            return Colors.grey.shade300;
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) => states.contains(WidgetState.hovered)
                ? Colors.green.withValues(alpha: 0.10)
                : null,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: _enabled,
          onChanged: (bool value) => setState(() => _enabled = value),
          title: const Text('Checkbox enabled'),
        ),
      ],
    );
  }
}

class _OutlinedStatePreview extends StatelessWidget {
  const _OutlinedStatePreview();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: () {},
          style: ButtonStyle(
            side: WidgetStateProperty.resolveWith<BorderSide?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return const BorderSide(color: Colors.deepOrange, width: 2);
              }
              if (states.contains(WidgetState.hovered)) {
                return const BorderSide(color: Colors.orange, width: 2);
              }
              return BorderSide(color: Colors.orange.shade300);
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => states.contains(WidgetState.hovered)
                  ? Colors.deepOrange
                  : Colors.orange.shade800,
            ),
            mouseCursor: WidgetStateProperty.resolveWith<MouseCursor?>(
              (Set<WidgetState> states) => states.contains(WidgetState.disabled)
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
            ),
          ),
          icon: const Icon(Icons.download_outlined),
          label: const Text('Export CSV'),
        ),
        OutlinedButton(onPressed: null, child: const Text('Disabled')),
      ],
    );
  }
}

class _MaterialStateExampleCard extends StatelessWidget {
  const _MaterialStateExampleCard({
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
