import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/documents_model.dart';

class DocumentService {
  static Dio api = ApiConfig.api();

  static Future<List<DocumentsModel>> getAllDocument() async {
    api.options.headers['AUTHORIZATION'] =
        'Bearer 10|hmRWGfAMQ9fkodYhg96joyiPpFz5jBDV9U4bqJVza47c0b53';
    final response = await api.get("documents", queryParameters: {});
    log("Il a commencé à récupérer les documents");
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Voici la response de la requête: ${response.data}");
      List<dynamic> allDocumentMap = response.data['data'];
      log("Il a récupéré les documents: $allDocumentMap");
      return allDocumentMap
          .map((documentMap) =>
              DocumentsModel.fromJson(documentMap as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Echec lors de la recuperation des articles");
    }
  }

  static Future<String?> addDocument(DocumentsModel documentsModel) async {
    api.options.headers['AUTHORIZATION'] =
        '10|hmRWGfAMQ9fkodYhg96joyiPpFz5jBDV9U4bqJVza47c0b53';
    log("il est la?? ${documentsModel.toJson()}");
    final response =
        await api.post("/documents/create", data: documentsModel.toJson());
    log("Il a commencé à ajouter un document");
    // log("$response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['message'] ?? "Document ajouté avec succès";
    } else {
      log("${response.statusCode}");
      log("$response");
      throw Exception("Echec lors de l'ajout d'un document");
    }
  }

  static Future<String?> updateDocument(DocumentsModel documentsModel) async {
    api.options.headers['AUTHORIZATION'] =
        'Bearer 7|3JtLwLxvJtkVlnRvTgKln1XZIXHPNRP8mhlF42Mt32d8c745';
    final response = await api.put("documents/edit/document4",
        data: documentsModel.toJson());
    log("Il a commencé à mettre à jour un document");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['message'] ?? "Document mise à jour avec succès";
    } else {
      throw Exception("Echec lors de la mise à jour d'un document");
    }
  }

  static Future<Map<String, dynamic>> verifyDocument(String? identifier) async {
    api.options.headers['AUTHORIZATION'] =
        '10|hmRWGfAMQ9fkodYhg96joyiPpFz5jBDV9U4bqJVza47c0b53';

    try {
      final response = await api
          .post("documents/verify-document", data: {'identifier': identifier});
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
          'message': 'Erreur inattendue. Veuillez réessayer plus tard.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur : $e',
      };
    }
  }
}
