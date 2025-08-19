import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/report_model.dart';

import '../utils/shared_preferences_utils.dart';

class ReportService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> getAllReports(int page) async {
    try {
      final token = SharedPreferencesUtils.getString('auth_token');
      api.options.headers['Authorization'] = 'Bearer $token';

      final response = await api.get(
        "dashboard/reports",
        queryParameters: {
          'page': page,
          'per_page': 10,
        },
      );

      log("📡 Réponse brute API: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Vérifier si la réponse est une Map (cas normal avec pagination)
        if (response.data is Map<String, dynamic>) {
          final Map<String, dynamic> dataMap = response.data;

          final List<ReportModel> reports = (dataMap['data'] as List).map((e) => ReportModel.fromJson(e)).toList();

          return {
            'status_code': response.statusCode,
            'data': reports,
            'current_page': dataMap['current_page'] ?? 1,
            'last_page': dataMap['last_page'] ?? 1,
          };
        }

        // Cas particulier : le backend renvoie directement une liste
        if (response.data is List) {
          final List<ReportModel> reports = (response.data as List).map((e) => ReportModel.fromJson(e)).toList();

          return {
            'status_code': response.statusCode,
            'data': reports,
            'current_page': 1,
            'last_page': 1,
          };
        }

        throw Exception("Format de réponse inattendu 🚨");
      }

      // Gestion des statuts d'erreur
      return {
        'status_code': response.statusCode,
        'data': <ReportModel>[],
        'current_page': 1,
        'last_page': 1,
        'error': "Erreur serveur: ${response.statusMessage}",
      };
    } catch (e, stack) {
      log("❌ Erreur lors de la récupération des rapports: $e");
      log("$stack");

      return {
        'status_code': 500,
        'data': <ReportModel>[],
        'current_page': 1,
        'last_page': 1,
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getAllDocumentReport(int documentId, int page) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final response = await api.get("dashboard/history/$documentId", queryParameters: {
      'page': page,
      'per_page': 10,
    });

    log("Il a commencé à récupérer le rapport du document $documentId: $response");

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Voici la response de la requête: ${response.data}");

      List<dynamic> allReportsMap = response.data['data'];
      List<ReportModel> reports = allReportsMap.map((report) => ReportModel.fromJson(report)).toList();

      log("Il a récupéré le rapports: $reports");

      return {
        'status_code': response.statusCode, // Utilisez le code de statut de la réponse HTTP
        'data': reports, // Liste des objets ReportModel
        'current_page': response.data['current_page'], // Page actuelle
        'last_page': response.data['last_page'], // Dernière page
      };
    } else {
      throw Exception("Échec lors de la récupération des rapports");
    }
  }
}
