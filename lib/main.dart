// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:aumigos_da_vizinhanca/src/notifiers/location_notifier.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/add_animal_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/not_fed_animals.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/search_animal_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/home_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/login_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/more_info_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/navigation_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/profile_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/register_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/notifiers/connection_notifier.dart';

const Locale brazilianPortuguese = Locale('pt', 'BR');

final internetConnectionChecker = InternetConnectionChecker.createInstance(
  checkInterval: const Duration(seconds: 1),
  checkTimeout: const Duration(seconds: 1),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://igjmggiujesxhnccuqgo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlnam1nZ2l1amVzeGhuY2N1cWdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYzMDE2MTEsImV4cCI6MjAyMTg3NzYxMX0.hawMLmnkaing1GVEk2bIU6creIjdQI7-rVxUprP3h2w',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  final hasConnection = await internetConnectionChecker.hasConnection;
  final locationEnabled = await Geolocator.isLocationServiceEnabled();

  runApp(
    ConnectionNotifier(
      notifier: ValueNotifier(hasConnection),
      child: LocationNotifier(
        notifier: ValueNotifier(locationEnabled),
        child: const AumigosDaVizinhanca(),
      ),
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
  late final Timer locationCheckTimer;

  @override
  void initState() {
    super.initState();
    listener = internetConnectionChecker.onStatusChange.listen((status) {
      final notifier = ConnectionNotifier.of(context);

      notifier.value =
          status == InternetConnectionStatus.connected ? true : false;
    });

    locationCheckTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      final locationNotifier = LocationNotifier.of(context);
      locationNotifier.value = isLocationEnabled;
    });
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
    locationCheckTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aumigos da Vizinhança",
      routes: {
        '/home': (context) => const Homepage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/update-profile': (context) => const UpdateProfilePage(),
        '/more-info': (context) => const MoreInfoPage(),
        '/navigation': (context) => const NavigationPage(),
        '/add-animal': (context) => const AddAnimalPage(),
        '/search-animal': (context) => const SearchAnimalPage(),
        '/not-fed-animals': (context) => const NotFedAnimalsPage(),
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      locale: brazilianPortuguese,
    );
  }
}
