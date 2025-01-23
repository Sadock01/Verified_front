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

}