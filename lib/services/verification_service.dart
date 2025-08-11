import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import '../utils/shared_preferences_utils.dart';

class VerificationService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> getAllVerification(int page) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

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

  static Future<Map<String, dynamic>> verifyDocumentWithFile(
    String identifier,
    Uint8List? pdfBytes, {
    String filename = 'document.pdf',
  }) async {
    try {
      // final formData = FormData.fromMap({
      //   'identifier': identifier,
      //   'file': MultipartFile.fromBytes(
      //     pdfBytes,
      //     filename: filename,
      //     contentType: MediaType('application', 'pdf'),
      //   ),
      // });
      final Map<String, dynamic> data = {
        'identifier': identifier,
      };

      if (pdfBytes != null) {
        data['file'] = MultipartFile.fromBytes(
          pdfBytes.toList(),
          filename: filename,
          contentType: MediaType('application', 'pdf'),
        );
      }

      final formData = FormData.fromMap(data);

      final response = await api.post('/documents/verify', data: formData);
      log("Voici la response de la requête: ${response}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'status': response.data['status'],
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'status': response.data['status'],
          'message': response.data['message'],
        };
      }
    } catch (e) {
      log("Erreur lors de l’envoi : $e");
      return {
        'success': false,
        'message': 'Erreur lors de l’envoi : $e',
      };
    }
  }
}
