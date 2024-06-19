import 'package:aumigos_da_vizinhanca/src/enums/images_enum.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/images_enum_extension.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/animal_details_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotFedAnimalsPage extends StatefulWidget {
  const NotFedAnimalsPage({super.key});

  @override
  State<NotFedAnimalsPage> createState() => _NotFedAnimalsState();
}

class _NotFedAnimalsState extends State<NotFedAnimalsPage> {
  final db = Supabase.instance.client;
  late final user = db.auth.currentUser;
  late Future<List<Map<String, dynamic>>> notFedAnimalsFuture;

  @override
  Widget build(BuildContext context) {
    notFedAnimalsFuture =
        db.from('animals').select().eq('wasFed', false).eq('userId', user!.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagesEnum.logoSweetBrown.imageName,
                          width: 120,
                          height: 120,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text(
                              "Bem-vindo de volta, ",
                              style: TextStyles.textStyle(
                                fontColor: ComponentColors.mainBlack,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${user!.userMetadata?['name']}",
                              style: TextStyles.textStyle(
                                fontColor: ComponentColors.sweetBrown,
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: FutureBuilder(
                        future: notFedAnimalsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final data =
                              snapshot.data as List<Map<String, dynamic>>;

                          return SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        "Estes são alguns dos animais que você adicionou que estão precisando se alimentar. Lembre-se sempre de alimentá-los no horário certo",
                                        style: TextStyles.textStyle(
                                          fontColor: ComponentColors.mainGray,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: ComponentColors.sweetBrown,
                                        width: 2,
                                      ),
                                      foregroundColor:
                                          ComponentColors.sweetBrown,
                                      textStyle: const TextStyle(
                                        color: ComponentColors.sweetBrown,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    child: const Text("Entendi"),
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/navigation'),
                                  ),
                                ),
                                ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: data
                                      .map(
                                        (animal) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AnimalDetailsPage(
                                                  animalId: animal['id'],
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                animal['name'],
                                                style: TextStyles
                                                    .textStyleWithComponentColor(
                                                  stringColor: 'main_black',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              trailing: Image.asset(
                                                animal['species'] == 'dog'
                                                    ? ImagesEnum
                                                        .logoNotFed.imageName
                                                    : ImagesEnum
                                                        .catNotFed.imageName,
                                                width: 50,
                                                height: 50,
                                              ),
                                              subtitle: Text(
                                                "Não Alimentado",
                                                style: TextStyles.textStyle(
                                                  fontColor: Colors.red,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  db.storage
                                                      .from('animals.images')
                                                      .getPublicUrl(
                                                        animal['image'],
                                                      ),
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
