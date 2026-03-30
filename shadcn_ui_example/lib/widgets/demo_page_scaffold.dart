import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DemoPageScaffold extends StatelessWidget {
  const DemoPageScaffold({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.child,
    this.actions = const <Widget>[],
    super.key,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<Widget> actions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ShadThemeData theme = ShadTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ShadBadge.secondary(child: Text(eyebrow)),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.h1),
              const SizedBox(height: 12),
              Text(description, style: theme.textTheme.lead),
              if (actions.isNotEmpty) ...<Widget>[
                const SizedBox(height: 20),
                Wrap(spacing: 12, runSpacing: 12, children: actions),
              ],
              const SizedBox(height: 28),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
