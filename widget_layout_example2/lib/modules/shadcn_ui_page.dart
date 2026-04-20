import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@RoutePage()
class ShadcnUiPage extends StatefulWidget {
  const ShadcnUiPage({super.key});

  @override
  State<ShadcnUiPage> createState() => _ShadcnUiPageState();
}

class _ShadcnUiPageState extends State<ShadcnUiPage> {
  static const Map<String, String> _frameworks = <String, String>{
    'flutter': 'Flutter',
    'nextjs': 'Next.js',
    'astro': 'Astro',
    'remix': 'Remix',
  };

  final TextEditingController _projectController = TextEditingController(
    text: 'widget_layout_example2',
  );

  bool _darkPreview = false;
  bool _notificationsEnabled = true;
  String _selectedTab = 'overview';
  String _selectedFramework = 'flutter';

  ShadThemeData get _theme {
    return ShadThemeData(
      brightness: _darkPreview ? Brightness.dark : Brightness.light,
      colorScheme: _darkPreview
          ? const ShadZincColorScheme.dark()
          : const ShadZincColorScheme.light(),
      textTheme: ShadTextTheme(),
    );
  }

  @override
  void dispose() {
    _projectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData pageTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('shadcn_ui Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'shadcn_ui brings a themed component system to Flutter with cards, buttons, badges, selects, switches, tabs, and input controls designed to work together.',
            style: pageTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This page demonstrates `ShadTheme`, `ShadCard`, `ShadBadge`, `ShadButton`, `ShadInput`, `ShadSelect`, `ShadSwitch`, and `ShadTabs` inside a local preview surface.',
            style: pageTheme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ShadTheme(
            data: _theme,
            child: Builder(
              builder: (BuildContext context) {
                final ShadThemeData shadTheme = ShadTheme.of(context);

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: shadTheme.colorScheme.background,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: shadTheme.colorScheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Local Shad Preview', style: shadTheme.textTheme.h3),
                      const SizedBox(height: 8),
                      Text(
                        'The preview below is wrapped with `ShadTheme(data: ...)`, so the package can be exercised without changing the rest of the app.',
                        style: shadTheme.textTheme.muted,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          ShadBadge(
                            child: Text(
                              _darkPreview ? 'Dark Preview' : 'Light Preview',
                            ),
                          ),
                          const ShadBadge.secondary(
                            child: Text('Design System'),
                          ),
                          const ShadBadge.outline(child: Text('Interactive')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ShadCard(
                        width: double.infinity,
                        title: const Text('Component controls'),
                        description: const Text(
                          'Mix package buttons, inputs, selects, and switches inside a single card.',
                        ),
                        footer: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            ShadButton(
                              leading: const Icon(LucideIcons.rocket),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'shadcn_ui primary action tapped.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Ship Preview'),
                            ),
                            ShadButton.secondary(
                              leading: const Icon(LucideIcons.sparkles),
                              onPressed: () {
                                setState(() => _darkPreview = !_darkPreview);
                              },
                              child: const Text('Toggle Theme'),
                            ),
                            const ShadButton.outline(
                              leading: Icon(LucideIcons.mail),
                              child: Text('Invite Reviewer'),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text('Project name'),
                              const SizedBox(height: 8),
                              ShadInput(
                                controller: _projectController,
                                leading: const Padding(
                                  padding: EdgeInsetsDirectional.only(end: 8),
                                  child: Icon(LucideIcons.layoutGrid),
                                ),
                                placeholder: const Text('Project name'),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 16),
                              const Text('Framework'),
                              const SizedBox(height: 8),
                              ShadSelect<String>(
                                initialValue: _selectedFramework,
                                placeholder: const Text('Select a framework'),
                                options: _frameworks.entries
                                    .map(
                                      (MapEntry<String, String> entry) =>
                                          ShadOption<String>(
                                            value: entry.key,
                                            child: Text(entry.value),
                                          ),
                                    )
                                    .toList(growable: false),
                                selectedOptionBuilder:
                                    (BuildContext context, String value) {
                                      return Text(_frameworks[value] ?? value);
                                    },
                                onChanged: (String? value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() => _selectedFramework = value);
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ShadSwitch(
                                      value: _notificationsEnabled,
                                      onChanged: (bool value) {
                                        setState(
                                          () => _notificationsEnabled = value,
                                        );
                                      },
                                      label: const Text('Enable notifications'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ShadSwitch(
                                      value: _darkPreview,
                                      onChanged: (bool value) {
                                        setState(() => _darkPreview = value);
                                      },
                                      label: const Text('Dark preview'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ShadTabs<String>(
                        value: _selectedTab,
                        tabBarConstraints: const BoxConstraints(maxWidth: 520),
                        contentConstraints: const BoxConstraints(maxWidth: 520),
                        onChanged: (String value) {
                          setState(() => _selectedTab = value);
                        },
                        tabs: <ShadTab<String>>[
                          ShadTab<String>(
                            value: 'overview',
                            content: ShadCard(
                              title: const Text('Overview'),
                              description: const Text(
                                'Use package typography, cards, and badges together.',
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Project: ${_projectController.text}',
                                      style: shadTheme.textTheme.large,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Framework: ${_frameworks[_selectedFramework]}',
                                      style: shadTheme.textTheme.muted,
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: <Widget>[
                                        ShadBadge(
                                          child: Text(
                                            _notificationsEnabled
                                                ? 'Notifications on'
                                                : 'Notifications off',
                                          ),
                                        ),
                                        const ShadBadge.secondary(
                                          child: Text('ShadCard'),
                                        ),
                                        const ShadBadge.outline(
                                          child: Text('ShadTabs'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: const Text('Overview'),
                          ),
                          ShadTab<String>(
                            value: 'actions',
                            content: ShadCard(
                              title: const Text('Actions'),
                              description: const Text(
                                'Demonstrate button variants inside a secondary tab.',
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: const <Widget>[
                                    ShadButton(child: Text('Primary')),
                                    ShadButton.secondary(
                                      child: Text('Secondary'),
                                    ),
                                    ShadButton.outline(child: Text('Outline')),
                                    ShadButton.ghost(child: Text('Ghost')),
                                  ],
                                ),
                              ),
                            ),
                            child: const Text('Actions'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
