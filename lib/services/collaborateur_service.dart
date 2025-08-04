import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/collaborateurs_model.dart';

import '../utils/shared_preferences_utils.dart';

class CollaborateurService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> getAllCollaborateur(int page) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final response = await api.get("users", queryParameters: {
      'page': page,
      'per_page': 10,
    });
    log("Il a commencé à récupérer les documents");

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Voici la response de la requête: ${response.data}");
      List<dynamic> allCollaborateurMap = response.data['data'];
      log("Il a récupéré les documents: $allCollaborateurMap");
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

  static Future<Map<String, dynamic>> addCollaborateur(CollaborateursModel collaborateurModel) async {
    final token = await SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    log("il est la?? ${collaborateurModel.toJson()}");
    final response = await api.post("users/create", data: collaborateurModel.toJson());
    log("Il a commencé à ajouter un collaborateur");
    // log("$response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'] ?? "Collaborateur ajouté avec succès",
        'user': response.data['user'] ?? {},
      };
    } else {
      log("${response.statusCode}");
      log("$response");
      throw Exception("Echec lors de l'ajout d'un collaborateur");
    }
  }

  static Future<Map<String, dynamic>> updateCollaborateur(int colllaborateurId, CollaborateursModel collaborateurModel) async {
    final token = await SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final response = await api.put("users/edit/user/$colllaborateurId", data: collaborateurModel.toJson());
    log("$response");
    log("Il a commencé à mettre à jour un document");
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("${response.data['message']}");
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'],
      };
    } else {
      throw Exception("Echec lors de la mise à jour d'un collaborateur");
    }
  }

  static Future<Map<String, dynamic>> getUserDetails() async {
    try {
      final token = await SharedPreferencesUtils.getString('auth_token');

      final response = await api.get(
        'me', // adapte l’URL ici
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("getUserDetails(): $response");
      final roleId = response.data['data']['role_id'];
      log("role_id(): $roleId");
      await SharedPreferencesUtils.setInt('role_id', roleId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final id = await SharedPreferencesUtils.getInt('role_id');
        log("Voici les details du role du collab: $id");
        return {
          'status_code': data['status_code'],
          'message': data['message'],
          'data': data['data'], // c'est un Map<String, dynamic>
        };
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      log('Erreur fetchAccountDetails: $e');
      throw Exception('Erreur réseau: ${e}');
    }
  }
}
