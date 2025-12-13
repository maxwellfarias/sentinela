import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Urls {
  // Supabase Configuration (carregado de variáveis de ambiente)
  static final urlBase = "https://dqsbpsifdyujbbvbzjdq.supabase.co/rest/v1/";
  static String get supabaseApiKey => dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';
  static String login =  '${urlBase}auth/v1/token?grant_type=password';
  static String logout = '${urlBase}auth/v1/logout';
  static String refreshToken = '${urlBase}auth/v1/token?grant_type=refresh_token';
}
