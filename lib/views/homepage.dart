import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/text_form.dart';
import 'all.dart';

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
    final hasConnection = ConnectionNotifier.of(context).value;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                        hintText: "endereço a procurar",
                        controller: searchControlller,
                        icon: const Icon(Icons.search_rounded),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) return "Pesquisa inválida";
                          return null;
                        },
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