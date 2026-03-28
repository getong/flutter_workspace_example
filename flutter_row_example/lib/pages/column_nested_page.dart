import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColumnNestedPage extends StatelessWidget {
  const ColumnNestedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Column Nested Layout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 80,
              color: Colors.indigo.shade100,
              alignment: Alignment.center,
              child: const Text('Top Banner (fixed height)'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.indigo.shade200,
                      child: Column(
                        children: <Widget>[
                          _menuTile('Overview'),
                          _menuTile('Orders'),
                          _menuTile('Settings'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: Colors.indigo.shade50,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: const Text('Chart Section'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: const Text('Table Section'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

  Widget _menuTile(String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        color: Colors.indigo.shade300,
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
