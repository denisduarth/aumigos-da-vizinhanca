// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, await_only_futures

import 'dart:core';

import 'package:aumigos_da_vizinhanca/src/enums/images_enum.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/images_enum_extension.dart';
import 'package:aumigos_da_vizinhanca/src/repositories/animal_repository.dart';
import 'package:aumigos_da_vizinhanca/src/services/location_service.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/animal_details_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/gradient_text.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
import "package:flutter/material.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../src/enums/text_align_enums.dart';
import '../../src/mixins/validator_mixin.dart';
import '../extensions/build_context_extension.dart';

final userLocationTextStyle = TextStyles.textStyle(
  fontColor: ComponentColors.mainGray,
  fontSize: 11.75,
  fontWeight: FontWeight.w700,
);

class Homepage extends StatefulWidget {
  final String title = 'Home';
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with ValidatorMixin {
  late final user = db.auth.currentUser;
  final db = Supabase.instance.client;
  final searchControlller = TextEditingController();
  final locationService = LocationService();
  final animalRepository = AnimalRepository();
  late Stream<List<Map<String, dynamic>>> stream;
  late Stream<List<Map<String, dynamic>>> streamCurrentStreet;
  late Stream<List<Map<String, dynamic>>> streamNotFed;
  late Position? currentPosition;

  @override
  void dispose() {
    super.dispose();
    searchControlller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _getCurrentLocation() async {
    await locationService.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    currentPosition = locationService.currentPosition;
    final String currentStreet =
        locationService.currentAddress.split(',').first;

    streamNotFed = db
        .from('animals')
        .select()
        .eq('street', currentStreet)
        .eq('wasFed', false)
        .asStream();
    streamCurrentStreet =
        db.from('animals').select().eq('street', currentStreet).asStream();
    stream = animalRepository.getAnimalsByUserId(user!.id);
    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;
    if (!hasConnection) return const NetworkErrorPage();
    if (!isLocationEnabled) return const LocationErrorPage();

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        height: 250,
                        width: context.screenWidth,
                        child: currentPosition == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(
                                    currentPosition!.latitude,
                                    currentPosition!.longitude,
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
                                  MarkerLayer(markers: [
                                    Marker(
                                        point: LatLng(
                                          currentPosition!.latitude,
                                          currentPosition!.longitude,
                                        ),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 60,
                                        )),
                                  ])
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipOval(
                          child: user == null
                              ? Image.asset('images/user_image.png')
                              : Image.network(
                                  db.storage.from('images').getPublicUrl(
                                        user!.userMetadata?['image'],
                                      ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            "Bem-vindo, ",
                            style: TextStyles.textStyle(
                              fontColor: ComponentColors.mainBlack,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          GradientText(
                              text: "${user!.userMetadata?['name']}",
                              textSize: 26,
                              textAlign: TextAlignEnum.start),
                        ],
                      ),
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
                            ImagesEnum.catMainYellow.imageName,
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "   Seus animais  ",
                            style: TextStyles.textStyle(
                                fontColor: ComponentColors.mainBlack,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "adicionados",
                            style: TextStyles.textStyle(
                                fontColor: ComponentColors.mainYellow,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700),
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
                                    padding: const EdgeInsets.symmetric(
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
                                              animalImagePath: animal['image'],
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
                            ImagesEnum.logoSweetBrown.imageName,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Wrap(
                            direction: Axis.vertical,
                            children: [
                              Text(
                                "Animais perto de: ",
                                style: TextStyles.textStyle(
                                    fontColor: ComponentColors.mainBlack,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                currentStreet,
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
                      stream: streamCurrentStreet,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.hasError) {
                          return const CircularProgressIndicator();
                        }

                        final data = snapshot.data ?? [];

                        return data.isEmpty
                            ? Center(
                                child: Text(
                                  "Não há animais perto de '$currentStreet'",
                                  style: TextStyles.textStyle(
                                      fontColor: ComponentColors.mainGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : SingleChildScrollView(
                                child: SizedBox(
                                  height: 230,
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
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
                                              animalImagePath: animal['image'],
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Image.asset(
                            ImagesEnum.notFed.imageName,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Wrap(
                            direction: Axis.vertical,
                            children: [
                              Text(
                                "Não alimentados perto de: ",
                                style: TextStyles.textStyle(
                                    fontColor: ComponentColors.mainBlack,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                currentStreet,
                                style: TextStyles.textStyle(
                                    fontColor: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: streamNotFed,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.hasError) {
                          return const CircularProgressIndicator();
                        }

                        final data = snapshot.data ?? [];

                        return data.isEmpty
                            ? Center(
                                child: Text(
                                  "Não há animais alimentados em '$currentStreet'",
                                  style: TextStyles.textStyle(
                                      fontColor: ComponentColors.mainGray,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : SingleChildScrollView(
                                child: SizedBox(
                                  height: 230,
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: data
                                        .map(
                                          (animal) => GestureDetector(
                                            onLongPress: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AnimalDetailsPage(
                                                  animalId: animal['id'],
                                                ),
                                              ),
                                            ),
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
                                              animalImagePath: animal['image'],
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
    );
  }
}

class AnimalSizedBox extends StatelessWidget {
  final db = Supabase.instance.client;

  String animalName;
  String animalImagePath;
  String species;
  bool wasFed;

  AnimalSizedBox({
    required this.animalName,
    required this.animalImagePath,
    required this.species,
    required this.wasFed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              db.storage.from('animals.images').getPublicUrl(
                    animalImagePath,
                  ),
              height: 120,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        animalName,
                        style: TextStyles.textStyle(
                          fontColor: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    species == 'cat' ? "Gato" : "Cachorro",
                    style: TextStyles.textStyle(
                      fontColor: ComponentColors.mainBrown,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    wasFed ? "Alimentado" : "Não alimentado",
                    style: TextStyles.textStyle(
                        fontColor: wasFed ? Colors.green : Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
