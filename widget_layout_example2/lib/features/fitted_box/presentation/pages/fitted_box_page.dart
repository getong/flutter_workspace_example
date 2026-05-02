import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.fittedBox)
class FittedBoxPage extends StatelessWidget {
  const FittedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FittedBox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FittedBox scales and positions its child according to a BoxFit. It is useful when content has a natural size but still needs to fit cleanly inside a fixed box.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _FittedBoxExampleCard(
              title: 'Scale Down Large Text',
              description:
                  'A FittedBox can shrink oversized labels so they stay readable inside compact badges or headers.',
              api: 'Uses: FittedBox(fit: BoxFit.scaleDown)',
              child: SizedBox(
                height: 72,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'FLASH SALE ENDS IN 04:58',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _FittedBoxExampleCard(
              title: 'Contain An Oversized Icon',
              description:
                  'With BoxFit.contain, a child preserves its whole shape while scaling down to the available space.',
              api: 'Uses: FittedBox(fit: BoxFit.contain)',
              child: SizedBox(
                height: 140,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        size: 180,
                        color: Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _FittedBoxExampleCard(
              title: 'Cover A Media Card',
              description:
                  'BoxFit.cover is useful when the child should fill the whole frame, even if some parts are clipped.',
              api: 'Uses: FittedBox(fit: BoxFit.cover)',
              child: SizedBox(
                height: 170,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: ColoredBox(
                    color: Color(0xFF0F172A),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: 360,
                        height: 220,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0EA5E9),
                                Color(0xFF1D4ED8),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'COVER ART',
                              style: TextStyle(
                                fontSize: 44,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _FittedBoxExampleCard(
              title: 'Fit Width For Headlines',
              description:
                  'BoxFit.fitWidth works well when the width is the main constraint and the height can follow naturally.',
              api: 'Uses: FittedBox(fit: BoxFit.fitWidth)',
              child: SizedBox(
                height: 90,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFFEE2E2), Color(0xFFFECACA)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quarterly Revenue Snapshot',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF7F1D1D),
                          ),
                        ),
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

class _FittedBoxExampleCard extends StatelessWidget {
  const _FittedBoxExampleCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
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
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
