import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/utils/flutter_storaage_secure.dart';

import '../utils/shared_preferences_utils.dart';

class AuthentificationService {
  static Dio api = ApiConfig.api();
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await api.post("login", data: {
        "email": email,
        "password": password,
      });
      log('voici le status_code: ${response.data['status_code']}');
      if (response.data['status_code'] == 200 || response.data['status_code'] == 201) {
        log("Connexion réussie : $response");
        final token = response.data['access_token'];
        await SharedPreferencesUtils.setString('auth_token', token);
        final me = SharedPreferencesUtils.getString('auth_token');
        log("SharedPreferencesUtils.getString:$me");
        return {
          'status_code': response.data['status_code'],
          'acess_token': token,
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

  // static Future<String> logout() async {
  //   final token = SharedPreferencesUtils.getString('auth_token');
  //   log("mon token de connexion : $token");
  //   api.options.headers['Authorization'] = 'Bearer $token';
  //
  //   final response = await api.post("logout");
  //   log('il se trouve ici');
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     await FlutterStorageSecure.deleteToken();
  //     return response.data['message'];
  //   } else {
  //     throw Exception("Echec de connexion");
  //   }
  // }
  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = SharedPreferencesUtils.getString('auth_token');
      log("🔐 Token utilisé pour la déconnexion : $token");

      if (token == null || token.isEmpty) {
        return {
          'status_code': 400,
          'message': 'Token invalide ou inexistant.',
        };
      }

      final response = await api.post(
        '/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log("✅ Réponse logout : ${response.data}");

      final int statusCode = response.data['status_code'] ?? response.statusCode ?? 500;
      final String message = response.data['message'] ?? 'Déconnexion effectuée.';

      // Tu peux aussi vider le token ici si c’est un succès
      if (statusCode == 200) {
        await SharedPreferencesUtils.remove('auth_token');
      }

      return {
        'status_code': statusCode,
        'message': message,
      };
    } catch (e) {
      log("❌ Erreur logout : $e");
      return {
        'status_code': 500,
        'message': 'Une erreur est survenue lors de la déconnexion.',
      };
    }
  }

}
