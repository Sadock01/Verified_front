import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';

import '../utils/shared_preferences_utils.dart';

class TypeService {
  static Dio api = ApiConfig.api();

  static Future<List<TypeDocModel>> getAllType() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] =
        'Bearer $token';
    final response = await api.get("types", queryParameters: {"page": 1});
    log("Il a commencé à récupérer les types");
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> allTypeMap = response.data['data'];
      // final int currentPage = response.data['current_page'];
      // final int totalPages = response.data['last_page'];
      return allTypeMap
          .map((typeMap) =>
              TypeDocModel.fromJson(typeMap as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Echec lors de la recuperation des articles");
    }
  }

  static Future<Map<String, dynamic>> addType(TypeDocModel typeDocModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] =
        'Bearer $token';
    log("il est la?? ${typeDocModel.toJson()}");
    final response =
        await api.post("/types/create", data: typeDocModel.toJson());
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
}
