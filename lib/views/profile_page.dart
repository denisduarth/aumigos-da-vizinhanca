// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, use_build_context_synchronously

import 'package:aumigos_da_vizinhanca/main.dart';
import 'package:aumigos_da_vizinhanca/views/all.dart';
import '../widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseClient db = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final User? user = db.auth.currentUser;
    final hasConnection = ConnectionNotifier.of(context).value;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: user!.userMetadata?['image'] == null
                            ? Image.asset(
                                'images/user_image.png',
                                width: 110,
                                height: 110,
                              )
                            : Image.network(
                                db.storage
                                    .from('images')
                                    .getPublicUrl(user.userMetadata?['image']),
                                fit: BoxFit.cover,
                                width: 110,
                                height: 110,
                              ),
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
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    height: 170,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${user.email}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          user.id,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: ComponentColors.mainGray,
                          ),
                        ),
                        IconButtonWidget(
                          icon: Icon(Icons.logout_rounded),
                          onPressed: () async {
                            await db.auth.signOut();
                            SnackBarHelper.showSnackBar(
                                context,
                                "Saindo de ${user.email}...",
                                Colors.red,
                                Icons.logout_outlined,
                                false);

                            await Future.delayed(Duration(seconds: 2));
                            Navigator.pushNamed(context, '/login');
                          },
                          enableBorderSide: false,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
