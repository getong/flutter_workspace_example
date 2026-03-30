import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/demo_scaffold.dart';

class RowSuperPage extends StatefulWidget {
  const RowSuperPage({super.key});

  @override
  State<RowSuperPage> createState() => _RowSuperPageState();
}

class _RowSuperPageState extends State<RowSuperPage> {
  double _availableWidth = 360;

  @override
  Widget build(BuildContext context) {
    return DemoPageScaffold(
      title: 'RowSuper',
      subtitle:
          'A row layout that can overlap, separate, fill available width '
          'and optionally shrink children horizontally.',
      accent: const Color(0xFF1D4ED8),
      children: <Widget>[
        DemoSection(
          title: 'Overlap and separators',
          description:
              'Negative inner distance lets cells overlap without the '
              'usual overflow warnings.',
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: <Widget>[
              _samplePanel(
                label: 'Layered avatars',
                child: RowSuper(
                  innerDistance: -18,
                  invert: true,
                  children: <Widget>[
                    _avatar('AL', const Color(0xFF0F766E)),
                    _avatar('BK', const Color(0xFFEA580C)),
                    _avatar('CM', const Color(0xFF7C3AED)),
                    _avatar('DN', const Color(0xFFBE123C)),
                  ],
                ),
              ),
              _samplePanel(
                label: 'Separated metrics',
                child: RowSuper(
                  innerDistance: 16,
                  separator: Container(
                    width: 2,
                    height: 48,
                    color: Colors.black12,
                  ),
                  children: <Widget>[
                    _metric('98%', 'Success'),
                    _metric('14', 'Alerts'),
                    _metric('3m', 'Lead time'),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Adaptive toolbar',
          description:
              'Turn on `fitHorizontally` when a dense row should stay '
              'usable in tighter widths.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Available width: ${_availableWidth.round()} px'),
              Slider(
                value: _availableWidth,
                min: 220,
                max: 520,
                divisions: 15,
                label: _availableWidth.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _availableWidth = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              _toolbarCard(
                label: 'Without fitHorizontally',
                child: SizedBox(
                  width: _availableWidth,
                  child: RowSuper(
                    outerDistance: 12,
                    innerDistance: 12,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _toolbarTitle(),
                      RowSpacer(),
                      _actionChip('Preview'),
                      _actionChip('Share'),
                      _actionChip('Promote'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _toolbarCard(
                label: 'With fitHorizontally',
                child: SizedBox(
                  width: _availableWidth,
                  child: RowSuper(
                    outerDistance: 12,
                    innerDistance: 12,
                    fitHorizontally: true,
                    mainAxisSize: MainAxisSize.max,
                    separator: Container(
                      width: 1,
                      height: 28,
                      color: Colors.black12,
                    ),
                    children: <Widget>[
                      _toolbarTitle(),
                      RowSpacer(),
                      _actionChip('Preview'),
                      _actionChip('Share'),
                      _actionChip('Promote'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Fill behavior',
          description:
              '`fill: true` distributes width proportionally instead of '
              'leaving unused space.',
          child: SizedBox(
            width: double.infinity,
            child: RowSuper(
              innerDistance: 14,
              fill: true,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _fillCard('Planning', '8 tasks'),
                _fillCard('Review', '2 blockers'),
                _fillCard('Ship', '1 release'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _samplePanel({required String label, required Widget child}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _toolbarCard({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ClipRect(child: child),
        ],
      ),
    );
  }

  Widget _avatar(String initials, Color color) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 3),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _metric(String value, String label) {
    return Box(
      padding: const Pad(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _toolbarTitle() {
    return const Text(
      'Quarterly release readiness review',
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _actionChip(String label) {
    return Box(
      color: const Color(0xFFE0F2FE),
      padding: const Pad(horizontal: 12, vertical: 8),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    );
  }

  Widget _fillCard(String title, String subtitle) {
    return Box(
      color: const Color(0xFFE0E7FF),
      padding: const Pad(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}
