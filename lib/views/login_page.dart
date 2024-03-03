// ignore_for_file: prefer_const_constructors, file_names, unused_element, use_build_context_synchronously, avoid_print, dead_code

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../enums/text_align_enums.dart';
import '../extensions/build_context_extension.dart';
import '../views/all.dart';
import '../widgets/all.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final db = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isLoggedIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void snackBar(String message, Color color) {
    SnackBarHelper.showSnackBar(
      context,
      message,
      color,
      Icons.error_outline_rounded,
      false,
    );
  }

  Future login() async {
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

      if (mounted && response.session != null) {
        setState(() {
          isLoggedIn = true;
        });

        final user = response.user;

        snackBar("Logado como ${user!.email}", Colors.green);
        await Future.delayed(Duration(seconds: 2));

        Navigator.pushNamed(context, '/navigation');
      }
    } on AssertionError catch (error) {
      snackBar(error.message.toString(), Colors.red);
    } on AuthException catch (error) {
      snackBar(error.message.toString(), Colors.red);
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
            height: context.screenHeight - 60,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                            height: 80,
                            width: 80,
                          ),
                          GradientText(
                            text: "Login",
                            textSize: 50,
                            textAlign: TextAlignEnum.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 230,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextForm(
                              labelText: "Digite seu e-mail",
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
                            labelText: "Digite sua senha",
                            controller: passwordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Senha inválida";
                              }
                              return null;
                            },
                            hintText: "senha123",
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
