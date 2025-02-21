import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';

class VerificationService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> getAllVerification(int page) async {
    
    api.options.headers['AUTHORIZATION'] = 'Bearer 10|hmRWGfAMQ9fkodYhg96joyiPpFz5jBDV9U4bqJVza47c0b53';

    final response = await api.get("dashboard/recent-verifications", queryParameters: {
      'page': page,
      'per_page': 10,
    });
    log("Il a commencé à récupérer les documents");
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Voici la response de la requête: ${response.data}");
      List<dynamic> allVerificationMap = response.data['data'];
      log("Il a récupéré les verifications: $allVerificationMap");
      return {
        // allDocumentMap
        //   .map((documentMap) =>
        //       DocumentsModel.fromJson(documentMap as Map<String, dynamic>))
        //   .toList();
        'status_code': response.data['status_code'],
        'data': response.data['data'], // Liste des documents
        'current_page': response.data['current_page'], // Page actuelle
        'last_page': response.data['last_page'], // Dernière page
      };
    } else {
      throw Exception("Echec lors de la recuperation des verifications");
    }
  }
}