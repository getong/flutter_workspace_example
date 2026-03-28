import 'package:flutter/material.dart';

import 'back_home_button.dart';

class ListViewBuilderPage extends StatelessWidget {
  const ListViewBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView.builder')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          final int itemNumber = index + 1;
          final Color stripeColor = index.isEven
              ? Colors.blueGrey.shade50
              : Colors.blueGrey.shade100;

          return Card(
            color: stripeColor,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey.shade700,
                foregroundColor: Colors.white,
                child: Text(itemNumber.toString()),
              ),
              title: Text('Lazy item $itemNumber'),
              subtitle: Text('Rendered only when visible in viewport.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }
}
