// ignore_for_file: must_be_immutable

import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/add_animal_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/search_animal_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/home_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/profile_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/appbar.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
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
    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar:
            AppBarWidget.showAppBar(context, titles.elementAt(_currentIndex)!),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(
              50,
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: !hasConnection || !isLocationEnabled
                ? Colors.red
                : ComponentColors.sweetBrown,
            elevation: 4.0,
            currentIndex: _currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyles.textStyle(
              fontColor: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 255, 174, 136),
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_rounded, size: 30),
                icon: Icon(Icons.home_outlined, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.search_rounded,
                  size: 30,
                ),
                icon: Icon(Icons.search_outlined, size: 30),
                label: 'Pesquisar',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.add_rounded,
                  size: 30,
                ),
                icon: Icon(Icons.add_outlined, size: 30),
                label: 'Adicionar',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.person_rounded,
                  size: 30,
                ),
                icon: Icon(Icons.person_outline_rounded, size: 30),
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
        body: _screens.elementAt(_currentIndex),
      ),
    );
  }
}
