import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/demo_scaffold.dart';

class BoxPadPage extends StatefulWidget {
  const BoxPadPage({super.key});

  @override
  State<BoxPadPage> createState() => _BoxPadPageState();
}

class _BoxPadPageState extends State<BoxPadPage> {
  bool _showHelper = true;

  @override
  Widget build(BuildContext context) {
    return DemoPageScaffold(
      title: 'Box + Pad',
      subtitle:
          'Use Box for compact, const-friendly wrappers and Pad for '
          'easier spacing syntax.',
      accent: const Color(0xFF0F766E),
      children: <Widget>[
        DemoSection(
          title: 'Surface composition',
          description:
              'A `Box` can replace simple `Container` and `SizedBox` '
              'use cases without extra ceremony.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Box(
                color: const Color(0xFFE0F2F1),
                padding: const Pad(all: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sprint Brief',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Today we are polishing routing, tightening layout '
                      'examples, and converting the starter app into something '
                      'people can learn from.',
                    ),
                    const Box.gap(16),
                    Row(
                      children: <Widget>[
                        _pill('Ready', const Color(0xFF0F766E)),
                        const Box.gap(12),
                        _pill('4 demos', const Color(0xFF1D4ED8)),
                        const Box.gap(12),
                        _pill('go_router', const Color(0xFFEA580C)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Conditional padding',
          description:
              '`removePaddingWhenNoChild` keeps the layout tight when '
              'optional content disappears.',
          child: Column(
            children: <Widget>[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _showHelper,
                title: const Text('Show helper note'),
                subtitle: const Text('Toggles the child inside a padded Box.'),
                onChanged: (bool value) {
                  setState(() {
                    _showHelper = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Box(
                color: const Color(0xFFFFEDD5),
                padding: const Pad(all: 16),
                child: const Text(
                  'Primary content keeps its spacing regardless of the helper.',
                ),
              ),
              const SizedBox(height: 12),
              Box(
                color: const Color(0xFFFFF7ED),
                padding: const Pad(horizontal: 16, vertical: 12),
                removePaddingWhenNoChild: true,
                child: _showHelper
                    ? const Text(
                        'Helper copy is present, so the padding is also present.',
                      )
                    : null,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Readable spacing',
          description:
              '`Pad` makes insets easier to read and `Box.gap` gives '
              'you small visual spacers without extra widgets.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const Pad(all: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'Padding here uses Pad(all: 14), which reads closer to the '
                  'intent than EdgeInsets boilerplate.',
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  _legendDot(const Color(0xFF0F766E)),
                  const Box.gap(10),
                  const Text('Queued'),
                  const Box.gap(18),
                  _legendDot(const Color(0xFFEA580C)),
                  const Box.gap(10),
                  const Text('Review'),
                  const Box.gap(18),
                  _legendDot(const Color(0xFF7C3AED)),
                  const Box.gap(10),
                  const Text('Done'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill(String label, Color color) {
    return Box(
      color: color.withValues(alpha: 0.15),
      padding: const Pad(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Box(color: color, width: 12, height: 12);
  }
}
