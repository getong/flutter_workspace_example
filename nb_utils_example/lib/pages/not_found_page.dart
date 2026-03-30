import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({required this.location, super.key});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route not found')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.search_off_outlined, size: 52),
                    16.height,
                    Text(
                      'No page for $location',
                      style: boldTextStyle(size: 22),
                    ),
                    8.height,
                    Text(
                      'Use the home page to navigate to the demo routes.',
                      style: secondaryTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                    20.height,
                    AppButton(text: 'Back Home', onTap: () => context.go('/')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
