// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/services/location_service.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/gradient_text.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/icon_button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../enums/text_align_enums.dart';
import '../mixins/validator_mixin.dart';

class MoreInfoPage extends StatefulWidget {
  const MoreInfoPage({super.key});

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> with ValidatorMixin {
  final formKey = GlobalKey<FormState>();
  XFile? image;
  final db = Supabase.instance.client;
  final _locationService = LocationService();
  final _passwordController = TextEditingController();
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await _locationService.getCurrentLocation();
    setState(
      () {},
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future uploadImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;

    if (!hasConnection) return const NetworkErrorPage();
    if (!isLocationEnabled) return const LocationErrorPage();

    // Variável para pegar os dados enviados da tela anterior para finalização do cadastro
    final args = context.getPreviousRouteArguments as Map;
    // Variáveis de controle da tela anterior para fechar os dados para o cadastro do usuário
    final userName = args['name'];
    final userEmail = args['email'];
    final userPassword = args['password'];
    final locationInfo = _locationService.currentAddress.split(',');
    final positionInfo = _locationService.currentPosition;
    final infoData = {
      'street': locationInfo[0],
      'sublocality': locationInfo[1],
      'sub_administrative_area': locationInfo[2],
      'postal_code': locationInfo[3],
      'country': locationInfo[4],
    };

    Future<void> register() async {
      try {
        if (image != null) {
          await db.storage.from('images').upload(
                image!.name,
                File(image!.path),
                fileOptions: const FileOptions(
                  upsert: true,
                ),
              );
        }

        await db.auth.signUp(
          email: userEmail,
          password: userPassword,
          data: {
            'name': userName,
            'location': {
              'street': infoData['street'],
              'sublocality': infoData['sublocality'],
              'sub_administrative_area': infoData['sub_administrative_area'],
              'postal_code': infoData['postal_code'],
              'country': infoData['country'],
              'latitude': positionInfo!.latitude,
              'longitude': positionInfo.longitude
            },
            'image': image?.name ?? ''
          },
        );

        if (mounted) {
          setState(() {
            isRegistered = true;
          });
          context.showSucessSnackbar("Cadastro feito com sucesso");
        }
      } on AssertionError catch (error) {
        context.showErrorSnackbar(error.message.toString());
      } on AuthException catch (error) {
        context.showErrorSnackbar(error.message.toString());
      } on StorageException catch (error) {
        context.showErrorSnackbar(error.message.toString());
      } finally {
        Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, '/login');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButtonWidget(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              onPressed: () {
                                args.clear();
                                Navigator.pop(context);
                              },
                              enableBorderSide: false,
                              color: ComponentColors.mainYellow,
                            ),
                            Image.asset(
                              'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                              width: 60,
                              height: 60,
                            ),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              child: GradientText(
                                text: "Finalizando cadastro",
                                textSize: 28,
                                textAlign: TextAlignEnum.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 50),
                              child: Text(
                                "Finalize seu cadastro verificando se os dados de localização estão corretos",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: ComponentColors.mainGray,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage: image == null
                            ? const AssetImage('images/user_image.png')
                                as ImageProvider
                            : FileImage(File(image!.path)),
                      ),
                      IconButtonWidget(
                        color: ComponentColors.sweetBrown,
                        enableBorderSide: true,
                        onPressed: uploadImage,
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 50),
                    height: 250,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: ComponentColors.sweetBrown,
                                  size: 30,
                                ),
                                GradientText(
                                  text: " Dados de localização",
                                  textSize: 17,
                                  textAlign: TextAlignEnum.center,
                                ),
                              ],
                            ),
                          ),
                          decoratedText(
                              'Rua: ${locationInfo[0]}', Icons.location_on),
                          decoratedText(
                              'Bairro: ${locationInfo[1]}', Icons.location_on),
                          decoratedText(
                              'Cidade: ${locationInfo[2]}', Icons.location_on),
                          decoratedText(
                              'CEP: ${locationInfo[3]}', Icons.location_on),
                          decoratedText(
                              'País: ${locationInfo[4]}', Icons.location_on),
                          decoratedText('Latitude: ${positionInfo!.latitude}',
                              Icons.location_on),
                          decoratedText('Longitude: ${positionInfo.longitude}',
                              Icons.location_on),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 50),
                    height: 100,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.data_object_rounded,
                                  color: ComponentColors.sweetBrown,
                                  size: 30,
                                ),
                                GradientText(
                                  text: "  Dados anteriores",
                                  textSize: 17,
                                  textAlign: TextAlignEnum.center,
                                ),
                              ],
                            ),
                          ),
                          Wrap(direction: Axis.vertical, children: [
                            decoratedText('E-mail: $userEmail',
                                Icons.data_object_rounded),
                          ]),
                          decoratedText(
                              'Nome: $userName', Icons.data_object_rounded),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextForm(
                      labelText: "Digite novamente a senha",
                      controller: _passwordController,
                      icon: const Icon(Icons.lock_rounded),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: isEmpty,
                      topText: "Senha para confirmação de dados",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                    child: Button(
                      buttonIcon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                      ),
                      onTap: register,
                      buttonWidget: isRegistered
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Dados estão corretos",
                              style: buttonTextStyle,
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget decoratedText(String data, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: ComponentColors.sweetBrown,
          size: 18,
        ),
        Text(
          '  $data',
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ComponentColors.mainBlack,
          ),
        ),
      ],
    );
  }
}
