import 'package:flutter/material.dart';

class AdvancedSafeAreaExample extends StatelessWidget {
  const AdvancedSafeAreaExample({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Advanced Features'),
          backgroundColor: Colors.purple,
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            background: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),

        SliverSafeArea(
          top: false,
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.widgets,
                        size: 32,
                        color: Colors.primaries[index % Colors.primaries.length],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Grid Item\n${index + 1}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ),

        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Text(
                'This grid uses SliverSafeArea with top: false to avoid conflict with the SliverAppBar while still respecting bottom safe areas.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
