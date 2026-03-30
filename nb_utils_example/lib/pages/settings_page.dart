import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _compactCards = true;
  bool _pushAlerts = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings Lab')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text('SettingSection widgets', style: boldTextStyle(size: 24)),
          8.height,
          Text(
            'This page demonstrates how `SettingSection` and '
            '`SettingItemWidget` can be used for route shortcuts and local options.',
            style: secondaryTextStyle(),
          ),
          18.height,
          Card(
            clipBehavior: Clip.antiAlias,
            child: SettingSection(
              title: Text('Router shortcuts', style: boldTextStyle(size: 18)),
              subTitle: Text(
                'Jump into other pages without building custom list tiles each time.',
                style: secondaryTextStyle(),
              ),
              headingDecoration: BoxDecoration(
                color: colorScheme.primaryContainer,
              ),
              divider: const Divider(height: 0),
              items: <Widget>[
                SettingItemWidget(
                  title: 'Open components gallery',
                  subTitle: 'Route name: components',
                  leading: const Icon(Icons.widgets_outlined),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => context.goNamed('components'),
                ),
                const Divider(height: 0),
                SettingItemWidget(
                  title: 'Open form playground',
                  subTitle: 'Route name: form-playground',
                  leading: const Icon(Icons.edit_note_outlined),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => context.goNamed('form-playground'),
                ),
                const Divider(height: 0),
                SettingItemWidget(
                  title: 'Open launch recipe',
                  subTitle: 'Dynamic route: /recipes/launch-plan',
                  leading: const Icon(Icons.event_available_outlined),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () => context.goNamed(
                    'recipe',
                    pathParameters: const <String, String>{
                      'slug': 'launch-plan',
                    },
                  ),
                ),
              ],
            ),
          ),
          16.height,
          Card(
            clipBehavior: Clip.antiAlias,
            child: SettingSection(
              title: Text('Local preferences', style: boldTextStyle(size: 18)),
              subTitle: Text(
                'Package widgets can still host richer trailing controls.',
                style: secondaryTextStyle(),
              ),
              headingDecoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
              divider: const Divider(height: 0),
              items: <Widget>[
                SettingItemWidget(
                  title: 'Compact cards',
                  subTitle: 'Reduce card padding in overview pages',
                  leading: const Icon(Icons.view_agenda_outlined),
                  trailing: Switch.adaptive(
                    value: _compactCards,
                    onChanged: (bool value) {
                      setState(() {
                        _compactCards = value;
                      });
                    },
                  ),
                ),
                const Divider(height: 0),
                SettingItemWidget(
                  title: 'Push alerts',
                  subTitle: 'Toast a status update when changes ship',
                  leading: const Icon(Icons.notifications_active_outlined),
                  trailing: Switch.adaptive(
                    value: _pushAlerts,
                    onChanged: (bool value) {
                      setState(() {
                        _pushAlerts = value;
                      });

                      toasty(
                        context,
                        value ? 'Push alerts enabled' : 'Push alerts disabled',
                        gravity: ToastGravity.BOTTOM,
                      );
                    },
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
