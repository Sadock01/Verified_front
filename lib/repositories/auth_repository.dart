import 'dart:developer';

import 'package:doc_authentificator/services/authentification_service.dart';

class AuthRepository {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await AuthentificationService.login(email, password);

      log('voici le status_code repo :${response['status_code']}');
      if (response['status_code'] == 200) {
        return {
          'status_code': response['status_code'],
          'message': response['message'],
        };
      } else {
        return {
          'status_code': response['status_code'],
          'message': response['message'],
        };
      }
    } catch (e) {
      log('Erreur lors de la connexion : $e');
      throw Exception('Erreur lors de la connexion');
    }
  }

  // static Future<String> logout() async {
  //   String message = await AuthentificationService.logout();
  //   return message;
  // }
}
