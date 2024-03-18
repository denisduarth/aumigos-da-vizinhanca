// ignore_for_file: prefer_const_constructors, unused_element, file_names, unused_field, constant_pattern_never_matches_value_type, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:aumigos_da_vizinhanca/extensions/build_context_extension.dart';
import 'package:aumigos_da_vizinhanca/mixins/validator_mixin.dart';
import '../exports/widgets.dart';
import 'package:flutter/material.dart';
import '../enums/text_align_enums.dart';
import '../exports/views.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool isPasswordVisible = true;
  bool isRegistered = false;

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

  @override
  Widget build(BuildContext context) {
    void saveData() {
      try {
        assert(emailController.text.isNotEmpty, "Digite um e-mail");
        assert(emailController.text.contains("@"), "E-mail inválido");
        assert(nameController.text.isNotEmpty, "Digite um nome");
        assert(passwordController.text.isNotEmpty, "Digite uma senha");
        assert(confirmPasswordController.text.isNotEmpty, "Confirme sua senha");
        assert(
            confirmPasswordController.text.length >= 6 &&
                passwordController.text.length >= 6,
            "Senhas tem que ter mais de 6 caracteres");
        assert(passwordController.text == confirmPasswordController.text,
            "Senhas não coincidem");

        Map<String, dynamic> arguments = {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        };

        context.pushNamedWithArguments('/more-info', arguments);
      } on AssertionError catch (error) {
        context.showErrorSnackbar(error.message.toString());
      }
    }

    final hasConnection = context.hasConnection;
    final styles = {
      'localization_alert_text_style': TextStyle(
        fontFamily: "Poppins",
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: ComponentColors.mainBlack,
      ),
      'register_next_step_style': TextStyle(
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: ComponentColors.mainGray,
      ),
      'turned_on_localization_button_text_style': TextStyle(
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: ComponentColors.sweetBrown,
      ),
    };

    if (!hasConnection) return const NetworkErrorPage();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: SizedBox(
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
                                width: 60,
                                height: 60,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: GradientText(
                              text: "Inserindo os Dados",
                              textSize: 28,
                              textAlign: TextAlignEnum.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 50.0),
                            child: Text(
                              "Para começar, introduza seus dados primários, como nome, email e senha desejados. Após isso, partiremos para a próxima tela para a finalização do cadastro",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: ComponentColors.mainGray,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      height: 550,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextForm(
                            labelText: "Seu e-mail",
                            controller: emailController,
                            icon: Icon(Icons.email_rounded),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: (value) => combine([
                              () => isEmpty(value),
                              () => emailValidator(value),
                            ]),
                            topText: "E-mail",
                          ),
                          TextForm(
                            labelText: "Seu nome",
                            controller: nameController,
                            icon: Icon(Icons.data_object_rounded),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            validator: isEmpty,
                            topText: "Nome",
                          ),
                          TextForm(
                            labelText: "Sua senha",
                            controller: passwordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: isEmpty,
                            topText: "Senha",
                          ),
                          TextForm(
                            labelText: "Confirme sua senha",
                            controller: confirmPasswordController,
                            icon: Icon(Icons.lock_rounded),
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: isEmpty,
                            topText: "Repitir senha",
                          ),
                          Button(
                            onTap: () => showAdaptiveDialog(
                              context: context,
                              builder: (context) => AlertDialog.adaptive(
                                icon: Icon(
                                  Icons.location_on,
                                  color: ComponentColors.sweetBrown,
                                  size: 40,
                                ),
                                title: Text(
                                  "Alerta de Localização",
                                  style:
                                      styles['localization_alert_text_style'],
                                ),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Wrap(
                                          children: [
                                            Text(
                                              "Para a próxima parte do cadastro, tenha certeza de que a ferramenta de localização do seu celular esteja ativada",
                                              style: styles[
                                                  'register_next_step_style'],
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 30.0,
                                          ),
                                          child: OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 24),
                                              foregroundColor:
                                                  ComponentColors.sweetBrown,
                                              side: BorderSide(
                                                color:
                                                    ComponentColors.sweetBrown,
                                                width: 1.8,
                                              ),
                                            ),
                                            onPressed: saveData,
                                            icon: Icon(
                                              Icons.location_on,
                                              color: ComponentColors.sweetBrown,
                                            ),
                                            label: Text(
                                              "Localização está ativada",
                                              textAlign: TextAlign.center,
                                              style: styles[
                                                  'turned_on_localization_button_text_style'],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            buttonWidget: isRegistered
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Continuar",
                                    style: buttonTextStyle,
                                  ),
                          ),
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
