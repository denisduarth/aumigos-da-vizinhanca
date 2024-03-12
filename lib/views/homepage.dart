import 'package:aumigos_da_vizinhanca/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/all.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final user = db.auth.currentUser;
  final db = Supabase.instance.client;
  final searchControlller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchControlller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      floatingActionButton: PopupMenuButton<void>(
        surfaceTintColor: ComponentColors.sweetBrown,
        icon: const Icon(Icons.menu_rounded),
        iconColor: Colors.white,
        itemBuilder: (context) => [
          PopupMenuItem<void>(
            padding: const EdgeInsets.all(8),
            onTap: () => Navigator.of(context).pushNamed('/add-animal'),
            child: const Row(
              children: [
                Icon(Icons.add_rounded),
                Text(
                  "Adicionar animais",
                ),
              ],
            ),
          ),
          PopupMenuItem<void>(
            padding: const EdgeInsets.all(8),
            onTap: () => Navigator.of(context).pushNamed('/search-animal'),
            child: const Row(
              children: [
                Icon(Icons.search_rounded),
                Text(
                  "Pesquisar animais",
                ),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              SizedBox(
                height: context.screenHeight,
                width: context.screenWidth,
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(-20.8202, -49.37970),
                    initialZoom: 9.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.aumigos_da_vizinhanca',
                    ),
                    Container(
                      alignment: AlignmentDirectional.topCenter,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10),
                      child: TextForm(
                        labelText: "Procurar",
                        controller: searchControlller,
                        icon: const Icon(Icons.search_rounded),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return "Pesquisa inválida";
                          return null;
                        },
                        topText: "Endereço",
                      ),
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
          ),
        ),
      ),
    );
  }
}

// OSMFlutter(
//   controller: controller,
//   osmOption: OSMOption(
//     userTrackingOption: const UserTrackingOption(
//       enableTracking: true,
//       unFollowUser: false,
//     ),
//     zoomOption: const ZoomOption(
//       initZoom: 8,
//       minZoomLevel: 3,
//       maxZoomLevel: 19,
//       stepZoom: 1.0,
//     ),
//     userLocationMarker: UserLocationMaker(
//       personMarker: const MarkerIcon(
//         icon: Icon(
//           Icons.location_history_rounded,
//           color: Colors.red,
//           size: 48,
//         ),
//       ),
//       directionArrowMarker: const MarkerIcon(
//         icon: Icon(
//           Icons.double_arrow,
//           size: 48,
//         ),
//       ),
//     ),
//   ),
// ),