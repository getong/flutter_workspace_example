import 'package:flutter/material.dart';

/// Interactive example allowing users to adjust flex values
class InteractiveExample extends StatefulWidget {
  const InteractiveExample({super.key});

  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  int _flexValue1 = 1;
  int _flexValue2 = 1;
  int _flexValue3 = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFlexControl(
              'Flex 1',
              _flexValue1,
              (value) => setState(() => _flexValue1 = value),
            ),
            _buildFlexControl(
              'Flex 2',
              _flexValue2,
              (value) => setState(() => _flexValue2 = value),
            ),
            _buildFlexControl(
              'Flex 3',
              _flexValue3,
              (value) => setState(() => _flexValue3 = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Interactive row
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: _flexValue1,
                child: ColoredBox(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'flex: $_flexValue1',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: _flexValue2,
                child: ColoredBox(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'flex: $_flexValue2',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: _flexValue3,
                child: ColoredBox(
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'flex: $_flexValue3',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlexControl(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(label),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove),
            ),
            Text('$value'),
            IconButton(
              onPressed: value < 5 ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
