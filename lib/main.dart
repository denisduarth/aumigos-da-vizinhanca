import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/all.dart';
import 'package:flutter/material.dart';

const Locale brazilianPortuguese = Locale('pt', 'BR');
const String urlProject = "https://igjmggiujesxhnccuqgo.supabase.co";
const String apiKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlnam1nZ2l1amVzeGhuY2N1cWdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYzMDE2MTEsImV4cCI6MjAyMTg3NzYxMX0.hawMLmnkaing1GVEk2bIU6creIjdQI7-rVxUprP3h2w";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: urlProject, anonKey: apiKey);
  runApp(const AumigosDaVizinhanca());
}

class AumigosDaVizinhanca extends StatelessWidget {
  const AumigosDaVizinhanca({super.key});

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
        '/navigation':(context) => const NavigationPage()
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      locale: brazilianPortuguese,
    );
  }
}
