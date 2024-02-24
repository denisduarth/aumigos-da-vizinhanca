import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/all.dart';
import 'package:flutter/material.dart';

const Locale brazilianPortuguese = Locale('pt', 'BR');
const String urlProject = "https://igjmggiujesxhnccuqgo.supabase.co";
const String apiKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlnam1nZ2l1amVzeGhuY2N1cWdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYzMDE2MTEsImV4cCI6MjAyMTg3NzYxMX0.hawMLmnkaing1GVEk2bIU6creIjdQI7-rVxUprP3h2w";

class ConnectionNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const ConnectionNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<bool> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ConnectionNotifier>()!
        .notifier!;
  }
}

final internetConnectionChecker = InternetConnectionChecker.createInstance(
  checkInterval: const Duration(seconds: 1),
  checkTimeout: const Duration(seconds: 1),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: urlProject, anonKey: apiKey);
  final hasConnection = await internetConnectionChecker.hasConnection;

  runApp(
    ConnectionNotifier(
      notifier: ValueNotifier(
        hasConnection,
      ),
      child: const AumigosDaVizinhanca(),
    ),
  );
}

class AumigosDaVizinhanca extends StatefulWidget {
  const AumigosDaVizinhanca({super.key});

  @override
  State<AumigosDaVizinhanca> createState() => _AumigosDaVizinhancaState();
}

class _AumigosDaVizinhancaState extends State<AumigosDaVizinhanca> {
  late final StreamSubscription<InternetConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    listener = internetConnectionChecker.onStatusChange.listen((status) {
      final notifier = ConnectionNotifier.of(context);

      notifier.value =
          status == InternetConnectionStatus.connected ? true : false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (context) => const Homepage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/update-profile': (context) => const UpdateProfilePage(),
        '/more-info': (context) => const MoreInfoPage(),
        '/navigation': (context) => const NavigationPage()
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      locale: brazilianPortuguese,
    );
  }
}
