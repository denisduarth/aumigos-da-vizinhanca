// ignore_for_file: prefer_const_constructors, file_names, unused_element, use_build_context_synchronously, avoid_print, dead_code

import 'dart:async';

import 'package:aumigos_da_vizinhanca/mixins/validator_mixin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../enums/text_align_enums.dart';
import '../extensions/build_context_extension.dart';
import '../exports/views.dart';
import '../exports/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ValidatorMixin {
  final db = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isLoggedIn = false;
  final snackBarHelper = SnackBarHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      assert(emailController.text.isNotEmpty, "Digite um e-mail");
      assert(emailController.text.contains("@"), "E-mail inválido");
      assert(passwordController.text.isNotEmpty, "Digite uma senha");
      assert(passwordController.text.length >= 6,
          "A senha deve conter mais de 6 caracteres");

      final response = await db.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final session = response.session;

      if (mounted && session != null) {
        final user = db.auth.currentUser;

        setState(() {
          isLoggedIn = true;
        });

        SnackBarHelper().showSucessSnackbar(
          "Logado como ${user!.email}",
          context,
        );
        await Future.delayed(Duration(seconds: 2));

        Navigator.pushNamed(context, '/navigation');
      }
    } on AssertionError catch (error) {
      context.showErrorSnackbar(error.message.toString());
    } on AuthException catch (error) {
      context.showErrorSnackbar(error.message.toString());
    } catch (error) {
      context.showErrorSnackbar('Erro inesperado aconteceu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = context.hasConnection;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.screenHeight - 50,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: GradientText(
                                  text: "Login",
                                  textSize: 33,
                                  textAlign: TextAlignEnum.start)),
                          Image.asset(
                            'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                            height: 60,
                            width: 60,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextForm(
                            labelText: "Digite seu e-mail",
                            controller: emailController,
                            icon: Icon(Icons.email_rounded),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) => combine([
                              () => isEmpty(value),
                              () => emailValidator(value),
                            ]),
                            topText: "Login",
                          ),
                          TextForm(
                            labelText: "Digite sua senha",
                            controller: passwordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: isEmpty,
                            topText: "Senha",
                          ),
                          Button(
                            onTap: login,
                            buttonWidget: isLoggedIn
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Entrar",
                                    style: buttonTextStyle,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Não tem uma conta? ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black26,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            PageTransition(
                              child: RegisterPage(),
                              type: PageTransitionType.leftToRight,
                            ),
                          ),
                          child: GradientText(
                            text: "Crie agora",
                            textSize: 11.5,
                            textAlign: TextAlignEnum.center,
                          ),
                        ),
                      ],
                    )
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
