import '../../exports/extensions.dart';
import '../../exports/enums.dart';
import '../../exports/widgets.dart';
import '../../exports/views.dart';
import '../../mixins/validator_mixin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  Widget build(BuildContext context) {
    stream = db.from('animals').select().order('name').asStream();

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
                            onFieldSubmitted: (value) => setState(
                              () {
                                stream = db
                                    .from('animals')
                                    .select()
                                    .textSearch('name', value)
                                    .asStream();
                              },
                            ),
                          ),
                        ),
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
