import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/documents_model.dart';

class DocumentService {
  static Dio api = ApiConfig.api();
  static Future<List<DocumentsModel>> getAllDocument(int page) async {
    api.options.headers['AUTHORIZATION'] = '7|3JtLwLxvJtkVlnRvTgKln1XZIXHPNRP8mhlF42Mt32d8c745';
    final response =
        await api.get("documents", queryParameters: {"page": page});
    log("Il a commencé à récupérer les documents");
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> allDocumentMap = response.data['data'];
      log("Il a récupéré les documents: $allDocumentMap");
      return allDocumentMap.map((docucumentMap) => DocumentsModel.fromJson(docucumentMap as Map<String,dynamic>)).toList();
    } else {
      throw Exception("Echec lors de la recuperation des articles");
    }
  }
}
