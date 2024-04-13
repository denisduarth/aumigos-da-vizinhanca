// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, use_build_context_synchronously

import '/src/exports/all.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


const infoTextStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: ComponentColors.mainGray,
);

class ProfilePage extends StatefulWidget {
  final String? title = 'Perfil';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseClient db = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> stream;
  late User? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      try {
        await db.auth.signOut();

        context.showErrorSnackbar("Saindo de ${user!.email}");

        await Future.delayed(Duration(seconds: 2));
        Navigator.pushNamed(context, '/login');
      } on AuthException catch (error) {
        context.showErrorSnackbar(error.message.toString());
      }
    }

    user = db.auth.currentUser;
    stream = db.from('animals').select().eq('userId', user!.id).asStream();
    final hasConnection = context.hasConnection;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
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
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          height: 250,
                          width: context.screenWidth,
                          child: user!.userMetadata?['location'] == null
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : FlutterMap(
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      user!.userMetadata?['location']
                                          ['latitude'],
                                      user!.userMetadata?['location']
                                          ['longitude'],
                                    ),
                                    initialZoom: 18,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.example.aumigos_da_vizinhanca',
                                    ),
                                    RichAttributionWidget(
                                      attributions: [
                                        TextSourceAttribution(
                                          'OpenStreetMap contributors',
                                          onTap: () => launchUrl(
                                            Uri.parse(
                                              'https://openstreetmap.org/copyright',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    height: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      db.storage.from('images').getPublicUrl(
                                          user!.userMetadata?['image']),
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    ),
                            ),
                            IconButtonWidget(
                              icon: Icon(Icons.edit),
                              onPressed: () => Navigator.pushNamed(
                                  context, '/update-profile'),
                              enableBorderSide: true,
                              color: ComponentColors.sweetBrown,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${user!.userMetadata?['name']}",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: ComponentColors.mainBlack),
                            ),
                            IconButtonWidget(
                              icon: Icon(Icons.logout_rounded),
                              onPressed: logout,
                              enableBorderSide: false,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.userMetadata?['location']['street'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']['sublocality'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']
                                  ['sub_administrative_area'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']['postal_code'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']['country'],
                              style: infoTextStyle,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/aumigos_da_vizinhanca_cat_sweet_brown.png',
                              width: 30,
                              height: 30,
                            ),
                            Text(
                              "   Seus animais adicionados",
                              style: TextStyles.textStyle(
                                  fontColor: ComponentColors.mainBlack,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.hasError) {
                            return const CircularProgressIndicator();
                          }

                          final data = snapshot.data ?? [];

                          return data.isEmpty
                              ? const Center(
                                  child: Text("Não há animais adicionados"),
                                )
                              : SingleChildScrollView(
                                  child: SizedBox(
                                    height: 230,
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: data
                                          .map(
                                            (animal) => GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimalDetailsPage(
                                                    animalId: animal['id'],
                                                  ),
                                                ),
                                              ),
                                              child: AnimalSizedBox(
                                                animalName: animal['name'],
                                                animalImagePath:
                                                    animal['image'],
                                                species: animal['species'],
                                                wasFed: animal['wasFed'],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                              width: 30,
                              height: 30,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  "    Animais perto de: ",
                                  style: TextStyles.textStyle(
                                      fontColor: ComponentColors.mainBlack,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "    ${user!.userMetadata?['location']['street']}",
                                  style: TextStyles.textStyle(
                                      fontColor: ComponentColors.sweetBrown,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.hasError) {
                            return const CircularProgressIndicator();
                          }

                          final data = snapshot.data ?? [];

                          return data.isEmpty
                              ? const Center(
                                  child: Text("Não há animais adicionados"),
                                )
                              : SingleChildScrollView(
                                  child: SizedBox(
                                    height: 230,
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: data
                                          .map(
                                            (animal) => GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimalDetailsPage(
                                                    animalId: animal['id'],
                                                  ),
                                                ),
                                              ),
                                              child: AnimalSizedBox(
                                                animalName: animal['name'],
                                                animalImagePath:
                                                    animal['image'],
                                                species: animal['species'],
                                                wasFed: animal['wasFed'],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
