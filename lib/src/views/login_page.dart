// ignore_for_file: prefer_const_constructors, file_names, unused_element, use_build_context_synchronously, avoid_print, dead_code

import 'dart:async';
import 'package:aumigos_da_vizinhanca/src/exports/extensions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../exports/enums.dart';
import '../exports/views.dart';
import '../exports/widgets.dart';
import '../mixins/validator_mixin.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 3));
          emailController.clear();
          passwordController.clear();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: context.screenHeight - 150,
              alignment: AlignmentDirectional.center,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Form(
                canPop: false,
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 50.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  ImagesEnum.logoMainYellow.imageName,
                                  width: 40,
                                  height: 40,
                                ),
                                GradientText(
                                  text: "   Aumigos da Vizinhança",
                                  textSize: 15,
                                  textAlign: TextAlignEnum.start,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "Login",
                                style: TextStyles.textStyle(
                                  fontColor: ComponentColors.mainBlack,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 360,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextForm(
                            topText: "E-mail",
                            labelText: "Digite seu e-mail",
                            controller: emailController,
                            icon: Icon(Icons.email_outlined),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) => combine([
                              () => isEmpty(value),
                              () => emailValidator(value),
                            ]),
                          ),
                          TextForm(
                            topText: "Senha",
                            labelText: "Digite sua senha",
                            controller: passwordController,
                            icon: Icon(Icons.lock_outline_rounded),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: isEmpty,
                          ),
                          Button(
                            buttonIcon: isLoggedIn
                                ? Container()
                                : Icon(
                                    Icons.login_outlined,
                                    color: Colors.white,
                                  ),
                            buttonColor: ComponentColors.sweetBrown,
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
                          style: TextStyles.textStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontColor: Colors.black26,
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
                            textSize: 13.5,
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
