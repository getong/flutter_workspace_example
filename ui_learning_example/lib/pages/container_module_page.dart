import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';

class ContainerModulePage extends StatelessWidget {
  const ContainerModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Module'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.home.path);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Container Examples (From Your Snippets)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('1) Container(color: Colors.lightBlue)'),
            const SizedBox(height: 10),
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.lightBlue,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('2) Container + ButtonBar'),
            const SizedBox(height: 10),
            Container(color: Colors.lightBlue, child: const OverflowBar()),
            const SizedBox(height: 24),
            _buildSectionTitle('3) width/height + ButtonBar'),
            const SizedBox(height: 10),
            Container(
              width: 300,
              height: 300,
              color: Colors.lightBlue,
              child: const OverflowBar(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('4) margin + padding + width/height + child'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(100),
              padding: const EdgeInsets.all(50),
              width: 300,
              height: 300,
              color: Colors.lightBlue,
              child: const Text('Container'),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('5) margin + padding + child'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(100),
              padding: const EdgeInsets.all(50),
              color: Colors.lightBlue,
              child: const Text('Container'),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('6) decoration: BoxDecoration(...)'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.all(100),
              padding: const EdgeInsets.all(50),
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.rectangle,
              ),
              child: const Text('Container'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
