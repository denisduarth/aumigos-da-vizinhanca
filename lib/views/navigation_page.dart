import 'package:aumigos_da_vizinhanca/main.dart';
import 'package:aumigos_da_vizinhanca/views/all.dart';
import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> _screens = [
    const Homepage(),
    const ProfilePage(),
  ];

  int _currentIndex = 0;
  final db = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final user = db.auth.currentUser;
    final hasConnection = ConnectionNotifier.of(context).value;

    return Scaffold(
        appBar: AppBar(
          shadowColor: ComponentColors.sweetBrown,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          elevation: 4.0,
          backgroundColor:
              !hasConnection ? Colors.red : ComponentColors.sweetBrown,
          centerTitle: true,
          title: !hasConnection
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Tentando reconectar",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              : Image.asset(
                  'images/aumigos_da_vizinhanca_logo_white.png',
                  width: 30,
                  height: 30,
                ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              !hasConnection ? Colors.red : ComponentColors.sweetBrown,
          currentIndex: _currentIndex,
          showUnselectedLabels: false,
          elevation: 4.0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          items: [
            const BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_rounded),
                icon: Icon(Icons.home_outlined),
                label: 'Home'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: user!.userMetadata?['image'] == null
                      ? Image.asset('images/user_image.png')
                      : Image.network(
                          db.storage.from('images').getPublicUrl(
                                user.userMetadata?['image'],
                              ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              label: 'Perfil',
            ),
          ],
          onTap: (index) => setState(
            () {
              _currentIndex = index;
            },
          ),
        ),
        body: _screens.elementAt(_currentIndex));
  }
}
