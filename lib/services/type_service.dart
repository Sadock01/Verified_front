import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';

import '../utils/shared_preferences_utils.dart';

class TypeService {
  static Dio api = ApiConfig.api();

  static Future<List<TypeDocModel>> getAllType() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    final response = await api.get("types", queryParameters: {"page": 1});
    log("Il a commencé à récupérer les types: $response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> allTypeMap = response.data['data'];
      // final int currentPage = response.data['current_page'];
      // final int totalPages = response.data['last_page'];
      return allTypeMap.map((typeMap) => TypeDocModel.fromJson(typeMap as Map<String, dynamic>)).toList();
    } else {
      throw Exception("Echec lors de la recuperation des articles");
    }
  }

  static Future<Map<String, dynamic>> addType(TypeDocModel typeDocModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    log("il est la?? ${typeDocModel.toJson()}");
    final response = await api.post("/types/create", data: typeDocModel.toJson());
    log("Il a commencé à ajouter un type");
    log("$response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'status_code': response.statusCode,
        'message': response.data['message'] ?? "Document ajouté avec succès",
        'data': response.data['data'] ?? {},
      };
    } else {
      log("${response.statusCode}");
      log("$response");
      throw Exception("Echec lors de l'ajout d'un document");
    }
  }

  static Future<Map<String, dynamic>> updateType(int typeId, TypeDocModel typeModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final response = await api.put("types/edit/type/$typeId", data: typeModel.toJson());
    log("response update type:$response");
    log("Il met à jour un type");
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

  static Future<Map<String, dynamic>> deleteType(int typeId) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    try {
      final response = await api.delete(
        "types/$typeId",
        options: Options(
          validateStatus: (status) => status != null && status < 600, // Accepter tous les codes HTTP
        ),
      );
      
      log("Réponse de suppression du type: ${response.statusCode} - ${response.data}");
      
      // Toujours retourner la réponse, même si c'est une erreur (409, 404, etc.)
      return {
        'status_code': response.data['status_code'] ?? response.statusCode ?? 500,
        'message': response.data['message'] ?? 'Type supprimé avec succès',
        'nombre_documents': response.data['nombre_documents'], // Pour le cas 409
      };
    } on DioException catch (e) {
      // Gérer les erreurs HTTP spécifiques
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final data = e.response!.data;
        
        log("Erreur DioException lors de la suppression: $statusCode - ${data}");
        
        return {
          'status_code': statusCode ?? 500,
          'message': data['message'] ?? 'Erreur lors de la suppression du type',
          'nombre_documents': data['nombre_documents'], // Pour le cas 409
        };
      }
      
      // Erreur réseau sans réponse (pas de connexion, timeout, etc.)
      log("Erreur de connexion: ${e.message}");
      return {
        'status_code': 500,
        'message': 'Erreur de connexion lors de la suppression du type: ${e.message}',
      };
    } catch (e) {
      log("Erreur inattendue lors de la suppression du type: $e");
      return {
        'status_code': 500,
        'message': 'Erreur lors de la suppression du type: $e',
      };
    }
  }
}
