import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'InputChipRoute')
class InputChipPage extends StatefulWidget {
  const InputChipPage({super.key});

  @override
  State<InputChipPage> createState() => _InputChipPageState();
}

class _InputChipPageState extends State<InputChipPage> {
  final List<_PersonChipData> _activePeople = <_PersonChipData>[
    const _PersonChipData('Ava', 'Designer', Colors.pink),
    const _PersonChipData('Milo', 'Engineer', Colors.indigo),
    const _PersonChipData('Nia', 'PM', Colors.teal),
    const _PersonChipData('Owen', 'QA', Colors.orange),
  ];
  final List<_PersonChipData> _removedPeople = <_PersonChipData>[];

  String? _selectedPerson = 'Milo';
  bool _showCheckmark = true;
  bool _allowDelete = true;

  void _removePerson(_PersonChipData person) {
    setState(() {
      _activePeople.remove(person);
      _removedPeople.add(person);
      if (_selectedPerson == person.name) {
        _selectedPerson = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${person.name} removed from recipients.')),
    );
  }

  void _restoreAllPeople() {
    if (_removedPeople.isEmpty) {
      return;
    }

    setState(() {
      _activePeople.addAll(_removedPeople);
      _removedPeople.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('InputChip Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'InputChip represents a person, label, or compact piece of data that can be selected, edited, or deleted.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              'This example combines selection state, avatars, deletion, disabled chips, and recovery actions.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Recipient Chips',
              description:
                  'Tap a chip to focus it. Use the delete icon to remove it from the active recipient list.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _activePeople.map((_PersonChipData person) {
                      final bool isSelected = _selectedPerson == person.name;
                      return InputChip(
                        avatar: CircleAvatar(
                          backgroundColor: person.color.withValues(alpha: 0.22),
                          child: Text(
                            person.name.characters.first,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        label: Text('${person.name} · ${person.role}'),
                        selected: isSelected,
                        showCheckmark: _showCheckmark,
                        selectedColor: person.color.withValues(alpha: 0.20),
                        tooltip: 'Recipient ${person.name}',
                        onSelected: (bool value) {
                          setState(() {
                            _selectedPerson = value ? person.name : null;
                          });
                        },
                        onDeleted: _allowDelete
                            ? () => _removePerson(person)
                            : null,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedPerson == null
                        ? 'Focused recipient: none'
                        : 'Focused recipient: $_selectedPerson',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Chip Behavior Controls',
              description:
                  'InputChip can expose different interaction affordances without changing the overall layout.',
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Show selection checkmark'),
                    subtitle: const Text(
                      'Useful when the chip is acting like a compact selector.',
                    ),
                    value: _showCheckmark,
                    onChanged: (bool value) {
                      setState(() {
                        _showCheckmark = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Allow deleting recipients'),
                    subtitle: const Text(
                      'Turning this off leaves the chips selectable but not removable.',
                    ),
                    value: _allowDelete,
                    onChanged: (bool value) {
                      setState(() {
                        _allowDelete = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      InputChip(
                        avatar: CircleAvatar(child: Text('R')),
                        label: Text('Read only'),
                        isEnabled: false,
                      ),
                      InputChip(
                        avatar: CircleAvatar(child: Text('D')),
                        label: Text('Disabled delete icon'),
                        isEnabled: false,
                        onDeleted: null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Removed Recipients',
              description:
                  'Keep deleted data nearby so users can recover quickly when a chip is removed by mistake.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (_removedPeople.isEmpty)
                    const Text('No chips have been removed yet.')
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _removedPeople.map((_PersonChipData person) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: person.color.withValues(
                              alpha: 0.22,
                            ),
                            child: Text(person.name.characters.first),
                          ),
                          label: Text('${person.name} archived'),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _removedPeople.isEmpty
                        ? null
                        : _restoreAllPeople,
                    icon: const Icon(Icons.restore),
                    label: const Text('Restore All Removed Chips'),
                  ),
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

class _PersonChipData {
  const _PersonChipData(this.name, this.role, this.color);

  final String name;
  final String role;
  final Color color;
}
