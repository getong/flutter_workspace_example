import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GridBasicsPage extends StatelessWidget {
  const GridBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid Basics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Example 1: GridView.count with fixed column count',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List<Widget>.generate(
                9,
                (int index) => _tile(
                  label: 'Item ${index + 1}',
                  color: Colors.indigo.shade100,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Example 2: GridView.count with childAspectRatio',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List<Widget>.generate(
                6,
                (int index) => _tile(
                  label: 'Tag ${index + 1}',
                  color: Colors.teal.shade100,
                ),
              ),
            ),
          ),
        ],
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

  Widget _tile({required String label, required Color color}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
