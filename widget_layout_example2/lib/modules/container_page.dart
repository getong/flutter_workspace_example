import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ContainerRoute')
class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            _ModuleIntro(
              title: 'Container combines layout, spacing, and decoration.',
              description:
                  'These examples use `padding`, `margin`, `constraints`, '
                  '`alignment`, `decoration`, `transform`, and '
                  '`foregroundDecoration` so the page shows more than a basic '
                  'colored box.',
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Decoration + alignment',
              description:
                  'Use Container when you want one widget to own background '
                  'painting, internal spacing, and child positioning.',
              codeLabel:
                  'Container(padding: ..., alignment: ..., decoration: ...)',
              child: _DecoratedProfileExample(),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Margin + constraints',
              description:
                  'A Container can push itself away from siblings while also '
                  'enforcing a minimum height for its child.',
              codeLabel:
                  'Container(margin: ..., constraints: const BoxConstraints(minHeight: 120))',
              child: _ConstraintExample(),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Transform for emphasis',
              description:
                  'Subtle transforms help promo cards or highlighted content '
                  'feel more dynamic without creating a full custom painter.',
              codeLabel: 'Container(transform: Matrix4.rotationZ(-0.04), ...)',
              child: _TransformExample(),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Foreground decoration overlay',
              description:
                  'Use foregroundDecoration when a label, tint, or status '
                  'treatment should sit above the child content.',
              codeLabel:
                  'Container(foregroundDecoration: ..., clipBehavior: Clip.antiAlias)',
              child: _ForegroundDecorationExample(),
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

class _ModuleIntro extends StatelessWidget {
  const _ModuleIntro({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(description, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.codeLabel,
    required this.child,
  });

  final String title;
  final String description;
  final String codeLabel;
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
            const SizedBox(height: 12),
            Text(codeLabel, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _DecoratedProfileExample extends StatelessWidget {
  const _DecoratedProfileExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF0F4C81), Color(0xFF2E86AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x330F4C81),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flutter_dash,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Flutter UI Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Padding, decoration, alignment, and shadows in one widget.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConstraintExample extends StatelessWidget {
  const _ConstraintExample();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF5F7FB),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD7DFEA)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Task Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'Minimum height keeps this card balanced even with short copy.',
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _Pill(label: 'margin'),
                _Pill(label: 'constraints'),
                _Pill(label: 'padding'),
                _Pill(label: 'borderRadius'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransformExample extends StatelessWidget {
  const _TransformExample();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: -0.04,
        child: Container(
          width: 260,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB703),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFB87400), width: 1.5),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Limited Offer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF432818),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Container can still be a pragmatic choice for promo UI before '
                'you reach for a heavier custom widget.',
                style: TextStyle(color: Color(0xFF5A3D1E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForegroundDecorationExample extends StatelessWidget {
  const _ForegroundDecorationExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: <Color>[
            Colors.transparent,
            Colors.black.withValues(alpha: 0.18),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF9D4EDD), Color(0xFFC77DFF)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Status: Synced',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'The overlay sits above the child and keeps the contrast readable.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF315380),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
