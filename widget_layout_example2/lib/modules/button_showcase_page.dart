import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.classicButtons)
class ButtonShowcasePage extends StatefulWidget {
  const ButtonShowcasePage({super.key});

  @override
  State<ButtonShowcasePage> createState() => _ButtonShowcasePageState();
}

class _ButtonShowcasePageState extends State<ButtonShowcasePage> {
  String _selectedPriority = 'Normal';
  String _selectedMenuAction = 'Nothing selected yet';
  final List<bool> _selectedFormats = <bool>[true, false, false];
  bool _notificationsEnabled = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Classic Buttons Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'This module collects classic Material button APIs, menu buttons, icon buttons, grouped buttons, and the modern replacements for removed legacy widgets.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'RaisedButton, FlatButton, and OutlineButton were removed from newer Flutter releases, so this page shows their direct replacements while still demonstrating the remaining APIs you requested.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _ButtonInfoCard(
              title: 'Legacy button migrations',
              description:
                  'RaisedButton -> ElevatedButton, FlatButton -> TextButton, and OutlineButton -> OutlinedButton. If you need old tutorials translated to current Flutter, these are the one-to-one replacements to reach for first.',
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title:
                  '1. RaisedButton, FlatButton, OutlineButton -> modern replacements',
              description:
                  'These three widgets no longer exist in this SDK, so the examples below show the equivalent modern APIs you should use instead.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _showMessage(
                      'Use ElevatedButton instead of RaisedButton.',
                    ),
                    child: const Text('RaisedButton -> ElevatedButton'),
                  ),
                  TextButton(
                    onPressed: () =>
                        _showMessage('Use TextButton instead of FlatButton.'),
                    child: const Text('FlatButton -> TextButton'),
                  ),
                  OutlinedButton(
                    onPressed: () => _showMessage(
                      'Use OutlinedButton instead of OutlineButton.',
                    ),
                    child: const Text('OutlineButton -> OutlinedButton'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '2. DropdownButton',
              description:
                  'DropdownButton is useful when one value must be selected from a compact list of options.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPriority,
                        isExpanded: true,
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'Low',
                            child: Text('Low Priority'),
                          ),
                          DropdownMenuItem(
                            value: 'Normal',
                            child: Text('Normal Priority'),
                          ),
                          DropdownMenuItem(
                            value: 'High',
                            child: Text('High Priority'),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Selected priority: $_selectedPriority'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '3. RawMaterialButton',
              description:
                  'RawMaterialButton gives lower-level control over size, shape, elevation, and fill when higher-level buttons are too opinionated.',
              child: Row(
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () => _showMessage('RawMaterialButton pressed.'),
                    fillColor: Colors.deepOrange,
                    constraints: const BoxConstraints.tightFor(
                      width: 160,
                      height: 56,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.flash_on, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Launch',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '4. PopupMenuButton',
              description:
                  'PopupMenuButton reveals a small menu anchored to a button or icon for overflow actions.',
              child: Row(
                children: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        _selectedMenuAction = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return const <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Duplicate draft',
                          child: Text('Duplicate draft'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Archive item',
                          child: Text('Archive item'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Share link',
                          child: Text('Share link'),
                        ),
                      ];
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.more_horiz),
                          SizedBox(width: 8),
                          Text('Open menu'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text('Last menu action: $_selectedMenuAction'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '5. IconButton, BackButton, CloseButton',
              description:
                  'These compact action buttons are common in toolbars, sheets, dialogs, and dense interfaces.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  IconButton.filled(
                    onPressed: () => _showMessage('IconButton pressed.'),
                    icon: const Icon(Icons.favorite_border),
                    tooltip: 'Favorite',
                  ),
                  BackButton(
                    onPressed: () =>
                        _showMessage('BackButton tapped with custom handler.'),
                  ),
                  CloseButton(
                    onPressed: () =>
                        _showMessage('CloseButton tapped with custom handler.'),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _notificationsEnabled = !_notificationsEnabled;
                      });
                    },
                    icon: Icon(
                      _notificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                    ),
                    tooltip: 'Toggle notifications',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '6. ButtonBar',
              description:
                  'ButtonBar groups related actions and manages spacing/alignment for a compact action row.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                // ignore: deprecated_member_use
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 12),
                  children: <Widget>[
                    TextButton(
                      onPressed: () => _showMessage('Cancel action tapped.'),
                      child: const Text('Cancel'),
                    ),
                    OutlinedButton(
                      onPressed: () => _showMessage('Preview action tapped.'),
                      child: const Text('Preview'),
                    ),
                    ElevatedButton(
                      onPressed: () => _showMessage('Publish action tapped.'),
                      child: const Text('Publish'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '7. ToggleButtons',
              description:
                  'ToggleButtons is useful for small multi-option controls such as formatting or segmented command bars.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ToggleButtons(
                    isSelected: _selectedFormats,
                    onPressed: (int index) {
                      setState(() {
                        _selectedFormats[index] = !_selectedFormats[index];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    selectedColor: Colors.white,
                    fillColor: colorScheme.primary,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.format_bold),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.format_italic),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.format_underlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Selected: ${_formatSelectionSummary()}',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ButtonExampleCard(
              title: '8. Mixed toolbar usage',
              description:
                  'These widgets often work together in a compact action bar with dropdowns, menus, icon actions, and primary buttons.',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _selectedPriority,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedPriority = value;
                        });
                      },
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'Quick actions',
                      onSelected: (String value) => _showMessage(value),
                      itemBuilder: (BuildContext context) =>
                          const <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Rename item',
                              child: Text('Rename'),
                            ),
                            PopupMenuItem<String>(
                              value: 'Move item',
                              child: Text('Move'),
                            ),
                          ],
                    ),
                    IconButton(
                      onPressed: () => _showMessage('Search tapped.'),
                      icon: const Icon(Icons.search),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showMessage('Save toolbar action tapped.'),
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save'),
                    ),
                  ],
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

  String _formatSelectionSummary() {
    final List<String> labels = <String>[];
    if (_selectedFormats[0]) {
      labels.add('bold');
    }
    if (_selectedFormats[1]) {
      labels.add('italic');
    }
    if (_selectedFormats[2]) {
      labels.add('underline');
    }
    return labels.isEmpty ? 'none' : labels.join(', ');
  }
}

class _ButtonExampleCard extends StatelessWidget {
  const _ButtonExampleCard({
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

class _ButtonInfoCard extends StatelessWidget {
  const _ButtonInfoCard({required this.title, required this.description});

  final String title;
  final String description;

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
          ],
        ),
      ),
    );
  }
}
