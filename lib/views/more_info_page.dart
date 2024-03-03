// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'package:aumigos_da_vizinhanca/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../enums/text_align_enums.dart';
import '../views/all.dart';
import '../widgets/all.dart';

class MoreInfoPage extends StatefulWidget {
  const MoreInfoPage({super.key});

  @override
  State<MoreInfoPage> createState() => _MoreInfoPageState();
}

class _MoreInfoPageState extends State<MoreInfoPage> {
  final formKey = GlobalKey<FormState>();
  XFile? image;
  final db = Supabase.instance.client;

  /*
    Informações do usuário relacionado a seu endereço, como rua, estado, cidade, bairro etc.
    Essa informações serão levadas adiante no cadastro do usuário e serão usadas como referencial
    para mostrar para o usuário quantos cachorros ou gatos existem em sua rua, bem como os status de
    alimentação, hidratação e se possuem alguma zoonose ou outra doença.
  */

  final streetController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final countryController = TextEditingController();
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    streetController.dispose();
    cityController.dispose();
    districtController.dispose();
    stateController.dispose();
    countryController.dispose();
  }

  Future uploadImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;

    // Variável para pegar os dados enviados da tela anterior para finalização do cadastro
    final args = context.getPreviousRouteArguments as Map<String, dynamic>;

    // Variáveis de controle da tela anterior para fechar os dados para o cadastro do usuário
    final userName = args['name'];
    final userEmail = args['email'];
    final userPassword = args['password'];

    void snackBar(String message, Color color) {
      SnackBarHelper.showSnackBar(
        context,
        message,
        color,
        Icons.error_outline_rounded,
        false,
      );
    }

    Future register() async {
      try {
        assert(streetController.text.isNotEmpty, "Digite uma rua");
        assert(districtController.text.isNotEmpty, "Digite um bairro");
        assert(cityController.text.isNotEmpty, "Digite uma cidade");
        assert(stateController.text.isNotEmpty, "Digite um estado");
        assert(countryController.text.isNotEmpty, "Digite um país");

        await db.storage.from('images').upload(image!.name, File(image!.path));

        await db.auth.signUp(
          email: userEmail,
          password: userPassword,
          data: {
            'name': userName,
            'image': image!.name,
            'street': streetController.text,
            'district': districtController.text,
            'city': cityController.text,
            'state': stateController.text,
            'country': countryController.text
          },
        );

        if (mounted) {
          setState(() {
            isRegistered = true;
          });

          snackBar("Cadastro feito com sucesso", Colors.green);

          Future.delayed(const Duration(seconds: 3));
          Navigator.pushNamed(context, '/login');
        }
      } on AssertionError catch (error) {
        snackBar(error.message.toString(), Colors.red);
      } on AuthException catch (error) {
        snackBar(error.message.toString(), Colors.red);
      }
    }

    if (!hasConnection) return const NetworkErrorPage();

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
                                "Finalize seu cadastro colocando os dados faltantes referentes a seu endereço",
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
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    height: 450,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextForm(
                            labelText: "Nome da sua rua",
                            controller: streetController,
                            icon: const Icon(Icons.location_pin),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Rua desconhecida";
                              }
                              return null;
                            },
                            hintText: "Ex: Rua blá blá blá"),
                        TextForm(
                          labelText: "Nome do seu bairro",
                          controller: districtController,
                          icon: const Icon(Icons.location_pin),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Digite um nome";
                            }
                            return null;
                          },
                          hintText: "Ex: Patati Patatá",
                        ),
                        TextForm(
                          labelText: "Nome da sua cidade",
                          controller: cityController,
                          icon: const Icon(Icons.location_pin),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Cidade inválida";
                            }
                            return null;
                          },
                          hintText: "Ex: São José dos Campos",
                        ),
                        TextForm(
                            labelText: "Nome do seu estado",
                            controller: stateController,
                            icon: const Icon(Icons.location_pin),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Estado inválido";
                              }
                              return null;
                            },
                            hintText: "Ex: Paraná"),
                        TextForm(
                            labelText: "Nome do seu país",
                            controller: countryController,
                            icon: const Icon(Icons.location_pin),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "País inválido";
                              }
                              return null;
                            },
                            hintText: "Ex: Brasil"),
                        Button(
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
                                  "Criar conta",
                                  style: buttonTextStyle,
                                ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
