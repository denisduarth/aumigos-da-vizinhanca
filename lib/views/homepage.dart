// ignore_for_file: avoid_print, use_build_context_synchronously

import '../exports/services.dart';
import '../extensions/build_context_extension.dart';
import '../exports/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final user = db.auth.currentUser;
  final db = Supabase.instance.client;
  final searchControlller = TextEditingController();
  final _locationService = LocationService();

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
                    child: SizedBox(
                      height: 350,
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
              Column(
                children: [
                  Text(_locationService.currentPosition.latitude.toString()),
                  Text(_locationService.currentPosition.longitude.toString()),
                  Text(_locationService.getCurrentAddress)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
