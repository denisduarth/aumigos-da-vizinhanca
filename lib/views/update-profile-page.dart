// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late final SupabaseClient db;
  late final User? user;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      assert(
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty,
          "E-mail ou senha estão incorretos");
      assert(emailController.text.contains("@"), "E-mail inválido");

      await db.auth.updateUser(UserAttributes(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
      ));
    } on SupabaseRealtimeError catch (e) {
      throw e.message.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar dados do usuário"),
      ),
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
            ElevatedButton(
                onPressed: () => updateUserInfo()
                    .then((value) => Navigator.of(context).pushNamed("/profile")),
                child: Text("Entrar"))
          ],
        ),
      ),
    );
  }
}
