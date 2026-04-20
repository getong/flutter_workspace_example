import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

enum _ShippingSpeed { standard, express, overnight }

@RoutePage()
class RadioExamplePage extends StatefulWidget {
  const RadioExamplePage({super.key});

  @override
  State<RadioExamplePage> createState() => _RadioExamplePageState();
}

class _RadioExamplePageState extends State<RadioExamplePage> {
  _ShippingSpeed _shippingSpeed = _ShippingSpeed.express;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Radio is used when the user must pick exactly one option from a group.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'RadioListTile Group',
              description:
                  'RadioListTile is the most common pattern for a mutually exclusive set of choices.',
              child: RadioGroup<_ShippingSpeed>(
                groupValue: _shippingSpeed,
                onChanged: _handleChanged,
                child: Column(
                  children: <Widget>[
                    const RadioListTile<_ShippingSpeed>(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Standard shipping'),
                      subtitle: Text('3-5 business days'),
                      value: _ShippingSpeed.standard,
                    ),
                    const RadioListTile<_ShippingSpeed>(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Express shipping'),
                      subtitle: Text('1-2 business days'),
                      value: _ShippingSpeed.express,
                    ),
                    const RadioListTile<_ShippingSpeed>(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Overnight'),
                      subtitle: Text('Next business day'),
                      value: _ShippingSpeed.overnight,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Compact Custom Row',
              description:
                  'You can also compose Radio widgets manually when you need a tighter custom layout.',
              child: RadioGroup<_ShippingSpeed>(
                groupValue: _shippingSpeed,
                onChanged: _handleChanged,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: _ShippingSpeed.values.map((_ShippingSpeed option) {
                    return _RadioChip(
                      speed: option,
                      selected: _shippingSpeed == option,
                      onSelected: () => _handleChanged(option),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Selected Value',
              description:
                  'The selected radio value usually drives pricing, form state, or next-step logic.',
              child: Text(
                'Current selection: ${_labelFor(_shippingSpeed)}',
                style: Theme.of(context).textTheme.titleSmall,
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

  void _handleChanged(_ShippingSpeed? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _shippingSpeed = value;
    });
  }

  String _labelFor(_ShippingSpeed value) {
    switch (value) {
      case _ShippingSpeed.standard:
        return 'Standard shipping';
      case _ShippingSpeed.express:
        return 'Express shipping';
      case _ShippingSpeed.overnight:
        return 'Overnight';
    }
  }
}

class _RadioChip extends StatelessWidget {
  const _RadioChip({
    required this.speed,
    required this.selected,
    required this.onSelected,
  });

  final _ShippingSpeed speed;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
              : Colors.grey.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Radio<_ShippingSpeed>(value: speed),
            Text(speed.name),
          ],
        ),
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
