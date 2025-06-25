import 'package:flutter/material.dart';
import '../service_locator.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final contextService = getIt<ContextService>();
    final mediaQuery = contextService.mediaQueryData;
    final theme = contextService.themeData;

    return AlertDialog(
      title: const Text('Context Info from GetIt'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Screen Width: ${mediaQuery.size.width.toStringAsFixed(1)}'),
          Text('Screen Height: ${mediaQuery.size.height.toStringAsFixed(1)}'),
          Text('Device Pixel Ratio: ${mediaQuery.devicePixelRatio}'),
          Text('Text Scale Factor: ${mediaQuery.textScaleFactor}'),
          const SizedBox(height: 16),
          Text('Primary Color: ${theme.primaryColor}'),
          Text('Brightness: ${theme.brightness}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => contextService.navigatorState.pop(),
          child: const Text('Close (via GetIt Navigator)'),
        ),
      ],
    );
  }
}
