import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/utils/flutter_storaage_secure.dart';

class AuthentificationService {
  static Dio api = ApiConfig.api();
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await api.post("login", data: {
        "email": email,
        "password": password,
      });
      log('voici le status_code: ${response.data['status_code']}');
      if (response.data['status_code'] == 200 ||
          response.data['status_code'] == 201) {
        log("Connexion réussie : $response");
        //   await FlutterStoraageSecure.saveToken(token);
        return {
          'status_code': response.data['status_code'],
          'acess_token': response.data['acess_token'],
          'message': response.data['message'],
        };
      } else {
        return {
          'status_code': response.data['status_code'],
          'message': response.data['message'],
        };
      }
    } catch (e) {
      log('Erreur lors de la connexion : $e');
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  static Future<String> logout() async {
    // api.options.headers['AUTHORIZATION'] = 'Bearer ${FlutterStoraageSecure.getToken()}';
    final response = await api.post("logout");
    log('il se trouve ici');
    if (response.statusCode == 200 || response.statusCode == 201) {
      //   FlutterStoraageSecure.logout();
      return response.data['message'];
    } else {
      throw Exception("Echec de connexion");
    }
  }
}
