// ignore_for_file: prefer_const_constructors, file_names, unused_element, use_build_context_synchronously, avoid_print, unused_import, dead_code

import 'package:flutter_animate/flutter_animate.dart';

import '../views/all.dart';
import '../components/all.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final SupabaseClient db;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    db = Supabase.instance.client;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      assert(
          emailController.text.isNotEmpty && emailController.text.contains("@"),
          "E-mail inválido");
      assert(passwordController.text.isNotEmpty, "Senha inválida");

      await db.auth.signInWithPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );

      Navigator.of(context).pushNamed('/home');
    } on SupabaseRealtimeError catch (e) {
      print(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 500,
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/aumigos_da_vizinhanca_logo.png',
                    height: 100,
                    width: 100,
                  ).animate().fadeIn(
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                  GradientText(text: "Login").animate().fadeIn(
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                  TextForm(
                    labelText: "Digite seu email",
                    controller: emailController,
                    icon: Icon(Icons.email_outlined),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                  TextForm(
                    labelText: "Digite sua senha",
                    controller: passwordController,
                    icon: Icon(Icons.password_outlined),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  Button(
                    onPressed: _login,
                    buttonText: "Entrar",
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
