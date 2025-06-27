import 'package:flutter/material.dart';
import '../widgets/basic_content_sliver.dart';

class BasicComparisonExample extends StatefulWidget {
  const BasicComparisonExample({super.key});

  @override
  State<BasicComparisonExample> createState() => _BasicComparisonExampleState();
}

class _BasicComparisonExampleState extends State<BasicComparisonExample> {
  bool useSafeArea = true;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Basic Comparison'),
          backgroundColor: useSafeArea ? Colors.green : Colors.red,
          pinned: true,
        ),
        
        SliverToBoxAdapter(
          child: Container(
            color: useSafeArea ? Colors.green.shade100 : Colors.red.shade100,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    useSafeArea ? 'WITH SliverSafeArea' : 'WITHOUT SliverSafeArea',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: useSafeArea ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        useSafeArea = !useSafeArea;
                      });
                    },
                    child: Text('Toggle ${useSafeArea ? 'OFF' : 'ON'}'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    useSafeArea 
                      ? 'Content respects safe areas (notches, home indicator)'
                      : 'Content may overlap with system UI elements',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),

        if (useSafeArea)
          SliverSafeArea(
            sliver: BasicContentSliver(useSafeArea: useSafeArea),
          )
        else
          BasicContentSliver(useSafeArea: useSafeArea),

        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Differences:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• SliverSafeArea: Automatically adds padding to avoid system UI'),
                const Text('• Without: Content may be hidden behind notches or home indicators'),
                const Text('• Toggle between modes to see the difference'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
