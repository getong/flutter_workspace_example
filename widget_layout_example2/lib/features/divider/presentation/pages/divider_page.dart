import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.divider)
class DividerPage extends StatelessWidget {
  const DividerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divider Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text('Divider', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'A thin horizontal line used to separate content. '
              'VerticalDivider is the vertical counterpart.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),

            // ── Basic Divider ──────────────────────────────────────────────
            _SectionHeader(title: '1. Default Divider'),
            const Text('Divider() with all default values.'),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: <Widget>[
                  const Text('Item A'),
                  const Divider(),
                  const Text('Item B'),
                ],
              ),
            ),
            _CodeBlock(code: 'Divider()'),
            const SizedBox(height: 24),

            // ── Colored Divider ───────────────────────────────────────────
            _SectionHeader(title: '2. Colored & Thick Divider'),
            const Text(
              'Set color and thickness to make the divider more prominent.',
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: <Widget>[
                  const Text('Section Header'),
                  const Divider(thickness: 3, color: Colors.deepPurple),
                  const Text('Section Content'),
                ],
              ),
            ),
            _CodeBlock(
              code:
                  'Divider(\n'
                  '  thickness: 3,\n'
                  '  color: Colors.deepPurple,\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Indented Divider ──────────────────────────────────────────
            _SectionHeader(title: '3. Indented Divider'),
            const Text(
              'Use indent and endIndent to offset the line from the edges.',
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.star),
                    title: Text('First Item'),
                  ),
                  const Divider(indent: 72, endIndent: 16),
                  const ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Second Item'),
                  ),
                  const Divider(indent: 72, endIndent: 16),
                  const ListTile(
                    leading: Icon(Icons.bolt),
                    title: Text('Third Item'),
                  ),
                ],
              ),
            ),
            _CodeBlock(code: 'Divider(indent: 72, endIndent: 16)'),
            const SizedBox(height: 24),

            // ── Multiple Dividers in a Card ───────────────────────────────
            _SectionHeader(title: '4. Dividers Inside a Card'),
            const Text(
              'Dividers work well inside Card to separate list items.',
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: List<Widget>.generate(4, (int i) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Card Row ${i + 1}'),
                        subtitle: const Text('Subtitle text'),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                      if (i < 3)
                        const Divider(height: 1, thickness: 1, indent: 16),
                    ],
                  );
                }),
              ),
            ),
            _CodeBlock(code: 'Divider(height: 1, thickness: 1, indent: 16)'),
            const SizedBox(height: 24),

            // ── VerticalDivider ───────────────────────────────────────────
            _SectionHeader(title: '5. VerticalDivider'),
            const Text(
              'VerticalDivider separates widgets arranged in a Row. '
              'Requires a parent with bounded height.',
            ),
            const SizedBox(height: 8),
            Container(
              height: 80,
              color: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text('Left'),
                  const VerticalDivider(thickness: 2, color: Colors.teal),
                  const Text('Center'),
                  const VerticalDivider(
                    thickness: 2,
                    color: Colors.orange,
                    indent: 8,
                    endIndent: 8,
                  ),
                  const Text('Right'),
                ],
              ),
            ),
            _CodeBlock(
              code:
                  'SizedBox(\n'
                  '  height: 80,\n'
                  '  child: Row(\n'
                  '    children: [\n'
                  '      Text("Left"),\n'
                  '      VerticalDivider(\n'
                  '        thickness: 2, color: Colors.teal,\n'
                  '      ),\n'
                  '      Text("Right"),\n'
                  '    ],\n'
                  '  ),\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Theme-level Divider ───────────────────────────────────────
            _SectionHeader(title: '6. DividerTheme Override'),
            const Text(
              'Wrap with DividerTheme to override divider style locally '
              'without changing the global theme.',
            ),
            const SizedBox(height: 8),
            DividerTheme(
              data: const DividerThemeData(
                color: Colors.redAccent,
                thickness: 2,
                space: 32,
              ),
              child: Column(
                children: <Widget>[
                  const Text('Row 1 — custom DividerTheme'),
                  const Divider(),
                  const Text('Row 2 — custom DividerTheme'),
                  const Divider(),
                  const Text('Row 3 — custom DividerTheme'),
                ],
              ),
            ),
            _CodeBlock(
              code:
                  'DividerTheme(\n'
                  '  data: DividerThemeData(\n'
                  '    color: Colors.redAccent,\n'
                  '    thickness: 2,\n'
                  '    space: 32,\n'
                  '  ),\n'
                  '  child: Column(children: [Divider(), ...]),\n'
                  ')',
            ),
            const SizedBox(height: 24),

            // ── Divider as Separator in CustomScrollView ──────────────────
            _SectionHeader(title: '7. Divider in SliverList'),
            const Text(
              'Using ListView.separated with a Divider as the separator '
              'is the most common real-world pattern.',
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.separated(
                itemCount: 6,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(height: 1);
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('List item ${index + 1}'),
                    leading: CircleAvatar(child: Text('${index + 1}')),
                  );
                },
              ),
            ),
            _CodeBlock(
              code:
                  'ListView.separated(\n'
                  '  separatorBuilder: (ctx, i) => Divider(height: 1),\n'
                  '  itemBuilder: (ctx, i) => ListTile(...),\n'
                  ')',
            ),
            const SizedBox(height: 80),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
