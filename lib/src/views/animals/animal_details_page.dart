// ignore_for_file: use_build_context_synchronously

import 'package:aumigos_da_vizinhanca/src/enums/images_enum.dart';
import 'package:aumigos_da_vizinhanca/src/enums/text_align_enums.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/images_enum_extension.dart';
import 'package:aumigos_da_vizinhanca/src/services/location_service.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/gradient_text.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnimalDetailsPage extends StatefulWidget {
  final String animalId;
  const AnimalDetailsPage({required this.animalId, super.key});

  @override
  State<AnimalDetailsPage> createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage> {
  final db = Supabase.instance.client;
  late User? user = db.auth.currentUser;
  final _locationService = LocationService();
  late Future<Map<String, dynamic>> currentAnimal;
  late Future<Map<String, dynamic>> currentFeeder;
  final NumberFormat formatter = NumberFormat("00");

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

    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;
    if (!hasConnection) return const NetworkErrorPage();
    if (!isLocationEnabled) return const LocationErrorPage();

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: context.screenHeight,
              child: FutureBuilder(
                future: currentAnimal,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data as Map<String, dynamic>;
                  currentFeeder = db
                      .from('users')
                      .select()
                      .match({'id': data['feederId']})
                      .limit(1)
                      .single();

                  var feedingDateData = {
                    'year': DateTime.tryParse(data['lastFeedingDate'])?.year,
                    'month': DateTime.tryParse(data['lastFeedingDate'])?.month,
                    'day': DateTime.tryParse(data['lastFeedingDate'])?.day,
                    'hour': DateTime.tryParse(data['lastFeedingDate'])?.hour,
                    'minute':
                        DateTime.tryParse(data['lastFeedingDate'])?.minute,
                  };

                  var datesInFull = {
                    1: "jan",
                    2: "fev",
                    3: "mar",
                    4: "abr",
                    5: "maio",
                    6: "jun",
                    7: "jul",
                    8: "ago",
                    9: "set",
                    10: "out",
                    11: "nov",
                    12: "dez",
                  };

                  String feedingDataFormatted =
                      "${formatter.format(feedingDateData['day'])} ${datesInFull[feedingDateData['month']]}. às ${formatter.format(feedingDateData['hour'])}:${formatter.format(feedingDateData['minute'])}";

                  return FutureBuilder(
                      future: currentFeeder,
                      builder: (context, snapshot) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final feederData = snapshot.data ?? {};

                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.network(
                                  db.storage
                                      .from('animals.images')
                                      .getPublicUrl(
                                        data['image'],
                                      ),
                                  fit: BoxFit.cover,
                                  height: 300,
                                  width: 300,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                bottom: 15.0,
                                top: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyles
                                            .textStyleWithComponentColor(
                                          stringColor: 'main_black',
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      data['wasFed'] != true
                                          ? OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: Colors.green,
                                                  width: 2,
                                                ),
                                                foregroundColor: Colors.green,
                                                textStyle: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              onPressed: () async {
                                                try {
                                                  await db
                                                      .from('animals')
                                                      .update({
                                                    'wasFed': true,
                                                    'lastFeedingDate':
                                                        DateTime.now()
                                                            .toIso8601String()
                                                            .toString(),
                                                    'feederId': user!.id
                                                  }).eq('id', data['id']);

                                                  context.showSucessSnackbar(
                                                      "Animal alimentado com sucesso");
                                                } on StorageException catch (error) {
                                                  context.showErrorSnackbar(
                                                      error.message.toString());
                                                } catch (error) {
                                                  context.showErrorSnackbar(
                                                      error.toString());
                                                } finally {
                                                  setState(() {});

                                                  Future.delayed(const Duration(
                                                      seconds: 2));
                                                  Navigator.pushNamed(
                                                      context, '/navigation');
                                                }
                                              },
                                              child: const Text("Alimentar"),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: SizedBox(
                                      height: 175,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                data['species'] == 'cat'
                                                    ? ImagesEnum
                                                        .catMainYellow.imageName
                                                    : ImagesEnum.logoSweetBrown
                                                        .imageName,
                                                width: 40,
                                                height: 40,
                                              ),
                                              Text(
                                                data['species'] == 'cat'
                                                    ? " Gato"
                                                    : " Cachorro",
                                                style: TextStyles.textStyle(
                                                  fontColor:
                                                      data['species'] == 'cat'
                                                          ? ComponentColors
                                                              .mainYellow
                                                          : ComponentColors
                                                              .sweetBrown,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 40,
                                                color:
                                                    ComponentColors.sweetBrown,
                                              ),
                                              Text(
                                                "   Vive em ",
                                                style: TextStyles.textStyle(
                                                  fontColor:
                                                      ComponentColors.mainBlack,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                " ${data['street']}",
                                                style: TextStyles.textStyle(
                                                  fontColor: ComponentColors
                                                      .sweetBrown,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                data['wasFed']
                                                    ? ImagesEnum.fed.imageName
                                                    : ImagesEnum
                                                        .notFed.imageName,
                                                width: 40,
                                                height: 40,
                                              ),
                                              Wrap(
                                                direction: Axis.vertical,
                                                children: [
                                                  data['wasFed'] &&
                                                          data['lastFeedingDate'] !=
                                                              {}
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              "   Alimentado(a) em ",
                                                              style: TextStyles.textStyle(
                                                                  fontColor:
                                                                      ComponentColors
                                                                          .mainBlack,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              // textAlign: TextAlign.start,
                                                            ),
                                                            Text(
                                                              " $feedingDataFormatted",
                                                              style: TextStyles.textStyle(
                                                                  fontColor: data[
                                                                          'wasFed']
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                              // textAlign: TextAlign.start,
                                                            )
                                                          ],
                                                        )
                                                      : Text(
                                                          "   Não alimentado",
                                                          style: TextStyles
                                                              .textStyle(
                                                                  fontColor:
                                                                      Colors
                                                                          .red,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                          // textAlign: TextAlign.start,
                                                        )
                                                ],
                                              )
                                            ],
                                          ),
                                          data['wasFed']
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: ClipOval(
                                                        child: user == null
                                                            ? Image.asset(
                                                                'images/user_image.png')
                                                            : Image.network(
                                                                db.storage
                                                                    .from(
                                                                        'images')
                                                                    .getPublicUrl(
                                                                        feederData[
                                                                            'image']),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "   Alimentado(a) por ",
                                                          style: TextStyles
                                                              .textStyle(
                                                            fontColor:
                                                                ComponentColors
                                                                    .mainBlack,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        GradientText(
                                                            text:
                                                                "${feederData['name']}",
                                                            textSize: 16.5,
                                                            textAlign:
                                                                TextAlignEnum
                                                                    .start),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
