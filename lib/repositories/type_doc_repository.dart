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

  static Future<Map<String, dynamic>> updateType(
      int typeId, TypeDocModel typeModel) async {
    try {
      log("Appel au service pour mettre à jour un type");

      final response =
      await TypeService.updateType(typeId, typeModel);
      log("$response");
      return {
        'status_code':response['status_code'],
        'message': response['message'],
      };
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la mise à jour du document");
    }
  }

  Future<Map<String, dynamic>> deleteType(int typeId) async {
    try {
      log("Appel au service pour supprimer un type");
      final response = await TypeService.deleteType(typeId);
      log("Réponse de suppression du repository: $response");
      
      // Retourner directement la réponse du service (déjà formatée)
      return {
        'status_code': response['status_code'] ?? 500,
        'message': response['message'] ?? 'Erreur lors de la suppression du type',
        'nombre_documents': response['nombre_documents'], // Pour le cas 409
      };
    } catch (e) {
      log("Erreur dans TypeDocRepository: $e");
      return {
        'status_code': 500,
        'message': 'Erreur lors de la suppression du type: $e',
        'nombre_documents': null,
      };
    }
  }
}