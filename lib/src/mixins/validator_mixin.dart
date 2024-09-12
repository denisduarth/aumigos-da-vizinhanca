mixin ValidatorMixin {
  String? isEmpty(String? value, [String? message]) =>
      value!.isEmpty ? message : "O valor não deve ser nulo";

  String? hasSixChars(String? value, [String? message]) =>
      value!.length < 6 ? message : "O valor deve conter 6 caracteres ou mais";

  String? emailValidator(String? value, [String? message]) =>
      value!.contains("@") ? message : "Digite um e-mail válido";

  String? combine(List<String? Function()> validators) {
    for (final function in validators) {
      final validation = function();
       return validation ?? '';
    }
    return null;
  }
}
