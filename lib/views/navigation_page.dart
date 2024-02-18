import 'package:aumigos_da_vizinhanca/views/all.dart';
import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
          width: 50,
          height: 50,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        currentIndex: _currentIndex,
        showUnselectedLabels: false,
        selectedItemColor: ComponentColors.sweetBrown,
        unselectedLabelStyle: const TextStyle(fontFamily: "Poppins"),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: "Poppins",
        ),
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_rounded),
            icon: Icon(Icons.home_outlined),
            label: "Início",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person_rounded),
            icon: Icon(Icons.person_outline),
            label: "Perfil",
          ),
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
      body: _screens.elementAt(_currentIndex),
    );
  }
}
