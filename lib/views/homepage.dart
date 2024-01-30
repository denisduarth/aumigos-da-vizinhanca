import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final SupabaseClient db;
  late final User? user;

  @override
  void initState() {
    super.initState();
    db = Supabase.instance.client;
    user = db.auth.currentUser;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("${user?.email}"),
            ElevatedButton(
              onPressed: () async => await db.auth
                  .signOut()
                  .then((value) => Navigator.of(context).pushNamed("/login")),
              child: const Text("Sair"),
            ),
          ],
        ),
      ),
    );
  }
}
