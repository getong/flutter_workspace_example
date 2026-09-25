import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_store.dart';

class TravelScope extends InheritedNotifier<TravelStore> {
  const TravelScope({
    super.key,
    required TravelStore store,
    required super.child,
  }) : super(notifier: store);
  static TravelStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TravelScope>()!.notifier!;
}
