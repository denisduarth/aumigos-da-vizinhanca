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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 60,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 175,
                    child: Column(
                      children: [
                        Image.asset(
                          'images/aumigos_da_vizinhanca_logo_sweet_brown.png',
                          height: 100,
                          width: 100,
                        ),
                        GradientText(
                          text: "Login",
                          textSize: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 210,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextForm(
                          labelText: "Digite seu email",
                          controller: emailController,
                          icon: Icon(Icons.email_rounded),
                          obscureText: false,
                          keyboardType: TextInputType.text,
                        ),
                        TextForm(
                          labelText: "Digite sua senha",
                          controller: passwordController,
                          icon: Icon(Icons.lock_rounded),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        Button(
                          onPressed: _login,
                          buttonText: "Entrar",
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
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black26),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(_createRoute()),
                        child: GradientText(text: "Crie agora", textSize: 14),
                      )
                    ],
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
