import 'package:aumigos_da_vizinhanca/src/enums/images_enum.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/images_enum_extension.dart';
import 'package:aumigos_da_vizinhanca/src/views/animals/animal_details_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_form.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mixins/validator_mixin.dart';

class SearchAnimalPage extends StatefulWidget {
  final String title = 'Procurar Animais';
  const SearchAnimalPage({super.key});

  @override
  State<SearchAnimalPage> createState() => _SearchAnimalPageState();
}

class _SearchAnimalPageState extends State<SearchAnimalPage>
    with ValidatorMixin {
  final searchController = TextEditingController();
  final db = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> stream;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    stream = db.from('animals').select().order('name').asStream();
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;
    final isLocationEnabled = context.isLocationEnabled;
    if (!hasConnection) return const NetworkErrorPage();
    if (!isLocationEnabled) return const LocationErrorPage();

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refresh,
          color: Colors.white,
          backgroundColor: ComponentColors.sweetBrown,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const CircularProgressIndicator(
                                color: ComponentColors.sweetBrown,
                              );
                            }

                            final data = snapshot.data ?? [];

                            return SizedBox(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: TextForm(
                                      labelText: "Pesquisar animal",
                                      controller: searchController,
                                      icon: const Icon(Icons.search_rounded),
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      validator: isEmpty,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            stream = db
                                                .from('animals')
                                                .select()
                                                .textSearch('name', value)
                                                .asStream();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Text(
                                      data.isNotEmpty
                                          ? "${data.length} resultados encontrados"
                                          : "Nenhum resultado encontrado",
                                      style: TextStyles.textStyle(
                                        fontColor: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                trailing: Image.asset(
                                                  animal['wasFed']
                                                      ? animal['species'] ==
                                                              'dog'
                                                          ? ImagesEnum
                                                              .logoFed.imageName
                                                          : ImagesEnum
                                                              .catFed.imageName
                                                      : animal['species'] ==
                                                              'dog'
                                                          ? ImagesEnum
                                                              .logoNotFed
                                                              .imageName
                                                          : ImagesEnum.catNotFed
                                                              .imageName,
                                                  width: 35,
                                                  height: 35,
                                                ),
                                                subtitle: Text(
                                                  animal['wasFed']
                                                      ? "Alimentado"
                                                      : "Não Alimentado",
                                                  style: TextStyles.textStyle(
                                                    fontColor: animal['wasFed']
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.network(
                                                    db.storage
                                                        .from('animals.images')
                                                        .getPublicUrl(
                                                          animal['image'],
                                                        ),
                                                    fit: BoxFit.cover,
                                                    width: 55,
                                                    height: 55,
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      stream = db.from('animals').select().asStream();
      searchController.clear();
    });
  }
}
