import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'SafeAreaRoute')
class SafeAreaPage extends StatelessWidget {
  const SafeAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SafeArea Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            Text(
              'SafeArea insets its child to avoid system UI such as notches, status bars, rounded corners, and home indicators.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              'This page uses simulated MediaQuery padding so the behavior is visible even on desktop where the real safe-area insets are often zero.',
            ),
            SizedBox(height: 20),
            _ExampleCard(
              title: 'Without SafeArea vs With SafeArea',
              description:
                  'The left screen lets content run under the simulated system areas. The right screen applies SafeArea so the same content is inset away from those edges.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _SimulatedDevice(
                    label: 'Without SafeArea',
                    child: _DemoSurface(useSafeArea: false),
                  ),
                  _SimulatedDevice(
                    label: 'With SafeArea',
                    child: _DemoSurface(useSafeArea: true),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Selective Edges',
              description:
                  'SafeArea can protect only the edges you want. This is useful when a hero image should bleed behind the status bar while a bottom action row still avoids the home indicator.',
              child: _SimulatedDevice(
                label: 'top: false, left/right/bottom: true',
                child: _SelectiveEdgesDemo(),
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'Minimum Padding',
              description:
                  'minimum guarantees extra spacing even when the inherited safe-area insets are small or zero.',
              child: _SimulatedDevice(
                label: 'SafeArea(minimum: EdgeInsets.all(16))',
                simulatedPadding: EdgeInsets.only(top: 8, left: 6, right: 6),
                simulatedViewPadding: EdgeInsets.only(
                  top: 8,
                  left: 6,
                  right: 6,
                ),
                child: _MinimumPaddingDemo(),
              ),
            ),
            SizedBox(height: 16),
            _ExampleCard(
              title: 'maintainBottomViewPadding',
              description:
                  'When the keyboard changes MediaQuery.padding but the device still has a bottom safe area, maintainBottomViewPadding keeps that original bottom inset.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _SimulatedDevice(
                    label: 'maintainBottomViewPadding: false',
                    simulatedPadding: EdgeInsets.only(top: 30),
                    simulatedViewPadding: EdgeInsets.only(top: 30, bottom: 20),
                    child: _BottomComposerDemo(
                      maintainBottomViewPadding: false,
                    ),
                  ),
                  _SimulatedDevice(
                    label: 'maintainBottomViewPadding: true',
                    simulatedPadding: EdgeInsets.only(top: 30),
                    simulatedViewPadding: EdgeInsets.only(top: 30, bottom: 20),
                    child: _BottomComposerDemo(maintainBottomViewPadding: true),
                  ),
                ],
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

class _SimulatedDevice extends StatelessWidget {
  const _SimulatedDevice({
    required this.label,
    required this.child,
    this.simulatedPadding = const EdgeInsets.only(
      top: 34,
      left: 12,
      right: 12,
      bottom: 20,
    ),
    this.simulatedViewPadding = const EdgeInsets.only(
      top: 34,
      left: 12,
      right: 12,
      bottom: 20,
    ),
  });

  final String label;
  final Widget child;
  final EdgeInsets simulatedPadding;
  final EdgeInsets simulatedViewPadding;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData baseMediaQuery = MediaQuery.of(context);
    final EdgeInsets mediaPadding = simulatedPadding;
    final EdgeInsets mediaViewPadding = simulatedViewPadding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          width: 220,
          height: 340,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: <Widget>[
                MediaQuery(
                  data: baseMediaQuery.copyWith(
                    padding: mediaPadding,
                    viewPadding: mediaViewPadding,
                  ),
                  child: child,
                ),
                Positioned(
                  top: 6,
                  left: 54,
                  right: 54,
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'padding: $mediaPadding',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          'viewPadding: $mediaViewPadding',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DemoSurface extends StatelessWidget {
  const _DemoSurface({required this.useSafeArea});

  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 76,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.indigo,
            alignment: Alignment.centerLeft,
            child: const Text(
              'Top app bar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _StatTile(
                  icon: Icons.account_tree,
                  title: 'Deployment Status',
                  subtitle: 'SafeArea keeps this card clear of notches.',
                ),
                const SizedBox(height: 12),
                _StatTile(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  subtitle:
                      'Inset content avoids curved corners and system UI.',
                ),
              ],
            ),
          ),
          Container(
            height: 56,
            color: Colors.black.withValues(alpha: 0.28),
            alignment: Alignment.center,
            child: const Text(
              'Bottom actions',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    return useSafeArea ? SafeArea(child: content) : content;
  }
}

class _SelectiveEdgesDemo extends StatelessWidget {
  const _SelectiveEdgesDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Colors.deepPurple, Colors.pink],
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Hero image can extend behind the top inset',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Content starts immediately below the image while still respecting left, right, and bottom insets.',
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Action'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MinimumPaddingDemo extends StatelessWidget {
  const _MinimumPaddingDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange.withValues(alpha: 0.12),
      child: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Banner still gets 16px minimum spacing',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This is useful for consistent interior spacing while still honoring device insets.',
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomComposerDemo extends StatelessWidget {
  const _BottomComposerDemo({required this.maintainBottomViewPadding});

  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade50,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const <Widget>[
                Text('Simulated keyboard state: padding.bottom = 0'),
                SizedBox(height: 8),
                Text('viewPadding.bottom still represents the device inset.'),
              ],
            ),
          ),
          SafeArea(
            top: false,
            maintainBottomViewPadding: maintainBottomViewPadding,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message composer',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: () {}, child: const Text('Send')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.indigo.withValues(alpha: 0.12),
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
