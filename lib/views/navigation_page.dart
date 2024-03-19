import 'package:aumigos_da_vizinhanca/extensions/build_context_extension.dart';
import '../exports/views.dart';
import '../exports/widgets.dart';
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
    const SearchAnimalPage(),
    const AddAnimalPage(),
    const ProfilePage(),
  ];

  final titles = [
    const Homepage().title,
    const SearchAnimalPage().title,
    const AddAnimalPage().title,
    const ProfilePage().title,
  ];

  int _currentIndex = 0;
  final db = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final user = db.auth.currentUser;
    final hasConnection = context.hasConnection;

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar:
            AppBarWidget.showAppBar(context, titles.elementAt(_currentIndex)!),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(
              35,
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor:
                !hasConnection ? Colors.red : ComponentColors.sweetBrown,
            elevation: 0,
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 255, 174, 136),
            items: [
              const BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_rounded, size: 30),
                icon: Icon(Icons.home_outlined, size: 30),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.search_rounded,
                  size: 30,
                ),
                icon: Icon(Icons.search_outlined, size: 30),
                label: 'Pequisar',
              ),
              const BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.add_rounded,
                  size: 30,
                ),
                icon: Icon(Icons.add_outlined, size: 30),
                label: 'Adicionar Animal',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  width: 35,
                  height: 35,
                  child: ClipOval(
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
        ),
        body: _screens.elementAt(_currentIndex));
  }
}
