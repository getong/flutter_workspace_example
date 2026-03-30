import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/demo_scaffold.dart';

class ColumnSuperPage extends StatefulWidget {
  const ColumnSuperPage({super.key});

  @override
  State<ColumnSuperPage> createState() => _ColumnSuperPageState();
}

class _ColumnSuperPageState extends State<ColumnSuperPage> {
  bool _showPaused = true;

  @override
  Widget build(BuildContext context) {
    return DemoPageScaffold(
      title: 'ColumnSuper',
      subtitle:
          'A column layout for overlaps, separators and more deliberate '
          'vertical stacking.',
      accent: const Color(0xFF7C3AED),
      children: <Widget>[
        DemoSection(
          title: 'Stacked timeline cards',
          description:
              'Negative spacing creates a layered vertical rhythm that '
              'is difficult to achieve cleanly with plain Column.',
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: ColumnSuper(
                innerDistance: -18,
                invert: true,
                children: <Widget>[
                  _timelineCard(
                    title: 'Design review',
                    subtitle: 'Final spacing pass and motion polish.',
                    color: const Color(0xFFEDE9FE),
                  ),
                  _timelineCard(
                    title: 'QA sweep',
                    subtitle: 'Edge-case resizing in narrow breakpoints.',
                    color: const Color(0xFFDDD6FE),
                  ),
                  _timelineCard(
                    title: 'Launch window',
                    subtitle: 'Staged rollout after documentation update.',
                    color: const Color(0xFFC4B5FD),
                  ),
                ],
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Separators',
          description:
              'Separators are painted between children without taking '
              'up their own layout space.',
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: ColumnSuper(
                innerDistance: 18,
                separator: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 17),
                    width: 2,
                    height: 44,
                    color: const Color(0xFFD8B4FE),
                  ),
                ),
                children: <Widget>[
                  _eventRow('Queued', 'Waiting for approval'),
                  _eventRow('Running', 'Deploying smoke test suite'),
                  _eventRow('Completed', 'Report published to the team'),
                ],
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Zero-height handling',
          description:
              'Set `removeChildrenWithNoHeight` when optional children '
              'should not leave phantom spacing behind.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _showPaused,
                title: const Text('Show paused state'),
                subtitle: const Text(
                  'When hidden, the empty child is ignored by ColumnSuper.',
                ),
                onChanged: (bool value) {
                  setState(() {
                    _showPaused = value;
                  });
                },
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ColumnSuper(
                    innerDistance: 12,
                    removeChildrenWithNoHeight: true,
                    separator: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.black12,
                    ),
                    children: <Widget>[
                      _statusTile('Queued'),
                      _statusTile('Processing'),
                      _showPaused
                          ? _statusTile('Paused')
                          : const SizedBox.shrink(),
                      _statusTile('Complete'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timelineCard({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Box(
      color: color,
      padding: const Pad(all: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(subtitle),
        ],
      ),
    );
  }

  Widget _eventRow(String title, String subtitle) {
    return Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFF7C3AED),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Box(
            color: const Color(0xFFF5F3FF),
            padding: const Pad(all: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusTile(String label) {
    return Box(
      color: const Color(0xFFF5F3FF),
      padding: const Pad(all: 14),
      child: Row(
        children: <Widget>[
          const Icon(Icons.circle, size: 12, color: Color(0xFF7C3AED)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
