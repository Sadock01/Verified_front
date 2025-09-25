import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import '../utils/shared_preferences_utils.dart';

class DocumentService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> getAllDocument(int page) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = '$token';
    log("token: $token");
    final response = await api.get("documents",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          'page': page,
          'per_page': 10,
        });
    log("Il a commencé à récupérer les documents");

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Voici la response de la requête: ${response.data}");
      List<dynamic> allDocumentMap = response.data['data'];
      log("Il a récupéré les documents: $allDocumentMap");
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
      throw Exception("Echec lors de la recuperation des articles");
    }
  }

  static Future<Map<String, dynamic>> addDocument(DocumentsModel documentsModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    log("il est la?? ${documentsModel.toJson()}");
    final response = await api.post("/documents/add", data: documentsModel.toJson());
    log("Il a commencé à ajouter un document");
    log("$response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'] ?? "Document ajouté avec succès",
        'data': response.data['data'] ?? {},
      };
    } else {
      log("${response.statusCode}");
      log("la response du backend $response");
      throw Exception("Echec lors de l'ajout d'un document");
    }
  }
  static Future<Map<String, dynamic>> addListDocuments(List<DocumentsModel> documentsList) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    // Transformation en liste de JSON
    final documentsJsonList = documentsList.map((doc) => doc.toJson()).toList();

    log("Données envoyées : $documentsJsonList");

    try {
      final response = await api.post(
        "/documents/create",
        data: {
          'documents': documentsJsonList,
        },
      );

      log("Réponse du backend : $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': response.data['success'] ?? [],
          'failed': response.data['failed'] ?? [],
        };
      } else {
        log("Erreur HTTP ${response.statusCode}");
        throw Exception("Échec de l'ajout des documents");
      }
    } catch (e) {
      log("Exception lors de l'envoi des documents : $e");
      throw Exception("Erreur lors de l'envoi des documents : $e");
    }
  }

  static Future<Map<String, dynamic>> uploadDocumentWithFile(
    String identifier,
    Uint8List pdfBytes, {
    String filename = 'document.pdf',
  }) async {
    try {
      final formData = FormData.fromMap({
        'identifiers': identifier,
        'files': MultipartFile.fromBytes(
          pdfBytes,
          filename: filename,
          contentType: MediaType('application', 'pdf'),
        ),
      });
      final token = SharedPreferencesUtils.getString('auth_token');
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      final response = await api.post(
        '/uploadDocument', // Remplace par ton endpoint complet si nécessaire
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      log("Réponse de upload document: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } catch (e) {
      log("Erreur lors de la création du document : $e");
      return {
        'success': false,
        'message': 'Erreur lors de la création du document : $e',
      };
    }
  }

  static Future<Map<String, dynamic>> uploadExcelFile(
    Uint8List pdfBytes, {
    String filename = 'document.pdf',
  }) async {
    try {
      final formData = FormData.fromMap({
        'excel_file': MultipartFile.fromBytes(
          pdfBytes,
          filename: filename,
          contentType: MediaType('application', 'pdf'),
        ),
      });
      final token = SharedPreferencesUtils.getString('auth_token');
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      final response = await api.post(
        '/uploadExcel', // Remplace par ton endpoint complet si nécessaire
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      log("Réponse de upload document: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } catch (e) {
      log("Erreur lors de la création du document : $e");
      return {
        'success': false,
        'message': 'Erreur lors de la création du document : $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateDocument(int documentId, DocumentsModel documentsModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final response = await api.put("documents/edit/document/$documentId", data: documentsModel.toJson());
    log("response update :$response");
    log("Il a commencé à mettre à jour un document");
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("${response.data['message']}");
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'],
      };
    } else {
      throw Exception("Echec lors de la mise à jour d'un document");
    }
  }

  static Future<Map<String, dynamic>> verifyDocument(String? identifier) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    try {
      final response = await api.post("documents/verify-document", data: {'identifier': identifier});
      log('voici la response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Aucun document ne correspond a cet identifiant',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur : $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getDocumentById(int documentId) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    try {
      log("Début de récupération du document ID: $documentId");
      final response = await api.get("/documents/$documentId");

      if (response.statusCode == 200) {
        log("Réponse reçue: ${response.data}");
        return {
          'status_code': response.data['status_code'],
          'message': response.data['message'],
          'data': response.data['data'], // Document récupéré
        };
      } else {
        log("Erreur: ${response.statusCode}");
        throw Exception("Échec lors de la récupération du document");
      }
    } catch (e) {
      log("Exception: $e");
      return {
        'status_code': 404,
        'message': "Document introuvable",
        'error': e.toString(),
      };
    }
  }
}
