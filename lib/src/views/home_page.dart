// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'dart:core';
import '../../src/enums/text_align_enums.dart';
import '../../src/exports/widgets.dart';
import '../../src/mixins/validator_mixin.dart';
import '../../src/exports/views.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../exports/services.dart';
import '../extensions/build_context_extension.dart';
import '../widgets/text_styles.dart';
import '../repositories/animal_repository.dart';

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
  final _locationService = LocationService();
  final animalRepository = AnimalRepository();
  late Stream<List<Map<String, dynamic>>> stream;
  late Stream<List<Map<String, dynamic>>> streamCurrentStreet;
  late Position? currentPosition;
  final focusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    searchControlller.dispose();
  }

  _getCurrentLocation() async {
    try {
      await _locationService.getCurrentLocation();
    } on Exception catch (error) {
      context.showErrorSnackbar(error.toString());
    }
  }

  getAnimalDataByName(String name) {
    final animalData = animalRepository.getAnimalsByName(name);
    setState(
      () {
        stream = name.isNotEmpty
            ? animalData
            : animalRepository.getAnimalsByUserId(user!.id);
      },
    );
  }

  Future<bool> isLocationEnabled() async {
    return await _isLocationServiceEnabled();
  }

  Future<bool> _isLocationServiceEnabled() async {
    final isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();
    return isLocationServiceEnabled;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;
    final String currentStreet =
        _locationService.currentAddress.split(',').first;
    streamCurrentStreet =
        db.from('animals').select().eq('street', currentStreet).asStream();
    stream = animalRepository.getAnimalsByUserId(user!.id);
    currentPosition = _locationService.currentPosition;

    if (!hasConnection) return const NetworkErrorPage();

    return PopScope(
      canPop: false,
      child: FutureBuilder(
        future: isLocationEnabled(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.hasError) {
            return const Text("Ative o serviço de localização");
          } else {
            return Scaffold(
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
                                      ],
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextForm(
                              labelText: "Pesquisar",
                              controller: searchControlller,
                              icon: const Icon(Icons.search_rounded),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: isEmpty,
                              onFieldSubmitted: (value) {
                                getAnimalDataByName(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  "Bem-vindo, ",
                                  style: TextStyles.textStyle(
                                    fontColor: ComponentColors.mainBlack,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                GradientText(
                                    text: "${user!.userMetadata?['name']}",
                                    textSize: 30,
                                    textAlign: TextAlignEnum.start),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user!.userMetadata?['location']['street'],
                                    style: userLocationTextStyle,
                                  ),
                                  Text(
                                    user!.userMetadata?['location']
                                        ['sublocality'],
                                    style: userLocationTextStyle,
                                  ),
                                  Text(
                                    user!.userMetadata?['location']
                                        ['sub_administrative_area'],
                                    style: userLocationTextStyle,
                                  ),
                                  Text(
                                    user!.userMetadata?['location']
                                        ['postal_code'],
                                    style: userLocationTextStyle,
                                  ),
                                  Text(
                                    user!.userMetadata?['location']['country'],
                                    style: userLocationTextStyle,
                                  ),
                                ],
                              ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            child: SizedBox(
                              width: context.screenWidth,
                              height: 50,
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: textGestureDetector(
                                      "Gatos",
                                      focusNode,
                                      () {
                                        setState(
                                          () {
                                            stream = db
                                                .from('animals')
                                                .select()
                                                .eq('species', 'cat')
                                                .asStream();

                                            streamCurrentStreet = db
                                                .from('animals')
                                                .select()
                                                .eq('street', currentStreet)
                                                .eq('species', 'cat')
                                                .asStream();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: textGestureDetector(
                                      "Cachorros",
                                      focusNode,
                                      () {
                                        setState(
                                          () {
                                            stream = db
                                                .from('animals')
                                                .select()
                                                .eq('species', 'dog')
                                                .asStream();

                                            streamCurrentStreet = db
                                                .from('animals')
                                                .select()
                                                .eq('street', currentStreet)
                                                .eq('species', 'dog')
                                                .asStream();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: textGestureDetector(
                                      "Não alimentados",
                                      focusNode,
                                      () {
                                        setState(
                                          () {
                                            stream = db
                                                .from('animals')
                                                .select()
                                                .eq('wasFed', false)
                                                .asStream();

                                            streamCurrentStreet = db
                                                .from('animals')
                                                .select()
                                                .eq('street', currentStreet)
                                                .eq('wasFed', false)
                                                .asStream();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: textGestureDetector(
                                      "Alimentados",
                                      focusNode,
                                      () {
                                        setState(
                                          () {
                                            stream = db
                                                .from('animals')
                                                .select()
                                                .eq('wasFed', true)
                                                .asStream();

                                            streamCurrentStreet = db
                                                .from('animals')
                                                .select()
                                                .eq('street', currentStreet)
                                                .eq('wasFed', true)
                                                .asStream();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                                      Navigator.of(context)
                                                          .push(
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
                                          fontWeight: FontWeight.w800),
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
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: data
                                              .map(
                                                (animal) => AnimalSizedBox(
                                                  animalName: animal['name'],
                                                  animalImagePath:
                                                      animal['image'],
                                                  species: animal['species'],
                                                  wasFed: animal['wasFed'],
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
            );
          }
        },
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
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              db.storage.from('animals.images').getPublicUrl(
                    animalImagePath,
                  ),
              height: 130,
              width: 115,
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
                          fontSize: 14,
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
                      fontColor: ComponentColors.mainGray,
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

Widget textGestureDetector(
  String labelText,
  FocusNode focusNode,
  void Function()? onPressed,
) {
  return TextButton(
    focusNode: focusNode,
    onPressed: onPressed,
    style: TextButton.styleFrom(
        backgroundColor:
            focusNode.hasFocus ? ComponentColors.sweetBrown : null),
    child: Text(
      labelText,
      style: TextStyles.textStyle(
        fontColor: ComponentColors.mainGray,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
