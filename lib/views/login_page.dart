// ignore_for_file: prefer_const_constructors, file_names, unused_element, use_build_context_synchronously, avoid_print, dead_code

import 'package:aumigos_da_vizinhanca/enums/text_align_enums.dart';
import 'package:aumigos_da_vizinhanca/main.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<dynamic> login() async {
    try {
      final response = await db.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (mounted && response.session != null) {
        setState(() {
          isLoggedIn = true;
        });

        final user = response.user;
        final userMetadata = user?.userMetadata;

        SnackBarHelper.showSnackBar(
          context,
          "Logado como ${user!.email}",
          Colors.green,
          Icons.verified_user_rounded,
          false,
        );
        await Future.delayed(Duration(seconds: 2));

        if (userMetadata?['name'] == null) {
          Navigator.pushNamed(context, '/more-info');
        }

        Navigator.pushNamed(context, '/navigation');
      }
    } on AuthException catch (error) {
      SnackBarHelper.showSnackBar(
        context,
        error.message.toString(),
        Colors.red,
        Icons.error,
        false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 60,
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
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Senha inválida";
                              }
                              return null;
                            },
                            hintText: "senha123",
                            suffixIcon: IconButton(
                              icon: isPasswordVisible
                                  ? Icon(Icons.visibility_rounded)
                                  : Icon(Icons.visibility_off_rounded),
                              onPressed: () => setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              }),
                            ),
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
