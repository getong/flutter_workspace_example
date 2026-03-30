import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/demo_scaffold.dart';

class WrapSuperPage extends StatefulWidget {
  const WrapSuperPage({super.key});

  @override
  State<WrapSuperPage> createState() => _WrapSuperPageState();
}

class _WrapSuperPageState extends State<WrapSuperPage> {
  double _wrapWidth = 320;

  @override
  Widget build(BuildContext context) {
    return DemoPageScaffold(
      title: 'WrapSuper',
      subtitle:
          'Balanced wrapping and fill strategies for tags, filters and '
          'dense option sets.',
      accent: const Color(0xFFEA580C),
      children: <Widget>[
        DemoSection(
          title: 'Fit vs balanced wrapping',
          description:
              'The balanced algorithm aims for more even line widths '
              'than a standard greedy wrap.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Available width: ${_wrapWidth.round()} px'),
              Slider(
                value: _wrapWidth,
                min: 220,
                max: 480,
                divisions: 13,
                label: _wrapWidth.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _wrapWidth = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              _wrapComparison(
                label: 'WrapType.fit',
                child: WrapSuper(
                  wrapType: WrapType.fit,
                  spacing: 10,
                  lineSpacing: 10,
                  children: _filters(),
                ),
              ),
              const SizedBox(height: 12),
              _wrapComparison(
                label: 'WrapType.balanced',
                child: WrapSuper(
                  wrapType: WrapType.balanced,
                  spacing: 10,
                  lineSpacing: 10,
                  children: _filters(),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'WrapFit strategies',
          description:
              '`WrapFit.larger` expands smaller items to use the line '
              'more evenly without crushing already-wide items.',
          child: WrapSuper(
            wrapType: WrapType.balanced,
            wrapFit: WrapFit.larger,
            spacing: 12,
            lineSpacing: 12,
            children: <Widget>[
              _sizedTag('Planning', 92),
              _sizedTag('Discovery', 130),
              _sizedTag('Implementation', 156),
              _sizedTag('QA', 60),
              _sizedTag('Launch', 74),
              _sizedTag('Docs', 66),
            ],
          ),
        ),
      ],
    );
  }

  Widget _wrapComparison({required String label, required Widget child}) {
    return Container(
      width: _wrapWidth,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFED7AA)),
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

  List<Widget> _filters() {
    return <Widget>[
      _chip('Release'),
      _chip('Hotfix'),
      _chip('Experiment'),
      _chip('Critical priority'),
      _chip('Performance'),
      _chip('Accessibility'),
      _chip('Regression'),
    ];
  }

  Widget _chip(String label) {
    return Box(
      color: const Color(0xFFFFEDD5),
      padding: const Pad(horizontal: 14, vertical: 10),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _sizedTag(String label, double width) {
    return Box(
      color: const Color(0xFFFFEDD5),
      width: width,
      padding: const Pad(vertical: 10, horizontal: 12),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
