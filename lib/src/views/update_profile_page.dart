// ignore_for_file: prefer_const_constructors, file_names, use_build_context_synchronously

import 'dart:io';
import 'package:aumigos_da_vizinhanca/src/enums/text_align_enums.dart';
import 'package:aumigos_da_vizinhanca/src/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/src/views/location_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/views/network_error_page.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/appbar.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/gradient_text.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/icon_button.dart';
import 'package:aumigos_da_vizinhanca/src/widgets/text_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../mixins/validator_mixin.dart';

class UpdateProfilePage extends StatefulWidget {
  final String title = "Editar dados do usuário";
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage>
    with ValidatorMixin {
  late final SupabaseClient db;
  late final User? user;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool isPasswordVisible = true;
  bool isInfoUpdated = false;
  XFile? image;

  @override
  void initState() {
    db = Supabase.instance.client;
    user = db.auth.currentUser;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> updateUserInfo() async {
    try {
      await db.auth.updateUser(
        UserAttributes(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
          data: {'name': nameController.text.toString(), 'image': image!.name},
        ),
      );

      if (mounted) {
        setState(() {
          isInfoUpdated = true;
        });
        context.showSucessSnackbar('Dados atualizados com sucesso');
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushNamed(context, '/profile');
      }
    } on AuthException catch (error) {
      context.showErrorSnackbar(error.message.toString());
    }
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

    return Scaffold(
      appBar: AppBarWidget.showAppBar(context, widget.title),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.screenHeight + 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButtonWidget(
                              icon: Icon(Icons.arrow_back_ios_new_rounded),
                              onPressed: () => Navigator.of(context).pop(),
                              enableBorderSide: false,
                              color: ComponentColors.mainYellow,
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: user!.userMetadata?['image'] == null
                                      ? Image.asset(
                                          'images/user_image.png',
                                          width: 110,
                                          height: 110,
                                        )
                                      : image == null
                                          ? Image.network(
                                              db.storage
                                                  .from('images')
                                                  .getPublicUrl(user!
                                                      .userMetadata?['image']),
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 100,
                                              backgroundImage: FileImage(
                                                File(
                                                  image!.path,
                                                ),
                                              ),
                                            ),
                                ),
                                IconButtonWidget(
                                  icon: Icon(Icons.photo),
                                  onPressed: uploadImage,
                                  enableBorderSide: true,
                                  color: ComponentColors.sweetBrown,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          widthFactor: 30,
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            direction: Axis.horizontal,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10.0),
                                child: GradientText(
                                  text: "Editar dados do usuário",
                                  textSize: 28,
                                  textAlign: TextAlignEnum.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Edite os dados da sua conta",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: ComponentColors.lightGray,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 550,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextForm(
                          labelText: "Seu novo e-mail",
                          controller: emailController,
                          icon: Icon(Icons.email_rounded),
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => combine([
                            () => isEmpty(value),
                            () => emailValidator(value),
                          ]),
                          topText: "Novo e-mail",
                        ),
                        TextForm(
                          labelText: "Seu novo nome",
                          controller: nameController,
                          icon: Icon(Icons.data_object_rounded),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: isEmpty,
                          topText: "Novo nome",
                        ),
                        TextForm(
                          labelText: "Seu nova senha",
                          controller: passwordController,
                          icon: Icon(Icons.lock_rounded),
                          obscureText: isPasswordVisible,
                          keyboardType: TextInputType.text,
                          validator: isEmpty,
                          suffixIcon: IconButton(
                            icon: isPasswordVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () => setState(
                              () {
                                isPasswordVisible = !isPasswordVisible;
                              },
                            ),
                          ),
                          topText: "Nova senha",
                        ),
                        TextForm(
                          labelText: "Repita a nova senha",
                          controller: confirmPasswordController,
                          icon: Icon(Icons.lock_rounded),
                          obscureText: isPasswordVisible,
                          keyboardType: TextInputType.text,
                          validator: isEmpty,
                          suffixIcon: IconButton(
                            icon: isPasswordVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () => setState(
                              () {
                                isPasswordVisible = !isPasswordVisible;
                              },
                            ),
                          ),
                          topText: "Repitir nova senha",
                        ),
                        Button(
                          buttonIcon: Icon(
                            Icons.upgrade_rounded,
                            color: Colors.white,
                          ),
                          onTap: updateUserInfo,
                          buttonWidget: isInfoUpdated
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Atualizar dados",
                                  style: buttonTextStyle,
                                ),
                        ),
                      ],
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
}
