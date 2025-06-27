import 'package:flutter/material.dart';
import 'widgets/example_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SliverSafeArea Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExampleNavigator(),
    );
  }
}
// Main Navigation Widget
class ExampleNavigator extends StatefulWidget {
  const ExampleNavigator({super.key});

  @override
  State<ExampleNavigator> createState() => _ExampleNavigatorState();
}

class _ExampleNavigatorState extends State<ExampleNavigator> {
  int currentIndex = 0;

  final List<Widget> examples = [
    const BasicComparisonExample(),
    const AdvancedSafeAreaExample(),
    const CustomSafeAreaExample(),
  ];

  final List<String> titles = [
    'Basic Comparison',
    'Advanced Features',
    'Custom Configuration',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: examples[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.compare),
            label: 'Basic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_play_list),
            label: 'Advanced',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Custom',
          ),
        ],
      ),
    );
  }
}

// Part 1: Basic Comparison Example
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
        
        // Header with toggle
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

        // Conditional sliver based on toggle
        if (useSafeArea)
          SliverSafeArea(
            sliver: BasicContentSliver(useSafeArea: useSafeArea),
          )
        else
          BasicContentSliver(useSafeArea: useSafeArea),

        // Bottom comparison section
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

// Part 2: Advanced SliverSafeArea Example
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
          top: false, // Don't add top padding (AppBar handles it)
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

// Part 3: Custom SliverSafeArea Configuration
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

// Helper Widget for Basic Content
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
