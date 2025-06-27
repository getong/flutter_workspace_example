import 'package:flutter/material.dart';

class CustomSafeAreaExample extends StatefulWidget {
  const CustomSafeAreaExample({super.key});

  @override
  State<CustomSafeAreaExample> createState() => _CustomSafeAreaExampleState();
}

class _CustomSafeAreaExampleState extends State<CustomSafeAreaExample> {
  bool top = true;
  bool bottom = true;
  bool left = true;
  bool right = true;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Custom Configuration'),
          backgroundColor: Colors.teal,
          pinned: true,
        ),

        SliverToBoxAdapter(
          child: Container(
            color: Colors.teal.shade50,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Customize SliverSafeArea Edges',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Top'),
                      selected: top,
                      onSelected: (value) => setState(() => top = value),
                    ),
                    FilterChip(
                      label: const Text('Bottom'),
                      selected: bottom,
                      onSelected: (value) => setState(() => bottom = value),
                    ),
                    FilterChip(
                      label: const Text('Left'),
                      selected: left,
                      onSelected: (value) => setState(() => left = value),
                    ),
                    FilterChip(
                      label: const Text('Right'),
                      selected: right,
                      onSelected: (value) => setState(() => right = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SliverSafeArea(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Text(
                    'Item ${index + 1}\nSafeArea: top:$top, bottom:$bottom, left:$left, right:$right',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
              childCount: 10,
            ),
          ),
        ),
      ],
    );
  }
}
