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
  static Future<int> logout() async {
    try {
      final token = SharedPreferencesUtils.getString('auth_token');
      log("mon token de connexion : $token");
      if (token != null && token.isNotEmpty) {
        // final res1 = await CreditCardService.getCreditCardDetails(currentUser!.id);
        // log("Voici les details de la card de credit: $res1");
        final response = await api.post(
          '/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );
        log("Voici A RESPONSE: $response");
        final int res = response.data['status_code'];

        if (response.statusCode == 200 || response.statusCode == 201) {
          // await SharedPreferencesUtils.remove('auth_token');
          return res;
        } else {
          return res;
        }
      } else {
        // cas où le token est null ou vide
        return 400;
      }
    } catch (e) {
      throw Exception("Erreur lors de la déconnexion : ${e.toString()}");
    }
  }
}
