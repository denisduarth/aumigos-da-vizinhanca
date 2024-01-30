// ignore_for_file: prefer_const_constructors, unused_element, file_names, unused_field, constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final SupabaseClient db;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    db = Supabase.instance.client;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> register() async {
    try {
      assert(emailController.text.isNotEmpty, 'Digite um e-mail válido');
      assert(passwordController.text.isNotEmpty, 'Digite uma senha válida');
      assert(confirmPasswordController.text.isNotEmpty,
          'Digite uma confirmação de senha válida');
      assert(passwordController.text == confirmPasswordController.text,
          'As senhas não coincidem');

      await db.auth.signUp(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      );
    } on SupabaseRealtimeError catch (e) {
      throw e.message.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Digite seu e-mail"),
              controller: emailController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Digite sua senha"),
              controller: passwordController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Confirme sua senha"),
              controller: confirmPasswordController,
            ),
            ElevatedButton(
                onPressed: () => register()
                    .then((value) => Navigator.of(context).pushNamed("/login")),
                child: Text("Entrar"))
          ],
        ),
      ),
    );
  }
}
