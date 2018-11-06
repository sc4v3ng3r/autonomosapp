import 'RegExpPatterns.dart';

class InputValidator {

  static String validadeEmail(String email) {
    RegExp regularExp = RegExp(RegExpPatterns.EMAIL_PATTERN);
    print("ValidadeEmail");

    if (!regularExp.hasMatch(email)) {
      return "E-mail inválido";
    }

    return null;
  }

  static String validadePassword(String password){
    print("ValidadePassword");
    if (password == null || password.isEmpty){
      return "A senha não pode ser vazia!";
    }

    if (password.length < 6)
      return "Mínimo de 6 caracteres";

    return null;
  }
}
