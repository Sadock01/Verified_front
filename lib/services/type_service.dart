import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';

class TypeService {
  static Dio api = ApiConfig.api();

  static Future<List<TypeDocModel>> getAllType() async {
    api.options.headers['AUTHORIZATION'] =
        'Bearer 7|3JtLwLxvJtkVlnRvTgKln1XZIXHPNRP8mhlF42Mt32d8c745';
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
}
