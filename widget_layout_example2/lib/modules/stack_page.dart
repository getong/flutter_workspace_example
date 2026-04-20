import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            _StackIntro(),
            SizedBox(height: 20),
            _StackExampleCard(
              title: 'Layered hero banner',
              description:
                  'Stack is the standard choice when backgrounds, badges, and '
                  'floating controls need to overlap.',
              codeLabel:
                  'Stack(children: [background, gradient, badge, button])',
              child: _HeroStackExample(),
            ),
            SizedBox(height: 16),
            _StackExampleCard(
              title: 'alignment for non-positioned children',
              description:
                  'When children are not wrapped in Positioned, Stack uses '
                  '`alignment` to place them relative to the same bounds.',
              codeLabel: 'Stack(alignment: Alignment.center, children: [...])',
              child: _AlignmentStackExample(),
            ),
            SizedBox(height: 16),
            _StackExampleCard(
              title: 'StackFit.expand',
              description:
                  'Use `fit: StackFit.expand` when every non-positioned child '
                  'should stretch to the Stack size.',
              codeLabel:
                  'Stack(fit: StackFit.expand, children: [DecoratedBox(...), Center(...)])',
              child: _ExpandFitExample(),
            ),
            SizedBox(height: 16),
            _StackExampleCard(
              title: 'clipBehavior for overlap',
              description:
                  'A floating avatar or status chip sometimes needs to escape '
                  'the card bounds, which is where `clipBehavior: Clip.none` helps.',
              codeLabel: 'Stack(clipBehavior: Clip.none, children: [...])',
              child: _ClipBehaviorExample(),
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

class _StackIntro extends StatelessWidget {
  const _StackIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Stack paints children on top of each other in order.',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          'It is useful for layered interfaces: hero sections, overlays, status '
          'badges, floating actions, and compact dashboard cards.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _StackExampleCard extends StatelessWidget {
  const _StackExampleCard({
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

class _HeroStackExample extends StatelessWidget {
  const _HeroStackExample();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF003049), Color(0xFF1D4E89)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Text(
              'Stack makes layered hero surfaces straightforward.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new),
              label: const Text('Inspect'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlignmentStackExample extends StatelessWidget {
  const _AlignmentStackExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF1FAEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFFA8DADC),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF457B9D),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF1D3557),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Top',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandFitExample extends StatelessWidget {
  const _ExpandFitExample();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFFFAFCC), Color(0xFFFFC8DD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.65),
                width: 2,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Every non-positioned child stretches',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClipBehaviorExample extends StatelessWidget {
  const _ClipBehaviorExample();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            top: 24,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 42, 18, 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDDE3EA)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Project Owner',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Clip.none lets the avatar float above the card edge.'),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: 0,
            child: Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF4361EE),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD8F3DC),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Online',
                style: TextStyle(
                  color: Color(0xFF2D6A4F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
