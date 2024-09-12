import 'package:aumigos_da_vizinhanca/src/notifiers/location_notifier.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/snackbar_helper.dart';
import 'package:flutter/material.dart';
import '../notifiers/connection_notifier.dart';

extension BuildContextExtension on BuildContext {
  static final snackbar = SnackBarHelper();

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get hasConnection => ConnectionNotifier.of(this).value;
  bool get isLocationEnabled => LocationNotifier.of(this).value;
  Object? get getPreviousRouteArguments =>
      ModalRoute.of(this)!.settings.arguments;
  dynamic pushNamedWithArguments(String routeName, Object? arguments) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  void showSucessSnackbar(String? message) =>
      snackbar.showSucessSnackbar(message ?? "", this);

  void showErrorSnackbar(String? message) =>
      snackbar.showErrorSnackbar(message ?? "", this);
}
