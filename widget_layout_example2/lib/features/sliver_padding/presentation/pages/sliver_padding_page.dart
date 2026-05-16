import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.sliverPadding)
class SliverPaddingPage extends StatefulWidget {
  const SliverPaddingPage({super.key});

  @override
  State<SliverPaddingPage> createState() => _SliverPaddingPageState();
}

class _SliverPaddingPageState extends State<SliverPaddingPage> {
  double _horizontalPadding = 24;
  double _topPadding = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SliverPadding Module')),
      body: SelectionArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'What SliverPadding Does',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SliverPadding adds padding around another sliver. It is cleaner than padding every child manually when the spacing belongs to the whole sliver section.',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Horizontal padding: ${_horizontalPadding.toStringAsFixed(0)}',
                        ),
                        Slider(
                          value: _horizontalPadding,
                          min: 0,
                          max: 40,
                          divisions: 8,
                          label: _horizontalPadding.toStringAsFixed(0),
                          onChanged: (double value) {
                            setState(() {
                              _horizontalPadding = value;
                            });
                          },
                        ),
                        Text('Top padding: ${_topPadding.toStringAsFixed(0)}'),
                        Slider(
                          value: _topPadding,
                          min: 0,
                          max: 32,
                          divisions: 8,
                          label: _topPadding.toStringAsFixed(0),
                          onChanged: (double value) {
                            setState(() {
                              _topPadding = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Padding Around a SliverList',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                _horizontalPadding,
                _topPadding,
                _horizontalPadding,
                0,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final Color color = <Color>[
                    Colors.blue,
                    Colors.teal,
                    Colors.orange,
                    Colors.deepPurple,
                  ][index % 4];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == 3 ? 0 : 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'List row ${index + 1} inherits the same section padding.',
                      ),
                    ),
                  );
                }, childCount: 4),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Padding Around a SliverGrid',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                _horizontalPadding,
                _topPadding,
                _horizontalPadding,
                24,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final Color color = <Color>[
                    Colors.indigo,
                    Colors.cyan,
                    Colors.pink,
                    Colors.lightGreen,
                  ][index % 4];
                  return Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Card ${index + 1}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }, childCount: 6),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
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
