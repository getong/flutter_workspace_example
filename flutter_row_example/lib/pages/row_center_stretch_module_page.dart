import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RowCenterStretchModulePage extends StatefulWidget {
  const RowCenterStretchModulePage({super.key});

  @override
  State<RowCenterStretchModulePage> createState() =>
      _RowCenterStretchModulePageState();
}

class _RowCenterStretchModulePageState
    extends State<RowCenterStretchModulePage> {
  String? _hoveredValue;

  void _showClickValue(String value) {
    debugPrint(value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  List<Widget> boxes(int n, double w, double h) {
    final List<Widget> bxs = <Widget>[];
    const List<Color> fill = <Color>[
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.pink,
    ];

    for (int i = 0; i <= n - 1; i++) {
      final String value = i.toString();
      final Widget bx = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hoveredValue = value;
          });
        },
        onExit: (_) {
          setState(() {
            _hoveredValue = null;
          });
        },
        child: GestureDetector(
          onTap: () => _showClickValue(value),
          child: Container(
            alignment: Alignment.center,
            color: fill[i % fill.length],
            width: w,
            height: h,
            child: Text(value),
          ),
        ),
      );
      bxs.add(bx);
    }

    return bxs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row Center Stretch Module')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _hoveredValue == null
                  ? 'Hover on a box to see i'
                  : 'Hover: $_hoveredValue',
            ),
            const SizedBox(height: 12),
            Container(
              width: 260,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[Colors.blue, Colors.orange],
                ),
                shape: BoxShape.rectangle,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: boxes(4, 40, 40),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
        ),
      ],
    );
  }
}
