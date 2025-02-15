import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/report_model.dart';

class ReportService {
  static Dio api = ApiConfig.api();

 static Future<Map<String, dynamic>> getAllReports(int page) async {
  api.options.headers['AUTHORIZATION'] = 'Bearer 10|hmRWGfAMQ9fkodYhg96joyiPpFz5jBDV9U4bqJVza47c0b53';

  final response = await api.get("dashboard/reports", queryParameters: {
    'page': page,
    'per_page': 10,
  });

  log("Il a commencé à récupérer les rapports");

  if (response.statusCode == 200 || response.statusCode == 201) {
    log("Voici la response de la requête: ${response.data}");

    List<dynamic> allReportsMap = response.data['data'];
    List<ReportModel> reports = allReportsMap.map((report) => ReportModel.fromJson(report)).toList();

    log("Il a récupéré les rapports: $reports");

    return {
      'status_code': response.statusCode, // Utilisez le code de statut de la réponse HTTP
      'data': reports, // Liste des objets ReportModel
      'current_page': response.data['current_page'], // Page actuelle
      'last_page': response.data['last_page'], // Dernière page
    };
  } else {
    throw Exception("Échec lors de la récupération des rapports");
  }
}}
