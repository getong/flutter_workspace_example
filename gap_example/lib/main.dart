import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gap Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gap Widget Examples'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GapExamplePage()),
              ),
              child: const Text('Gap Example'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SliverGapExamplePage(),
                ),
              ),
              child: const Text('SliverGap Example'),
            ),
          ],
        ),
      ),
    );
  }
}

class GapExamplePage extends StatelessWidget {
  const GapExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gap Widget Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(color: Colors.red, height: 20),
            const Gap(20), // Adds an empty space of 20 pixels.
            Container(color: Colors.red, height: 20),
          ],
        ),
      ),
    );
  }
}

class SliverGapExamplePage extends StatelessWidget {
  const SliverGapExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SliverGap Example'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverGap(20), // Adds an empty space of 20 pixels.
          SliverToBoxAdapter(
            child: Container(
              color: Colors.blue,
              height: 100,
              child: const Center(child: Text('First Item')),
            ),
          ),
          const SliverGap(20),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.green,
              height: 100,
              child: const Center(child: Text('Second Item')),
            ),
          ),
          const SliverGap(20),
        ],
      ),
    );
  }
}
