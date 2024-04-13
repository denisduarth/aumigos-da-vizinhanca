mixin ValidatorMixin {
  String? isEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? "O valor não deve ser nulo";
    return null;
  }

  String? hasSixChars(String? value, [String? message]) {
    if (value!.length < 6) {
      return message ?? "O valor deve conter 6 caracteres ou mais";
    }
    return null;
  }

  String? emailValidator(String? value, [String? message]) {
    if (value!.contains("@")) return message ?? "Digite um e-mail válido";
    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final function in validators) {
      final validation = function();
      if (validation != null) return validation;
    }
    return null;
  }
}
