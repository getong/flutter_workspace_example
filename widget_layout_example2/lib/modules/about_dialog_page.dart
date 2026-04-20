import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AboutDialogPage extends StatefulWidget {
  const AboutDialogPage({super.key});

  @override
  State<AboutDialogPage> createState() => _AboutDialogPageState();
}

class _AboutDialogPageState extends State<AboutDialogPage> {
  int _openCount = 0;
  String _lastPresentation = 'No about dialog opened yet.';

  Future<void> _openAboutDialogWithShowDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const AboutDialog(
          applicationName: 'Widget Layout Example',
          applicationVersion: '1.0.0+1',
          applicationIcon: FlutterLogo(size: 52),
          children: <Widget>[
            SizedBox(height: 12),
            Text(
              'AboutDialog is a ready-made Material dialog implementation for application metadata, version details, and license access.',
            ),
            SizedBox(height: 8),
            Text(
              'This example presents AboutDialog through showDialog so the modal flow stays explicit and consistent with the other dialog demos.',
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _openCount += 1;
      _lastPresentation = 'Opened AboutDialog with showDialog().';
    });
  }

  Future<void> _openAboutDialogWithHelper() async {
    showAboutDialog(
      context: context,
      applicationName: 'Widget Layout Example',
      applicationVersion: '1.0.0+1',
      applicationIcon: const FlutterLogo(size: 52),
      children: const <Widget>[
        SizedBox(height: 12),
        Text(
          'showAboutDialog is the convenience API for the same widget when you do not need custom route configuration.',
        ),
      ],
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _openCount += 1;
      _lastPresentation = 'Opened AboutDialog with showAboutDialog().';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AboutDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'AboutDialog is a built-in dialog widget for app identity, version information, package credits, and license discovery.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'AboutDialog via showDialog()',
              description:
                  'Use showDialog when you want AboutDialog but still need direct control over the route presentation API.',
              child: FilledButton.icon(
                onPressed: _openAboutDialogWithShowDialog,
                icon: const Icon(Icons.info_outline),
                label: const Text('Open AboutDialog'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'showAboutDialog Helper',
              description:
                  'Flutter also provides a convenience helper that wraps the same Material about dialog presentation for common app-info flows.',
              child: OutlinedButton.icon(
                onPressed: _openAboutDialogWithHelper,
                icon: const Icon(Icons.help_outline),
                label: const Text('Open with helper'),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'AboutListTile Integration',
              description:
                  'AboutListTile is useful inside settings or drawers when you want a built-in entry point to the application about sheet.',
              child: Card(
                margin: EdgeInsets.zero,
                child: AboutListTile(
                  icon: const Icon(Icons.info),
                  applicationName: 'Widget Layout Example',
                  applicationVersion: '1.0.0+1',
                  applicationIcon: const FlutterLogo(size: 28),
                  aboutBoxChildren: const <Widget>[
                    SizedBox(height: 12),
                    Text(
                      'This tile opens the same about content without writing a custom tap handler.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Usage',
              description:
                  'Track how the about dialog was presented and how many times it has been opened during the session.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_lastPresentation),
                  const SizedBox(height: 8),
                  Text('Dialog opens in this session: $_openCount'),
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
