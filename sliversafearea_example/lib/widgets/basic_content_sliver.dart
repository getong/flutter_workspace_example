import 'package:flutter/material.dart';

class BasicContentSliver extends StatelessWidget {
  final bool useSafeArea;
  
  const BasicContentSliver({super.key, required this.useSafeArea});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: useSafeArea ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: useSafeArea ? Colors.green.shade200 : Colors.red.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  useSafeArea ? Icons.check_circle : Icons.warning,
                  color: useSafeArea ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'List Item ${index + 1}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        useSafeArea
                          ? 'This content is properly positioned within safe areas'
                          : 'This content might be hidden by system UI elements',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: 15,
      ),
    );
  }
}