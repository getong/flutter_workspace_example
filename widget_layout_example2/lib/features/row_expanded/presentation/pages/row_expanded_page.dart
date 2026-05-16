import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.rowExpanded)
class RowExpandedPage extends StatelessWidget {
  const RowExpandedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: Row(
          children: <Widget>[
            Expanded(flex: 2, child: Container(color: Colors.amber)),
            Expanded(flex: 1, child: Container(color: Colors.blue)),
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
