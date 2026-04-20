import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DecoratedBoxPage extends StatelessWidget {
  const DecoratedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DecoratedBox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'DecoratedBox paints a BoxDecoration around its child. It is useful for backgrounds, borders, rounded corners, gradients, and shadows.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _DecoratedBoxExampleCard(
              title: 'Border And Background',
              description:
                  'A simple DecoratedBox can add a background color, rounded corners, and a border.',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade300, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Decorated content',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DecoratedBoxExampleCard(
              title: 'Gradient Surface',
              description:
                  'DecoratedBox is also useful for gradients and elevation-like shadows.',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF5C6BC0), Color(0xFF26A69A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Text(
                    'Gradient card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DecoratedBoxExampleCard(
              title: 'Circle Decoration',
              description:
                  'Using BoxShape.circle gives a quick way to create badges or avatar-like visuals.',
              child: const Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFB300),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: Text(
                      '42',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _DecoratedBoxExampleCard extends StatelessWidget {
  const _DecoratedBoxExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
