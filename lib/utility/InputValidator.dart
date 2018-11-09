import 'RegExpPatterns.dart';

class InputValidator {

  static String emailValidation(String email) {
    RegExp regularExp = RegExp(RegExpPatterns.EMAIL_PATTERN);
    print("ValidadeEmail");

    if (!regularExp.hasMatch(email)) {
      return "E-mail inválido";
    }
    return null;
  }

  static String passwordValidation(String password){
    print("ValidadePassword");
    if (password == null || password.isEmpty){
      return "A senha não pode ser vazia";
    }

    if (password.length < 6)
      return "Mínimo de 6 caracteres";

    return null;
  }

  static String nameValidation(String name){
    if (name == null || name.isEmpty){
      return "O nome não pode ser vazio";
    }
    return null;
  }
}
