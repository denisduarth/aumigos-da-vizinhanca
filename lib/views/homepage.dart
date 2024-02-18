import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final user = db.auth.currentUser;
  final db = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(eccentricity: 1),
        backgroundColor: ComponentColors.sweetBrown,
        onPressed: () => {},
        child: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: db.auth.currentSession == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bem-vindo, ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: ComponentColors.mainBlack,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      GradientText(text: "${user?.email}", textSize: 20)
                    ],
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              db.auth.signOut();
              Navigator.pushNamed(context, "/login");
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }
}
