import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final user = db.auth.currentUser;
  final db = Supabase.instance.client;
  final searchControlller = TextEditingController();
  MapController controller = MapController(
      // initPosition: GeoPoint(latitude: -20.8202, longitude: -49.37970),
      initMapWithUserPosition: const UserTrackingOption(enableTracking: true));

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    searchControlller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(eccentricity: 1),
        backgroundColor: ComponentColors.sweetBrown,
        onPressed: () => {},
        child: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextForm(
                            labelText: "Procurar",
                            hintText: "endereço a procurar",
                            controller: searchControlller,
                            icon: const Icon(Icons.search_rounded),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) return "Pesquisa inválida";
                              return null;
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Bem-vindo, ",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: ComponentColors.mainBlack,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              GradientText(text: "${user?.email}", textSize: 20)
                            ],
                          ),
                        ),
                      ]),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      height: 275,
                      width: 275,
                      child: OSMFlutter(
                        controller: controller,
                        osmOption: OSMOption(
                          userTrackingOption: const UserTrackingOption(
                            enableTracking: true,
                            unFollowUser: false,
                          ),
                          zoomOption: const ZoomOption(
                            initZoom: 8,
                            minZoomLevel: 3,
                            maxZoomLevel: 19,
                            stepZoom: 1.0,
                          ),
                          userLocationMarker: UserLocationMaker(
                            personMarker: const MarkerIcon(
                              icon: Icon(
                                Icons.location_history_rounded,
                                color: Colors.red,
                                size: 48,
                              ),
                            ),
                            directionArrowMarker: const MarkerIcon(
                              icon: Icon(
                                Icons.double_arrow,
                                size: 48,
                              ),
                            ),
                          ),
                          roadConfiguration: const RoadOption(
                              roadColor: Colors.yellowAccent, roadWidth: 10),
                          markerOption: MarkerOption(
                            defaultMarker: const MarkerIcon(
                              icon: Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                                size: 56,
                              ),
                            ),
                          ),
                        ),
                      ),
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
