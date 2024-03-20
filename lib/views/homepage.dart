// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:aumigos_da_vizinhanca/enums/text_align_enums.dart';
import 'package:aumigos_da_vizinhanca/exports/widgets.dart';
import 'package:aumigos_da_vizinhanca/mixins/validator_mixin.dart';
import '../exports/services.dart';
import '../extensions/build_context_extension.dart';
import '../exports/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repositories/animal_repository.dart';
import '../widgets/text_styles.dart';

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

  @override
  void dispose() {
    super.dispose();
    searchControlller.dispose();
  }

  _getCurrentLocation() async {
    await _locationService.getCurrentLocation();
    setState(
      () {},
    );
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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    stream = animalRepository.getAnimalsByUserId(user!.id);
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;

    if (!hasConnection) return const NetworkErrorPage();

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
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                              user!.userMetadata?['location']['latitude'],
                              user!.userMetadata?['location']['longitude']),
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
                  TextForm(
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Bem-vindo, ",
                              style: TextStyles.textStyle(
                                fontColor: ComponentColors.mainBlack,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            GradientText(
                                text: "${user!.userMetadata?['name']}",
                                textSize: 28,
                                textAlign: TextAlignEnum.start),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
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
                                fontColor: ComponentColors.sweetBrown,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      )),
                  StreamBuilder(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return const CircularProgressIndicator();
                      }

                      final data = snapshot.data ?? [];

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: SizedBox(
                            width: context.screenWidth,
                            height: 300,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: data
                                  .map(
                                    (animal) => SizedBox(
                                      height: 200,
                                      width: 135,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              db.storage
                                                  .from('animals.images')
                                                  .getPublicUrl(
                                                    animal['image'],
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        animal['name'],
                                                        style: TextStyles
                                                            .textStyle(
                                                          fontColor:
                                                              Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    animal['id'],
                                                    style: TextStyles.textStyle(
                                                      fontColor: ComponentColors
                                                          .mainGray,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    animal['wasFed']
                                                        ? "Alimentado"
                                                        : "Não alimentado",
                                                    style: TextStyles.textStyle(
                                                        fontColor:
                                                            animal['wasFed']
                                                                ? Colors.green
                                                                : Colors.red,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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
}
