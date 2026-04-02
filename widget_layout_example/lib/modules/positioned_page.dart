import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PositionedPage extends StatelessWidget {
  const PositionedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Positioned Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'Positioned controls where a child sits inside a Stack.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates several `Positioned` patterns: fixed '
              'top/left offsets, anchored corner badges, stretching with both '
              'left and right values, full overlays with `Positioned.fill`, '
              'and direction-aware placement with `Positioned.directional`.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            const _PositionedExampleCard(
              title: 'top + left',
              description:
                  'Use `top` and `left` to pin a widget near the upper-left corner.',
              codeLabel: 'Positioned(top: 16, left: 16)',
              child: _BasicStackExample(
                color: Colors.blue,
                child: Positioned(
                  top: 16,
                  left: 16,
                  child: _DemoBox(label: 'Top Left', color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _PositionedExampleCard(
              title: 'bottom + right',
              description:
                  'Badges, floating actions, and quick controls often use corner anchoring.',
              codeLabel: 'Positioned(bottom: 16, right: 16)',
              child: _BasicStackExample(
                color: Colors.green,
                child: Positioned(
                  bottom: 16,
                  right: 16,
                  child: _DemoBox(label: 'Action', color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _PositionedExampleCard(
              title: 'left + right stretch',
              description:
                  'When both sides are set, the child stretches horizontally within the Stack.',
              codeLabel: 'Positioned(top: 18, left: 20, right: 20)',
              child: _StretchBannerExample(),
            ),
            const SizedBox(height: 16),
            const _PositionedExampleCard(
              title: 'Positioned.fill',
              description:
                  'Useful for overlays, gradients, dimming layers, or tappable surfaces over content.',
              codeLabel: 'Positioned.fill(...)',
              child: _FillOverlayExample(),
            ),
            const SizedBox(height: 16),
            const _PositionedExampleCard(
              title: 'Positioned.directional',
              description:
                  'Choose `start` and `end` instead of `left` and `right` for text-direction-aware layouts.',
              codeLabel:
                  'Positioned.directional(top: 20, start: 20, textDirection: TextDirection.ltr)',
              child: _DirectionalExample(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _PositionedExampleCard extends StatelessWidget {
  const _PositionedExampleCard({
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

class _BasicStackExample extends StatelessWidget {
  const _BasicStackExample({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.35)),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _StretchBannerExample extends StatelessWidget {
  const _StretchBannerExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 18,
            left: 20,
            right: 20,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Stretching Banner',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 18,
            left: 20,
            child: _DemoBox(label: 'Info', color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }
}

class _FillOverlayExample extends StatelessWidget {
  const _FillOverlayExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.purple.withValues(alpha: 0.10),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.purple.withValues(alpha: 0.12),
                    Colors.deepPurple.withValues(alpha: 0.25),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            top: 20,
            left: 20,
            child: _DemoBox(label: 'Card', color: Colors.purple),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.black.withValues(alpha: 0.16),
              ),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Full overlay label',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionalExample extends StatelessWidget {
  const _DirectionalExample();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          color: Colors.teal.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.directional(
              textDirection: TextDirection.ltr,
              top: 20,
              start: 20,
              child: const _DemoBox(label: 'Start', color: Colors.teal),
            ),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 20,
              end: 20,
              child: const _DemoBox(label: 'End', color: Colors.lightBlue),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoBox extends StatelessWidget {
  const _DemoBox({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
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
