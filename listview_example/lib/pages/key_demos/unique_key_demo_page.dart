import 'package:flutter/material.dart';

import 'key_demo_shell.dart';

class UniqueKeyDemoPage extends StatelessWidget {
  const UniqueKeyDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const KeyDemoShell(
      title: 'UniqueKey List',
      description:
          'Each ListTile gets a brand-new identity on rebuild, which is useful '
          'when you explicitly want Flutter to treat every row as unique.',
      child: Card(child: _UniqueMessagesList()),
    );
  }
}

class _UniqueMessagesList extends StatelessWidget {
  const _UniqueMessagesList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(key: UniqueKey(), title: Text('Message $index'));
      },
    );
  }
}
