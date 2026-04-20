import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SliverAppBarPage extends StatefulWidget {
  const SliverAppBarPage({super.key});

  @override
  State<SliverAppBarPage> createState() => _SliverAppBarPageState();
}

class _SliverAppBarPageState extends State<SliverAppBarPage> {
  bool _pinned = true;
  bool _floating = false;
  bool _snap = false;
  bool _stretch = false;

  Future<void> _handleStretch() async {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Stretch trigger fired.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 220,
              pinned: _pinned,
              floating: _floating,
              snap: _floating && _snap,
              stretch: _stretch,
              onStretchTrigger: _stretch ? _handleStretch : null,
              title: const Text('SliverAppBar Module'),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Release Dashboard'),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Colors.indigo, Colors.teal],
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 48,
                        right: 24,
                        child: Icon(
                          Icons.auto_graph,
                          size: 120,
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      const Positioned(
                        left: 24,
                        bottom: 48,
                        child: Text(
                          'Scroll to see pinned, floating, snap,\nand stretch behavior.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                          'Behavior Controls',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SliverAppBar integrates directly with CustomScrollView so the app bar can collapse, pin, float back into view, or stretch while other slivers scroll.',
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Pinned'),
                          subtitle: const Text(
                            'Keep the toolbar visible after the header collapses.',
                          ),
                          value: _pinned,
                          onChanged: (bool value) {
                            setState(() {
                              _pinned = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Floating'),
                          subtitle: const Text(
                            'Allow the app bar to reappear as soon as the user scrolls upward.',
                          ),
                          value: _floating,
                          onChanged: (bool value) {
                            setState(() {
                              _floating = value;
                              if (!value) {
                                _snap = false;
                              }
                            });
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Snap'),
                          subtitle: const Text(
                            'Only applies when floating is enabled.',
                          ),
                          value: _snap,
                          onChanged: _floating
                              ? (bool value) {
                                  setState(() {
                                    _snap = value;
                                  });
                                }
                              : null,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Stretch'),
                          subtitle: const Text(
                            'Enable overscroll stretching and the optional trigger callback.',
                          ),
                          value: _stretch,
                          onChanged: (bool value) {
                            setState(() {
                              _stretch = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                    Colors.indigo,
                    Colors.red,
                  ][index % 6];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: color.withValues(alpha: 0.18),
                            child: Icon(Icons.widgets, color: color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Scroll item ${index + 1}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Use the switches above, then scroll this content to feel how SliverAppBar changes behavior.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: 10),
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
