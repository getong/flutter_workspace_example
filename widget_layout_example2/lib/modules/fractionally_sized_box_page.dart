import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'FractionallySizedBoxRoute')
class FractionallySizedBoxPage extends StatelessWidget {
  const FractionallySizedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FractionallySizedBox Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'FractionallySizedBox sizes its child as a fraction of the available parent space. It is useful for responsive bars, floating panels, badges, and any layout defined relative to its container.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _FractionExampleCard(
              title: 'Relative Progress Bar',
              description:
                  'The bar width is tied to the parent width instead of using a hard-coded pixel value.',
              api: 'Uses: widthFactor',
              child: SizedBox(
                height: 68,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.58,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: Text(
                          '58%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _FractionExampleCard(
              title: 'Centered Promo Card',
              description:
                  'A nested panel can remain proportional to its parent without calculating widths manually.',
              api: 'Uses: widthFactor + heightFactor + alignment',
              child: SizedBox(
                height: 180,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.78,
                    heightFactor: 0.72,
                    alignment: Alignment.center,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(blurRadius: 12, color: Colors.black12),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.local_offer_outlined,
                              color: Color(0xFF059669),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Weekend discount unlocked',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FractionExampleCard(
              title: 'Top-Right Badge Placement',
              description:
                  'Fractional sizing plus alignment is convenient for corner badges and overlay callouts.',
              api: 'Uses: alignment: Alignment.topRight',
              child: SizedBox(
                height: 150,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.34,
                    heightFactor: 0.28,
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4444),
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                        child: Center(
                          child: Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
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
            _FractionExampleCard(
              title: 'Bottom Sheet Preview',
              description:
                  'A sheet-style panel can size itself relative to its host area and stay aligned to the bottom center.',
              api: 'Uses: widthFactor + heightFactor + bottomCenter alignment',
              child: SizedBox(
                height: 220,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.92,
                    heightFactor: 0.56,
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 52,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Color(0xFFCBD5E1),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Upgrade seat',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 8),
                            Text('Choose premium legroom or lounge access.'),
                          ],
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

class _FractionExampleCard extends StatelessWidget {
  const _FractionExampleCard({
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
