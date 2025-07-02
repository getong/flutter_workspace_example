import 'package:flutter/material.dart';

/// Widget that displays information about Future cancellation techniques
class FutureInfoWidget extends StatelessWidget {
  const FutureInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Understanding Dart Futures',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'A Future represents a computation that doesn\'t complete immediately. '
                  'It\'s used for asynchronous operations like network requests, file I/O, '
                  'or any time-consuming task.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cancellation Techniques:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text('• Use Completer to manually control Future completion'),
                const Text('• Use Timer.cancel() to stop periodic operations'),
                const Text('• Use timeout() method for automatic cancellation'),
                const Text('• Check mounted property before setState()'),
                const Text('• Clean up resources in dispose() method'),
                const Text('• Use CancelToken for HTTP requests (with dio package)'),
                const Text('• Use Stream.listen().cancel() for stream subscriptions'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
