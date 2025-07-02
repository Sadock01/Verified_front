import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';

import '../utils/shared_preferences_utils.dart';

class UtilsServices {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> statistiquesByDays() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] =
        'Bearer $token';
    final response = await api.get("dashboard/stats");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'status_code': response.data['status_code'],
        'data': response.data['data']
      };
    } else {
      throw Exception(
          "Echec lors de la mise à jour d'un documenrecuperation des statistiques");
    }
  }

  static Future<Map<String, dynamic>> totalVerifications() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] =
        'Bearer $token';
    final response = await api.get("dashboard/total-verifications");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': response.data['success'],
        'total_verifications': response.data['total_verifications'],
      };
    } else {
      throw Exception("Echec lors de la recup des statis");
    }
  }

  static Future<Map<String, dynamic>> totalDocuments() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] =
        'Bearer $token';
    final response = await api.get("dashboard/total-documents");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': response.data['success'],
        'total_documents': response.data['total_documents'],
      };
    } else {
      throw Exception("Echec lors de la recup des statis");
    }
  }

  static Future<Map<String, dynamic>> statistiquesByVerificationStatus() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] =
        'Bearer $token';
    final response = await api.get("verifications/stats");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'],
        'data': response.data['data']
      };
    } else {
      throw Exception(
          "Echec lors de la mise à jour d'un documenrecuperation des statistiques");
    }
  }
}
