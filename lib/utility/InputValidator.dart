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

  static String textDescription(String text){
    if (text == null || text.isEmpty){
      return "O texto não pode ser vazio";
    }
    return null;
  }

  static String cpfValidation(String cpf){
    if (cpf == null || cpf.isEmpty)
      return "CPF não pode ser vazio";
    //053.556.175-06
    else if (cpf.length < 14)
      return "CPF inválido";
    
    else {
      String cpfWithoutMask = _removingMask(cpf);

      if(_validateCpf(cpfWithoutMask))
        return null;

      return "CPF inválido";
    }

  }

  static String cnpjValidation(String cnpj){
    if ( cnpj == null || cnpj.isEmpty )
      return "CNPJ não pode ser vazio";

    else if ( _validadeCNPJ( _removingMask(cnpj)  ))
      return null;

    return "CNPJ inválido";
  }

  static String phoneValidation(String phone){
    print("PHONE VALIDATOR METHOD!");
    if (phone == null || phone.isEmpty)
      return "Insira o telefone";
    // fazer conta do numero de caracteres...
    return null;
  }

  static String _removingMask(String number){
    String numberWithoutMask  = "";
    for(int i=0; i < number.length; i++){
      if ( (number[i].compareTo(".") == 0) ||
           (number[i].compareTo("-") == 0) ||
           (number[i].compareTo("/") == 0) )
        continue;

      numberWithoutMask+= number[i];
    }

    return numberWithoutMask;
  }

  //Código disponível em:
  //http://www.receita.fazenda.gov.br/aplicacoes/atcta/cpf/funcoes.js

  static bool _validateCpf(String strCPF){
    var Soma;
    var Resto;
    Soma = 0;
    //05355617506

    if (strCPF == "00000000000")
      return false;

    for (int i=1; i<=9; i++)
      Soma = Soma + int.parse(strCPF.substring(i-1, i)) * (11 - i);

    Resto = (Soma * 10) % 11;

    if ((Resto == 10) || (Resto == 11))
      Resto = 0;

    if (Resto != int.parse(strCPF.substring(9, 10)) )
      return false;

    Soma = 0;

    for (int i = 1; i <= 10; i++)
      Soma = Soma + int.parse(strCPF.substring(i-1, i)) * (12 - i);

    Resto = (Soma * 10) % 11;

    if ((Resto == 10) || (Resto == 11))
      Resto = 0;
    if (Resto != int.parse(strCPF.substring(10, 11) ) )
      return false;

    return true;

  }

  static bool _validadeCNPJ(String cnpj){
    print("VALIDANDO $cnpj");
    //cnpj = cnpj.replace(/[^\d]+/g,'');

    //if(cnpj == '') return false;

    if (cnpj.length != 14)
      return false;

    // Elimina CNPJs invalidos conhecidos
    if (cnpj == "00000000000000" ||
        cnpj == "11111111111111" ||
        cnpj == "22222222222222" ||
        cnpj == "33333333333333" ||
        cnpj == "44444444444444" ||
        cnpj == "55555555555555" ||
        cnpj == "66666666666666" ||
        cnpj == "77777777777777" ||
        cnpj == "88888888888888" ||
        cnpj == "99999999999999")
      return false;

    // Valida DVs
    int tamanho = cnpj.length - 2;
    String numeros = cnpj.substring(0,tamanho);
    String digitos = cnpj.substring(tamanho);
    var soma = 0;
    var pos = tamanho - 7;
    for (int i = tamanho; i >= 1; i--) {
      soma += int.parse( numeros[tamanho - i]) * pos--;
      if (pos < 2)
        pos = 9;
    }
    var resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
    if ( resultado != int.parse( digitos[0]) )
      return false;

    tamanho = tamanho + 1;
    numeros = cnpj.substring(0,tamanho);
    soma = 0;
    pos = tamanho - 7;
    for (int i = tamanho; i >= 1; i--) {
      soma += int.parse( numeros[tamanho - i] )  * pos--;
      if (pos < 2)
        pos = 9;
    }
    resultado = soma % 11 < 2 ? 0 : 11 - soma % 11;
    if (resultado != int.parse(digitos[1]) )
      return false;

    return true;

  }
}
