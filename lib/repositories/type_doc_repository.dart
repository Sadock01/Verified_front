import 'dart:developer';

import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:doc_authentificator/services/type_service.dart';

class TypeDocRepository {
  Future<List<TypeDocModel>> getAllType(int page) async {
    try {
      log("Appel au service pour récupérer les types à la page $page");
      final types = await TypeService.getAllType();
      log("Nombre de types récupérés: ${types.length}");
      return types;
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération des types");
    }
  }

 Future<Map<String, dynamic>> addType(
     TypeDocModel typeDocModel) async {
    try {
      log("Appel au service pour ajouter un document");
      final response = await TypeService.addType(typeDocModel);
      if (response['status_code'] == 200) {
        log("voici ma response: ${response['message']}");
        return {
          'message': response['message'],
          'data': response['data'],
        };
      } else {
        return {
          'message': response['message'],
          'status_code': response['status_code'],
        };
      }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de l'ajout du document");
    }
  }
}