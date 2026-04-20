import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.customClipper)
class CustomClipperExamplePage extends StatelessWidget {
  const CustomClipperExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomClipper Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            Text(
              'CustomClipper lets you define the clipping shape logic yourself.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Ticket Shape',
              description:
                  'A custom clipper is useful when standard ovals or rounded rectangles are not enough.',
              child: ClipPath(
                clipper: _TicketClipper(),
                child: _TicketPanel(label: 'Ticket clipper'),
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'CustomClipper Reuse',
              description:
                  'The same idea can drive badges, tooltips, hero banners, or custom dialogs with distinctive silhouettes.',
              child: ClipPath(
                clipper: _RibbonClipper(),
                child: _TicketPanel(label: 'Ribbon clipper'),
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

class _TicketPanel extends StatelessWidget {
  const _TicketPanel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.deepOrange, Colors.pink],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  const _TicketClipper();

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.35);
    path.arcToPoint(
      Offset(0, size.height * 0.65),
      radius: const Radius.circular(18),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.65);
    path.arcToPoint(
      Offset(size.width, size.height * 0.35),
      radius: const Radius.circular(18),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _RibbonClipper extends CustomClipper<Path> {
  const _RibbonClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - 36, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width - 36, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
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
