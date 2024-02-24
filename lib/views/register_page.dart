// ignore_for_file: prefer_const_constructors, unused_element, file_names, unused_field, constant_pattern_never_matches_value_type, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:io';
import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../enums/text_align_enums.dart';
import '../main.dart';
import '../views/all.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  XFile? image;
  final db = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool isPasswordVisible = true, isRegistered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
  }

  Future<void> register() async {
    try {
      await db.storage.from('images').upload(image!.name, File(image!.path));

      await db.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
        data: {
          'name': nameController.text,
          'image': image!.name,
        },
      );

      if (mounted) {
        setState(() {
          isRegistered = true;
        });
        SnackBarHelper.showSnackBar(
          context,
          "Cadastro feito com sucesso",
          false,
        );
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamed(context, '/more-info', arguments: {});
      }
    } on AuthException catch (error) {
      SnackBarHelper.showSnackBar(context, error.message.toString(), true);
    }
  }

  Future<void> uploadImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: SizedBox(
            height: MediaQuery.of(context).size.height + 150,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButtonWidget(
                                icon: Icon(Icons.arrow_back_ios_new_rounded),
                                onPressed: () => Navigator.pop(context),
                                enableBorderSide: false,
                                color: ComponentColors.mainYellow,
                              ),
                              Image.asset(
                                'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                              ),
                            ],
                          ),
                          GradientText(
                            text: "Criar conta",
                            textSize: 50,
                            textAlign: TextAlignEnum.center,
                          ),
                          Text(
                            "Crie sua conta agora mesmo",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: ComponentColors.lightGray,
                              fontSize: 14,
                            ),
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
                              ? AssetImage('images/user_image.png')
                                  as ImageProvider
                              : FileImage(File(image!.path)),
                        ),
                        IconButtonWidget(
                          color: ComponentColors.sweetBrown,
                          enableBorderSide: true,
                          onPressed: uploadImage,
                          icon: Icon(
                            Icons.add_a_photo_rounded,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      height: 370,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextForm(
                              labelText: "Seu e-mail",
                              controller: emailController,
                              icon: Icon(Icons.email_rounded),
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              validator: (text) {
                                if (text!.isEmpty || !text.contains("@")) {
                                  return "E-mail inválido";
                                }
                                return null;
                              },
                              hintText: "patatipatata123@gmail.com"),
                          TextForm(
                            labelText: "Seu nome",
                            controller: nameController,
                            icon: Icon(Icons.data_object_rounded),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Digite um nome";
                              }
                              return null;
                            },
                            hintText: "Patati Patatá",
                          ),
                          TextForm(
                            labelText: "Sua senha",
                            controller: passwordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty ||
                                  text != confirmPasswordController.text) {
                                return "Senha inválida";
                              }
                              return null;
                            },
                            hintText: "senha123",
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
                          ),
                          TextForm(
                            labelText: "Confirme sua senha",
                            controller: confirmPasswordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty ||
                                  text != confirmPasswordController.text) {
                                return "Senha inválida";
                              }
                              return null;
                            },
                            hintText: "senha123",
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
                          ),
                          Button(
                            onTap: register,
                            buttonWidget: isRegistered
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
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
      ),
    );
  }
}
