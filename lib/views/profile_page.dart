// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, use_build_context_synchronously

import '../widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final SupabaseClient db;
  late final User? user;

  @override
  void initState() {
    db = Supabase.instance.client;
    user = db.auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Image.asset('images/user_image.png'),
                    ),
                    IconButtonWidget(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/update-profile'),
                      enableBorderSide: true,
                      color: ComponentColors.sweetBrown,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${user!.email}    ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          IconButtonWidget(
                            icon: Icon(Icons.logout_rounded),
                            onPressed: () async {
                              await db.auth.signOut();
                              SnackBarHelper.showSnackBar(
                                context,
                                "Saindo de ${user!.email}...",
                                true,
                              );

                              await Future.delayed(Duration(seconds: 2));
                              Navigator.pushNamed(context, '/login');
                            },
                            enableBorderSide: false,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                      Text(
                        user!.id,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ComponentColors.mainGray,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
