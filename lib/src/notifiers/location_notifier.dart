import 'package:flutter/material.dart';

class LocationNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const LocationNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<bool> of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocationNotifier>()!.notifier!;
}
