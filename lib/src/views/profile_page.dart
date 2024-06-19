// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, use_build_context_synchronously

import 'package:aumigos_da_vizinhanca/src/enums/images_enum.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/images_enum_extension.dart';
import 'package:aumigos_da_vizinhanca/src/repositories/user_repository.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/animal_details_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/home_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/icon_button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const infoTextStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: ComponentColors.mainGray,
);

class ProfilePage extends StatefulWidget {
  final String? title = 'Perfil';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userRepository = UserRepository();
  final db = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> stream;
  late User? user;

  @override
  void initState() {
    super.initState();
    user = userRepository.getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      try {
        await userRepository.logout();

        context.showErrorSnackbar("Saindo de ${user!.email}");
      } on AuthException catch (error) {
        context.showErrorSnackbar(error.message.toString());
      } catch (error) {
        context.showErrorSnackbar("Um erro aconteceu");
      } finally {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushNamed(context, '/login');
      }
    }

    stream = db.from('animals').select().eq('userId', user!.id).asStream();

    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;
    if (!hasConnection) return const NetworkErrorPage();
    if (!isLocationEnabled) return const LocationErrorPage();

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: user!.userMetadata?['image'] == null
                                  ? Image.asset(
                                      'images/user_image.png',
                                      width: 170,
                                      height: 170,
                                    )
                                  : Image.network(
                                      db.storage.from('images').getPublicUrl(
                                          user!.userMetadata?['image']),
                                      fit: BoxFit.cover,
                                      width: 170,
                                      height: 170,
                                    ),
                            ),
                            IconButtonWidget(
                              icon: Icon(Icons.edit),
                              onPressed: () => Navigator.pushNamed(
                                  context, '/update-profile'),
                              enableBorderSide: true,
                              color: ComponentColors.sweetBrown,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${user!.userMetadata?['name']}  ",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: ComponentColors.mainBlack),
                            ),
                            IconButtonWidget(
                              icon: Icon(Icons.logout_rounded),
                              onPressed: logout,
                              enableBorderSide: false,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              user!.userMetadata?['location']['street'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']['sublocality'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']
                                  ['sub_administrative_area'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']['postal_code'],
                              style: infoTextStyle,
                            ),
                            Text(
                              user!.userMetadata?['location']['country'],
                              style: infoTextStyle,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            IconButtonWidget(
                              icon: Icon(Icons.add),
                              onPressed: () {},
                              enableBorderSide: false,
                              color: ComponentColors.mainYellow,
                            ),
                            Text(
                              "   Seus animais adicionados",
                              style: TextStyles.textStyle(
                                  fontColor: ComponentColors.mainBlack,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.hasError) {
                            return const CircularProgressIndicator();
                          }

                          final data = snapshot.data ?? [];

                          return data.isEmpty
                              ? const Center(
                                  child: Text("Não há animais adicionados"),
                                )
                              : SingleChildScrollView(
                                  child: SizedBox(
                                    height: 230,
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: data
                                          .map(
                                            (animal) => GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimalDetailsPage(
                                                    animalId: animal['id'],
                                                  ),
                                                ),
                                              ),
                                              child: AnimalSizedBox(
                                                animalName: animal['name'],
                                                animalImagePath:
                                                    animal['image'],
                                                species: animal['species'],
                                                wasFed: animal['wasFed'],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Image.asset(
                              ImagesEnum.logoSweetBrown.imageName,
                              width: 50,
                              height: 50,
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  "    Animais perto de: ",
                                  style: TextStyles.textStyle(
                                      fontColor: ComponentColors.mainBlack,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "    ${user!.userMetadata?['location']['street']}",
                                  style: TextStyles.textStyle(
                                      fontColor: ComponentColors.sweetBrown,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.hasError) {
                            return const CircularProgressIndicator();
                          }

                          final data = snapshot.data ?? [];

                          return data.isEmpty
                              ? const Center(
                                  child: Text("Não há animais adicionados"),
                                )
                              : SingleChildScrollView(
                                  child: SizedBox(
                                    height: 230,
                                    child: ListView(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: data
                                          .map(
                                            (animal) => GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimalDetailsPage(
                                                    animalId: animal['id'],
                                                  ),
                                                ),
                                              ),
                                              child: AnimalSizedBox(
                                                animalName: animal['name'],
                                                animalImagePath:
                                                    animal['image'],
                                                species: animal['species'],
                                                wasFed: animal['wasFed'],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
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
