import 'dart:developer';

import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/services/document_service.dart';

class DocumentRepository {
  Future<Map<String, dynamic>> getAllDocument(int page) async {
    try {
      log("Appel au service pour récupérer les documents à la page ");
      final response = await DocumentService.getAllDocument(page);
      if (response['status_code'] == 200) {
          log("Réponse réussie pour la page $page : ${response['data']}");
        return {'data': response['data'], 'last_page': response['last_page'],};
      } else {
      log("Erreur : Code de statut inattendu ${response['status_code']}");
      throw Exception("Erreur lors de la récupération des documents : ${response['message']}");
    }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération des documents");
    }
  }

  Future<Map<String, dynamic>> addDocument(
      DocumentsModel documentsModel) async {
    try {
      log("Appel au service pour ajouter un document");
      final response = await DocumentService.addDocument(documentsModel);
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

  Future<void> updateDocument(int documentId,DocumentsModel documentsModel) async {
    try {
      log("Appel au service pour mettre à jour un document");
      await DocumentService.updateDocument(documentId,documentsModel);
      log("Document mis à jour");
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la mise à jour du document");
    }
  }

  Future<Map<String, dynamic>> verifyDocument(String identifier) async {
    try {
      final response = await DocumentService.verifyDocument(identifier);

      // Retourner directement la réponse du service
      if (response['success']) {
        return {
          'success': true,
          'data': response['data']['data'],
        };
      } else {
        return {
          'success': false,
          'message': response['message'], // Message d'erreur
        };
      }
    } catch (e) {
      // Gérer les exceptions et retourner un message d'erreur formaté
      return {
        'success': false,
        'message': 'Une erreur est survenue : $e',
      };
    }
  }
}
