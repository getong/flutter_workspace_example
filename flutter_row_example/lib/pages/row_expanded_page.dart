import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RowExpandedPage extends StatelessWidget {
  const RowExpandedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row Expanded/Flex')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Expanded widgets split remaining width by flex.'),
            const SizedBox(height: 12),
            Container(
              height: 120,
              color: Colors.grey.shade100,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 70,
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const Text('70px'),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.lightBlue.shade200,
                      alignment: Alignment.center,
                      child: const Text('flex:1'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.lightBlue.shade400,
                      alignment: Alignment.center,
                      child: const Text('flex:2'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Use Spacer for adjustable gaps inside Row.'),
            const SizedBox(height: 12),
            const Row(
              children: <Widget>[
                Icon(Icons.settings),
                Spacer(),
                Icon(Icons.search),
                SizedBox(width: 12),
                Icon(Icons.more_vert),
              ],
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
