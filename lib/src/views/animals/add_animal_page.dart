// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:aumigos_da_vizinhanca/src/enums/images_enum.dart';
import 'package:aumigos_da_vizinhanca/src/enums/text_align_enums.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/images_enum_extension.dart';
import 'package:aumigos_da_vizinhanca/src/mixins/validator_mixin.dart';
import 'package:aumigos_da_vizinhanca/src/models/animal.dart';
import 'package:aumigos_da_vizinhanca/src/repositories/animal_repository.dart';
import 'package:aumigos_da_vizinhanca/src/services/location_service.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/custom_widget_with_text.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/gradient_text.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/icon_button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_form.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAnimalPage extends StatefulWidget {
  final String title = 'Adicionar Animais';
  const AddAnimalPage({super.key});

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> with ValidatorMixin {
  XFile? image;
  final nameController = TextEditingController();
  final furColorController = TextEditingController();
  final animalRaceController = TextEditingController();
  double animalAge = 5.0;
  String animalSpecies = '';
  bool isAnimalRegistered = false;
  bool wasFed = false;
  bool isFormSaved = false;
  final _locationService = LocationService();

  final List<String> catRaces = [
    'Sphynx',
    'Siamês',
    'Rag Doll',
    'Maine Coon',
    'Persa',
    'Ashera',
    'Pelo Curto Americano',
    'Pelo Curto Britânico',
    'Angora',
    'Bengala',
    'Munchkin',
    'Scottish Fold',
    'Birmanês',
  ];

  final List<String> dogRaces = [
    'Pug',
    'Shih Tzu',
    'Pastor Alemão',
    'Bulldog',
    'Dachshund',
    'Poodle',
    'Rottweiler',
    'Labrador',
    'Pinscher',
    'Golden Retriever',
    'Beagle',
    'Vira-lata',
    'São Bernardo',
    'Terrier',
    'Husky',
    'Dobberman',
    'Lulu da pomerânia',
  ];

  void showUnsavedFormAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.start,
          title: Wrap(
            children: [
              Text(
                "Deseja sair sem salvar?",
                style: TextStyles.textStyle(
                  fontColor: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.save_alt_rounded,
                color: Colors.red,
                size: 40,
              )
            ],
          ),
          content: Wrap(
            children: [
              Text(
                "Alguns campos do formulário não foram totalmente preenchidos, prejudicando o cadastro. Deseja sair sem salvar os dados?",
                style: TextStyles.textStyle(
                  fontColor: ComponentColors.mainGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            IconButtonWidget(
              color: Colors.red,
              enableBorderSide: false,
              onPressed: () => Navigator.of(context).pushNamed('/navigation'),
              icon: const Icon(Icons.navigate_before_rounded),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {});
  }

  @override
  void initState() {
    _locationService.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const radioTextStyle = TextStyle(
      fontFamily: "Poppins",
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Colors.black45,
    );

    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;
    if (!hasConnection) return const NetworkErrorPage();
    if (!isLocationEnabled) return const LocationErrorPage();

    Future<void> registerAnimal() async {
      final db = Supabase.instance.client;
      final animalRepository = AnimalRepository();
      final user = db.auth.currentUser;
      final locationInfo = _locationService.currentAddress.split(',');
      final positionInfo = _locationService.currentPosition;
      final infoData = {
        'street': locationInfo[0],
        'sublocality': locationInfo[1],
        'sub_administrative_area': locationInfo[2],
        'postal_code': locationInfo[3],
        'country': locationInfo[4],
      };
      bool imageExists = false;

      assert(nameController.text.isNotEmpty, "Escreva um nome");
      assert(nameController.text.length <= 20, "Nome muito grande");
      assert(furColorController.text.length <= 15, "Nome de pelo muito grande");
      assert(
        animalRaceController.text.isNotEmpty,
        "Escolha uma raça para o animal",
      );

      try {
        final animal = Animal(
          age: animalAge,
          name: nameController.text.toString(),
          userId: user!.id,
          race: animalRaceController.text,
          species: animalSpecies,
          image: image!.name,
          wasFed: wasFed,
          street: infoData['street']!,
          latitude: positionInfo!.latitude,
          longitude: positionInfo.longitude,
          feederId: user.id,
        );

        final imageExistsList = await db.storage.from('animals.images').list();

        for (FileObject file in imageExistsList) {
          if (file.name == image!.name) {
            imageExists = true;
            break;
          }
        }

        if (!imageExists) {
          await db.storage.from('animals.images').upload(
                image!.name,
                File(
                  image!.path,
                ),
              );
        }

        animalRepository.addAnimal(animal);

        if (mounted) {
          setState(() {
            isAnimalRegistered = true;
            isFormSaved = true;
          });
          context.showSucessSnackbar(
            "Animal cadastrado com sucesso",
          );
        }
      } on StorageException catch (error) {
        context.showErrorSnackbar(error.message.toString());
      } on AssertionError catch (error) {
        context.showErrorSnackbar(error.message.toString());
      } finally {
        Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, '/navigation');
      }
    }

    return Scaffold(
      body: PopScope(
        canPop: isFormSaved,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          showUnsavedFormAlert();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: context.screenHeight + 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 50),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/aumigos_da_vizinhanca_cat_sweet_brown.png',
                          width: 70,
                          height: 70,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: GradientText(
                            text: "Adicionar um animal",
                            textSize: 28,
                            textAlign: TextAlignEnum.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 50.0),
                          child: Text(
                            "Adicione os dados do animal que deseja adicionar no aplicativo",
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 60,
                          backgroundImage: image == null
                              ? const AssetImage('images/animal_image.png')
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
                  ),
                  TextForm(
                    labelText: "Nome do animal",
                    controller: nameController,
                    icon: const Icon(Icons.abc_rounded),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    validator: isEmpty,
                    topText: "Nome do animal",
                  ),
                  CustomWidgetWithText(
                    topText: "Idade do animal (em anos)",
                    customWidget: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          animalAgeButton(
                            onTap: animalAge > 0.0
                                ? () => setState(
                                      () {
                                        animalAge--;
                                      },
                                    )
                                : null,
                            data: "-",
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            "${animalAge.round().toString()}  anos",
                            style: TextStyles.textStyle(
                              fontColor: ComponentColors.mainBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          animalAgeButton(
                            onTap: animalAge < 30.0
                                ? () => setState(
                                      () {
                                        animalAge++;
                                      },
                                    )
                                : null,
                            data: "+",
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextForm(
                    labelText: "Cor do Pelo",
                    controller: furColorController,
                    icon: const Icon(Icons.abc_rounded),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    validator: isEmpty,
                    topText: "Cor do Pelo (Opcional)",
                  ),
                  CustomWidgetWithText(
                    topText: "Espécie do Animal",
                    customWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RadioListTile<String>(
                          activeColor: ComponentColors.mainYellow,
                          title: const Text(
                            "Gato",
                            style: radioTextStyle,
                          ),
                          value: 'cat',
                          groupValue: animalSpecies.toLowerCase(),
                          onChanged: (value) {
                            setState(() {
                              animalSpecies = value!;
                              animalRaceController.text = catRaces[0];
                            });
                          },
                        ),
                        RadioListTile<String>(
                          activeColor: ComponentColors.mainYellow,
                          title: const Text(
                            "Cachorro",
                            style: radioTextStyle,
                          ),
                          value: 'dog',
                          groupValue: animalSpecies.toLowerCase(),
                          onChanged: (value) {
                            setState(() {
                              animalSpecies = value!;
                              animalRaceController.text = dogRaces[0];
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  CustomWidgetWithText(
                    topText: "Raça do animal",
                    customWidget: DropdownMenu<String>(
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      leadingIcon: const Icon(
                        Icons.data_object_rounded,
                        color: ComponentColors.mainYellow,
                      ),
                      width: context.screenWidth - 60,
                      controller: animalRaceController,
                      textStyle: radioTextStyle,
                      hintText: animalSpecies == ''
                          ? 'Selecione uma espécie'
                          : animalRaceController.text,
                      dropdownMenuEntries: animalSpecies == ''
                          ? []
                          : animalSpecies == 'dog'
                              ? dogRaces
                                  .map(
                                    (race) => DropdownMenuEntry<String>(
                                      leadingIcon: Image.asset(
                                        'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      value: race,
                                      label: race,
                                    ),
                                  )
                                  .toList()
                              : catRaces
                                  .map(
                                    (race) => DropdownMenuEntry<String>(
                                      leadingIcon: Image.asset(
                                        'images/aumigos_da_vizinhanca_cat_sweet_brown.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      value: race,
                                      label: race,
                                    ),
                                  )
                                  .toList(),
                    ),
                  ),
                  CustomWidgetWithText(
                    topText: "Foi alimentado hoje?",
                    customWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RadioListTile<bool>(
                          activeColor: ComponentColors.mainYellow,
                          title: const Text(
                            "Sim",
                            style: radioTextStyle,
                          ),
                          value: true,
                          groupValue: wasFed,
                          onChanged: (value) {
                            setState(() {
                              wasFed = value!;
                            });
                          },
                        ),
                        RadioListTile<bool>(
                          activeColor: ComponentColors.mainYellow,
                          title: const Text(
                            "Não",
                            style: radioTextStyle,
                          ),
                          value: false,
                          groupValue: wasFed,
                          onChanged: (value) {
                            setState(() {
                              wasFed = value!;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Button(
                    buttonIcon: Image.asset(
                      ImagesEnum.logoWhite.imageName,
                      width: 20,
                      height: 20,
                    ),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              height: (context.screenHeight / 2) + 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  100,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'images/aumigos_da_vizinhanca_cat_sweet_brown.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        Text(
                                          "   Confirmação de cadastro",
                                          style: TextStyles
                                              .textStyleWithComponentColor(
                                            stringColor: 'sweet_brown',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Wrap(
                                        clipBehavior: Clip.hardEdge,
                                        children: [
                                          Text(
                                            "Você deseja fazer o cadastro deste animal levando em consideração a sua localização atual? Fazendo isto, este animal estará vinculado à este endereço (esta rua, em espcífico), e não poderá ser alterado. Deseja prosseguir?",
                                            style: TextStyles.textStyle(
                                              fontColor:
                                                  ComponentColors.mainGray,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                              width: 1.5,
                                              color: Colors.red,
                                              strokeAlign: 0,
                                            )),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.warning_amber_rounded,
                                              color: Colors.red,
                                            ),
                                            label: Text(
                                              "Não prosseguir",
                                              style: TextStyles.textStyle(
                                                  fontColor: Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                              width: 1.5,
                                              color: Colors.green,
                                              strokeAlign: 0,
                                            )),
                                            onPressed: registerAnimal,
                                            icon: const Icon(
                                              Icons.verified_outlined,
                                              color: Colors.green,
                                            ),
                                            label: Text(
                                              "Prosseguir",
                                              style: TextStyles.textStyle(
                                                fontColor: Colors.green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    buttonWidget: isAnimalRegistered
                        ? const Text(
                            "Animal registrado",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Registrar animal",
                            style: TextStyle(
                              color: Colors.white,
                            ),
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

Widget animalAgeButton({
  required void Function()? onTap,
  required String data,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: AlignmentDirectional.center,
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: ComponentColors.sweetBrown,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Text(
        data,
        style: const TextStyle(fontSize: 30, color: Colors.white),
      ),
    ),
  );
}
