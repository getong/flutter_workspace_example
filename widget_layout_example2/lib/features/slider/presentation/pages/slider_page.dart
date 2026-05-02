import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.slider)
class SliderExamplePage extends StatefulWidget {
  const SliderExamplePage({super.key});

  @override
  State<SliderExamplePage> createState() => _SliderExamplePageState();
}

class _SliderExamplePageState extends State<SliderExamplePage> {
  double _volume = 0.4;
  double _temperature = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slider Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Slider lets users pick a numeric value by dragging a thumb across a track.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _ExampleCard(
              title: 'Basic Slider',
              description:
                  'This is useful for values like volume, opacity, or zoom.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Slider(
                    value: _volume,
                    onChanged: (double value) {
                      setState(() {
                        _volume = value;
                      });
                    },
                  ),
                  Text('Volume: ${(_volume * 100).round()}%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Discrete Slider',
              description:
                  'Divisions and labels help when the value should snap to known steps.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Slider(
                    min: 16,
                    max: 30,
                    divisions: 14,
                    label: '${_temperature.round()}°C',
                    value: _temperature,
                    onChanged: (double value) {
                      setState(() {
                        _temperature = value;
                      });
                    },
                  ),
                  Text('Temperature: ${_temperature.round()}°C'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Disabled Slider',
              description:
                  'A slider becomes disabled when onChanged is null, which can be useful when a related feature is unavailable.',
              child: Slider(value: 0.7, onChanged: null),
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
