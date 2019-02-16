import 'package:flutter/material.dart';

class Constants {
  static const String CPF = 'CPF';
  static const String CNPJ = 'CNPJ';
  static const String MASK_PHONE = '(00) 00000-0000';
  static const String ASSETS_LOGIN_LOGO_FILE_NAME = "assets/login_logo_name.png";
  static const String ASSETS_LOGO_USER_PROFILE_FILE_NAME = "assets/usuario.png";
  static const String STORAGE_USER_PICTURE_FILE_NAME = "_profilePicture.jpg";
  static const String PROVIDER_ID_FACEBOOK = "facebook.com";
  static const String PROVIDER_ID_PASSWORD = "password";
  static const SizedBox VERTICAL_SEPARATOR_16 = const SizedBox(height: 16.0,);
  static const SizedBox VERTICAL_SEPARATOR_8 = const SizedBox(height: 8.0,);
  static const SizedBox HORIZONTAL_SEPARATOR_16 = const SizedBox(width: 16.0,);
  static const SizedBox HORIZONTAL_SEPARATOR_8 = const SizedBox(width: 8.0,);

  static const String LABEL_KM = "Kilômetros";
  static const String LABEM_M = "Metros";

  static const String USER_DELETED = "Usuário removido";
  static const String TOOLTIP_MAP_TYPE = "Tipo do mapa";
  static const String TOOLTIP_FAVORITE = "Favoritos";
  static const String TOOLTIP_PRO_LIST = "Profissionais";
  static const String TOOLTIP_CONFIRM = "Confirmar";
  static const String PHONE_BRAZIL_PERFIX = "55";
  static const int NETWORK_TIMEOUT_SECONDS = 14;


  static String getDefaultWhatsappMessage({@required String professionalName }){
    return "Olá $professionalName sou usuário do Autônomos e pretendo "
        "contratar seus serviços";
  }


}