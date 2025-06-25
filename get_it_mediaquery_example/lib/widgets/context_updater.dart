import 'package:flutter/material.dart';
import '../service_locator.dart';

class ContextUpdater extends StatefulWidget {
  final Widget child;

  const ContextUpdater({super.key, required this.child});

  @override
  State<ContextUpdater> createState() => _ContextUpdaterState();
}

class _ContextUpdaterState extends State<ContextUpdater> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getIt<ContextService>().updateContextData(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
