import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TooltipPage extends StatefulWidget {
  const TooltipPage({super.key});

  @override
  State<TooltipPage> createState() => _TooltipPageState();
}

class _TooltipPageState extends State<TooltipPage> {
  final GlobalKey<TooltipState> _manualTooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tooltip Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Tooltip shows short help text for controls and status indicators. It is commonly triggered by hover on desktop and web, long press on mobile, and it can also be configured for richer or manual behavior.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _TooltipExampleCard(
              title: 'Basic Icon Tooltip',
              description:
                  'A simple message clarifies what an icon button does without taking up permanent screen space.',
              api: 'Uses: message',
              child: Row(
                children: <Widget>[
                  Tooltip(
                    message: 'Add a new reminder',
                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.add_alert_outlined),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Hover or long press the action button.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _TooltipExampleCard(
              title: 'Rich Tooltip Content',
              description:
                  'Tooltip.richMessage lets you mix styles for command names, keyboard hints, or highlighted values.',
              api: 'Uses: richMessage, decoration',
              child: Row(
                children: <Widget>[
                  Tooltip(
                    richMessage: TextSpan(
                      style: const TextStyle(color: Colors.white, height: 1.4),
                      children: <InlineSpan>[
                        const TextSpan(text: 'Shortcut: '),
                        TextSpan(
                          text: 'Cmd + Shift + P',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const TextSpan(text: '\nOpens the command palette.'),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Chip(
                      avatar: Icon(Icons.keyboard_command_key),
                      label: Text('Command Palette'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _TooltipExampleCard(
              title: 'Tap Trigger For Mobile',
              description:
                  'For touch-heavy UI, Tooltip can be configured to show on tap with custom positioning and durations.',
              api: 'Uses: triggerMode, waitDuration, showDuration, preferBelow',
              child: Row(
                children: <Widget>[
                  Tooltip(
                    message: 'Tap again to open trip details',
                    triggerMode: TooltipTriggerMode.tap,
                    waitDuration: Duration.zero,
                    showDuration: const Duration(seconds: 2),
                    preferBelow: false,
                    verticalOffset: 20,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Itinerary'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _TooltipExampleCard(
              title: 'Manual Tooltip Control',
              description:
                  'A tooltip can be shown programmatically, which is useful for teaching first-time users about a control.',
              api: 'Uses: GlobalKey<TooltipState> + ensureTooltipVisible()',
              child: Row(
                children: <Widget>[
                  Tooltip(
                    key: _manualTooltipKey,
                    triggerMode: TooltipTriggerMode.manual,
                    message: 'Refreshes analytics from the server',
                    child: const Icon(
                      Icons.refresh_rounded,
                      size: 28,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      _manualTooltipKey.currentState?.ensureTooltipVisible();
                    },
                    child: const Text('Show Tooltip'),
                  ),
                ],
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

class _TooltipExampleCard extends StatelessWidget {
  const _TooltipExampleCard({
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
