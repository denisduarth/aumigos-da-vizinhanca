import 'package:aumigos_da_vizinhanca/main.dart';
import 'package:flutter/material.dart';
import '../exports/widgets.dart';


extension BuildContextExtension on BuildContext {
  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  bool get hasConnection {
    return ConnectionNotifier.of(this).value;
  }

  Object? get getPreviousRouteArguments {
    return ModalRoute.of(this)!.settings.arguments;
  }

  dynamic pushNamedWithArguments(String routeName, Object? arguments) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void showSucessSnackbar(String? message) {
    SnackBarHelper().showSucessSnackbar(message, this);
  }

  void showErrorSnackbar(String? message) {
    SnackBarHelper().showErrorSnackbar(message, this);
  }
}
