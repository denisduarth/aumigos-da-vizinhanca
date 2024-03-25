import 'package:aumigos_da_vizinhanca/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../exports/services.dart';
import '../../widgets/text_styles.dart';

class AnimalDetailsPage extends StatefulWidget {
  final String animalId;
  const AnimalDetailsPage({required this.animalId, super.key});

  @override
  State<AnimalDetailsPage> createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage> {
  final db = Supabase.instance.client;
  late Future<Map<String, dynamic>> currentAnimal;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _locationService.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    currentAnimal = db
        .from('animals')
        .select()
        .match({'id': widget.animalId})
        .limit(1)
        .single();

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: 1200,
              child: FutureBuilder(
                future: currentAnimal,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data as Map<String, dynamic>;

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Image.network(
                        db.storage.from('animals.images').getPublicUrl(
                              data['image'],
                            ),
                        height: 350,
                        width: context.screenWidth,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'],
                              style: TextStyles.textStyleWithComponentColor(
                                stringColor: 'main_black',
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        data['species'] == 'cat'
                                            ? 'images/aumigos_da_vizinhanca_cat_main_yellow.png'
                                            : 'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      Text(
                                        data['species'] == 'cat'
                                            ? " Gato"
                                            : " Cachorro",
                                        style: TextStyles.textStyle(
                                          fontColor: data['species'] == 'cat'
                                              ? ComponentColors.mainYellow
                                              : ComponentColors.sweetBrown,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        data['wasFed']
                                            ? 'images/aumigos_da_vizinhanca_fed.png'
                                            : 'images/aumigos_da_vizinhanca_not_fed.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      Text(
                                        data['wasFed']
                                            ? "   Alimentado"
                                            : "   Não alimentado",
                                        style: TextStyles.textStyle(
                                            fontColor: data['wasFed']
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        width: 250,
                        height: 350,
                        child: data['latitude'] == null ||
                                data['longitude'] == null
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(
                                    data['latitude'],
                                    data['longitude'],
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
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
