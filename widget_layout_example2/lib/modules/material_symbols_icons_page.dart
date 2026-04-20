import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.materialSymbolsIcons)
class MaterialSymbolsIconsPage extends StatefulWidget {
  const MaterialSymbolsIconsPage({super.key});

  @override
  State<MaterialSymbolsIconsPage> createState() =>
      _MaterialSymbolsIconsPageState();
}

class _MaterialSymbolsIconsPageState extends State<MaterialSymbolsIconsPage> {
  double _fill = 0;
  double _weight = 400;
  double _grade = 0;
  double _opticalSize = 24;
  bool _useIconThemeDefaults = false;

  static const List<
    ({String label, IconData outlined, IconData rounded, IconData sharp})
  >
  _symbolGroups =
      <({String label, IconData outlined, IconData rounded, IconData sharp})>[
        (
          label: 'Navigation',
          outlined: Symbols.explore,
          rounded: Symbols.explore_rounded,
          sharp: Symbols.explore_sharp,
        ),
        (
          label: 'Analytics',
          outlined: Symbols.monitoring,
          rounded: Symbols.monitoring_rounded,
          sharp: Symbols.monitoring_sharp,
        ),
        (
          label: 'Security',
          outlined: Symbols.verified_user,
          rounded: Symbols.verified_user_rounded,
          sharp: Symbols.verified_user_sharp,
        ),
        (
          label: 'Team',
          outlined: Symbols.groups,
          rounded: Symbols.groups_rounded,
          sharp: Symbols.groups_sharp,
        ),
      ];

  Widget _buildVariableIcon(IconData icon, {double size = 48, Color? color}) {
    return Icon(
      icon,
      size: size,
      color: color,
      fill: _fill,
      weight: _weight,
      grade: _grade,
      opticalSize: _opticalSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget demoContent = ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        const Text(
          'material_symbols_icons exposes Google Material Symbols through the Symbols class, including outlined, rounded, and sharp families plus variable font axes.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        _ExampleCard(
          title: 'Basic Symbol Usage',
          description:
              'Use Symbols.iconName, Symbols.iconName_rounded, and Symbols.iconName_sharp to pick different families of the same symbol.',
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: <Widget>[
              _SymbolTile(
                label: 'Outlined',
                icon: _buildVariableIcon(Symbols.home, color: Colors.blue),
                codeLabel: 'Symbols.home',
              ),
              _SymbolTile(
                label: 'Rounded',
                icon: _buildVariableIcon(
                  Symbols.home_rounded,
                  color: Colors.teal,
                ),
                codeLabel: 'Symbols.home_rounded',
              ),
              _SymbolTile(
                label: 'Sharp',
                icon: _buildVariableIcon(
                  Symbols.home_sharp,
                  color: Colors.deepOrange,
                ),
                codeLabel: 'Symbols.home_sharp',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ExampleCard(
          title: 'Variable Font Axes',
          description:
              'Material Symbols support fill, weight, grade, and opticalSize directly through Flutter Icon properties.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _buildVariableIcon(
                    Symbols.settings,
                    size: 96,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('fill: ${_fill.toStringAsFixed(2)}'),
              Slider(
                value: _fill,
                min: 0,
                max: 1,
                divisions: 4,
                label: _fill.toStringAsFixed(2),
                onChanged: (double value) {
                  setState(() {
                    _fill = value;
                  });
                },
              ),
              Text('weight: ${_weight.toStringAsFixed(0)}'),
              Slider(
                value: _weight,
                min: 100,
                max: 700,
                divisions: 6,
                label: _weight.toStringAsFixed(0),
                onChanged: (double value) {
                  setState(() {
                    _weight = value;
                  });
                },
              ),
              Text('grade: ${_grade.toStringAsFixed(0)}'),
              Slider(
                value: _grade,
                min: -25,
                max: 200,
                divisions: 9,
                label: _grade.toStringAsFixed(0),
                onChanged: (double value) {
                  setState(() {
                    _grade = value;
                  });
                },
              ),
              Text('opticalSize: ${_opticalSize.toStringAsFixed(0)}'),
              Slider(
                value: _opticalSize,
                min: 20,
                max: 48,
                divisions: 7,
                label: _opticalSize.toStringAsFixed(0),
                onChanged: (double value) {
                  setState(() {
                    _opticalSize = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ExampleCard(
          title: 'Toolbar and Button Usage',
          description:
              'Material Symbols work anywhere Icon and IconButton work: app tools, chip avatars, buttons, and list actions.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () {},
                    icon: _buildVariableIcon(
                      Symbols.add_task,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: const Text('Create Task'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: _buildVariableIcon(
                      Symbols.filter_alt,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    label: const Text('Filter'),
                  ),
                  Chip(
                    avatar: _buildVariableIcon(
                      Symbols.schedule_send,
                      size: 18,
                      color: Colors.green,
                    ),
                    label: const Text('Scheduled Sync'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card.outlined(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: _buildVariableIcon(
                        Symbols.notifications_active_rounded,
                        color: Colors.amber,
                      ),
                      title: const Text('Alerts'),
                      subtitle: const Text(
                        'Rounded symbols fit well in friendly, softer UI surfaces.',
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: _buildVariableIcon(
                          Symbols.more_horiz,
                          size: 22,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: _buildVariableIcon(
                        Symbols.data_usage_sharp,
                        color: Colors.deepPurple,
                      ),
                      title: const Text('Usage Metrics'),
                      subtitle: const Text(
                        'Sharp symbols give denser dashboards a more technical tone.',
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: _buildVariableIcon(
                          Symbols.open_in_new_sharp,
                          size: 22,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ExampleCard(
          title: 'Comparing Families',
          description:
              'The same semantic symbol can be shown in outlined, rounded, or sharp variants depending on the product tone.',
          child: Column(
            children: _symbolGroups.map((group) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 110,
                      child: Text(
                        group.label,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          _buildVariableIcon(
                            group.outlined,
                            color: Colors.blue,
                          ),
                          _buildVariableIcon(group.rounded, color: Colors.teal),
                          _buildVariableIcon(
                            group.sharp,
                            color: Colors.deepOrange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _ExampleCard(
          title: 'Using IconTheme Defaults',
          description:
              'You can push Material Symbol variation defaults through IconThemeData and then let individual Icon widgets inherit them.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Apply IconTheme defaults in preview'),
                subtitle: const Text(
                  'When enabled, the preview below inherits fill, weight, grade, and optical size from IconTheme.',
                ),
                value: _useIconThemeDefaults,
                onChanged: (bool value) {
                  setState(() {
                    _useIconThemeDefaults = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    size: 40,
                    color: Colors.green.shade700,
                    fill: _useIconThemeDefaults ? _fill : null,
                    weight: _useIconThemeDefaults ? _weight : null,
                    grade: _useIconThemeDefaults ? _grade : null,
                    opticalSize: _useIconThemeDefaults ? _opticalSize : null,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(Symbols.palette),
                      Icon(Symbols.draw_rounded),
                      Icon(Symbols.auto_awesome_sharp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Material Symbols Icons Module')),
      body: SelectionArea(
        child: _useIconThemeDefaults
            ? IconTheme(
                data: IconThemeData(
                  fill: _fill,
                  weight: _weight,
                  grade: _grade,
                  opticalSize: _opticalSize,
                ),
                child: demoContent,
              )
            : demoContent,
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

class _SymbolTile extends StatelessWidget {
  const _SymbolTile({
    required this.label,
    required this.icon,
    required this.codeLabel,
  });

  final String label;
  final Widget icon;
  final String codeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          icon,
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            codeLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
