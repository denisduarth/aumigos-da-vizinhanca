// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../main.dart';
import 'all.dart';

class MoreInfoPage extends StatefulWidget {
  const MoreInfoPage({super.key});

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;

    if (!hasConnection) return const NetworkErrorPage();

    return const Scaffold(
      body: Center(
        child: Text(
          "Suas informações aqui",
        ),
      ),
    );
  }
}
