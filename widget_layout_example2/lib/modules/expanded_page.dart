import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ExpandedPage extends StatelessWidget {
  const ExpandedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expanded Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[
            _ExpandedIntro(),
            SizedBox(height: 20),
            _ExpandedExampleCard(
              title: 'Fill the remaining width',
              description:
                  'A common row pattern is a fixed navigation rail, a flexible '
                  'primary panel, and a fixed detail panel.',
              codeLabel:
                  'Row(children: [SizedBox(width: 88), Expanded(child: ...), SizedBox(width: 76)])',
              child: _DashboardRowExample(),
            ),
            SizedBox(height: 16),
            _ExpandedExampleCard(
              title: 'Use flex ratios',
              description:
                  'When multiple children expand, `flex` controls how the '
                  'available space is divided.',
              codeLabel:
                  'Expanded(flex: 2, child: ...) and Expanded(flex: 1, child: ...)',
              child: _FlexRatioExample(),
            ),
            SizedBox(height: 16),
            _ExpandedExampleCard(
              title: 'Expanded inside forms and toolbars',
              description:
                  'Search bars and long text fields usually take the remaining '
                  'width while icon buttons keep fixed dimensions.',
              codeLabel:
                  'Row(children: [IconButton(...), Expanded(child: TextField(...)), IconButton(...)])',
              child: _ToolbarExample(),
            ),
            SizedBox(height: 16),
            _ExpandedExampleCard(
              title: 'Expanded vs Flexible',
              description:
                  'Expanded forces a child to consume leftover space. '
                  'Flexible lets it stay smaller when its intrinsic size is enough.',
              codeLabel: 'Expanded(flex: 2, child: ...), Flexible(child: ...)',
              child: _ExpandedVsFlexibleExample(),
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

class _ExpandedIntro extends StatelessWidget {
  const _ExpandedIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Expanded tells a Row, Column, or Flex to give its child the leftover space.',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          'This page covers single-child expansion, shared flex ratios, toolbar '
          'layout, and how `Expanded` differs from `Flexible` in real UI.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _ExpandedExampleCard extends StatelessWidget {
  const _ExpandedExampleCard({
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

class _DashboardRowExample extends StatelessWidget {
  const _DashboardRowExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 88,
            decoration: const BoxDecoration(
              color: Color(0xFF1D3557),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(18)),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.space_dashboard, color: Colors.white),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Primary Panel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(value: 0.72),
                  SizedBox(height: 12),
                  Text(
                    'Expanded keeps the main content wide while the side areas stay fixed.',
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFDCE7F6),
              borderRadius: BorderRadius.horizontal(right: Radius.circular(18)),
            ),
            alignment: Alignment.center,
            child: const RotatedBox(
              quarterTurns: 3,
              child: Text(
                'TOOLS',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlexRatioExample extends StatelessWidget {
  const _FlexRatioExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF457B9D),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text(
                'flex: 2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8DADC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'flex: 1',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC8DD),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'flex: 1',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarExample extends StatelessWidget {
  const _ToolbarExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search widgets, routes, and demos',
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filled(onPressed: () {}, icon: const Icon(Icons.tune)),
        ],
      ),
    );
  }
}

class _ExpandedVsFlexibleExample extends StatelessWidget {
  const _ExpandedVsFlexibleExample();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2A9D8F),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Expanded',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE9C46A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Flexible can stay close to its natural width when the content is short.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
