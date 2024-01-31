// ignore_for_file: prefer_const_constructors, unused_element, file_names, unused_field, constant_pattern_never_matches_value_type

import 'package:aumigos_da_vizinhanca/components/all.dart';
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

  Future<void> _register() async {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: Navigator.of(context).pop,
                                color: Colors.white,
                                icon: Icon(Icons.arrow_back),
                                style: IconButton.styleFrom(
                                  backgroundColor: ComponentColors.sweetBrown,
                                ),
                              ),
                              Image.asset(
                                'images/aumigos_da_vizinhanca_logo_main_yellow.png',
                              ),
                            ],
                          ),
                          GradientText(text: "Criar conta", textSize: 50)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextForm(
                            labelText: "Seu email",
                            controller: emailController,
                            icon: Icon(Icons.email_rounded),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          TextForm(
                            labelText: "Sua senha",
                            controller: passwordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                          TextForm(
                            labelText: "Confirme sua senha",
                            controller: confirmPasswordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                          Button(
                              onPressed: _register, buttonText: "Criar conta")
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
