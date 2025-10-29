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
        return {
          'data': response['data'],
          'last_page': response['last_page'],
        };
      } else {
        log("Erreur : Code de statut inattendu ${response['status_code']}");
        throw Exception(
            "Erreur lors de la récupération des documents : ${response['message']}");
      }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération des documents");
    }
  }

  Future<Map<String, dynamic>> filterDocuments({
    String? identifier,
    String? typeName,
    int? typeId,
    String? search,
    String? dateInformationStart,
    String? dateInformationEnd,
    String? createdStart,
    String? createdEnd,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      log("Appel au service pour filtrer les documents");
      final response = await DocumentService.filterDocuments(
        identifier: identifier,
        typeName: typeName,
        typeId: typeId,
        search: search,
        dateInformationStart: dateInformationStart,
        dateInformationEnd: dateInformationEnd,
        createdStart: createdStart,
        createdEnd: createdEnd,
        page: page,
        perPage: perPage,
      );
      
      if (response['status_code'] == 200) {
        log("Filtrage réussi : ${response['data'].length} documents trouvés");
        return {
          'status_code': response['status_code'],
          'data': response['data'],
          'current_page': response['current_page'],
          'last_page': response['last_page'],
          'total': response['total'],
          'filters_applied': response['filters_applied'],
        };
      } else {
        throw Exception("Échec du filtrage : ${response['message']}");
      }
    } catch (e) {
      log("Erreur dans DocumentRepository lors du filtrage: $e");
      throw Exception("Erreur lors du filtrage des documents: $e");
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
          'status_code': response['status_code'],
          'message': response['message'],
          'data': response['data'],
        };
      } else {
        return {
          'status_code': response['status_code'],
          'message': response['message'],
          
        };
      }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de l'ajout du document");
    }
  }

  Future<Map<String, dynamic>> addDocuments(List<DocumentsModel> documentsList) async {
    try {
      final response = await DocumentService.addListDocuments(documentsList);

      return {
        'status_code': 200,
        'message': 'Documents ajoutés avec succès',
        'csv_recap': response['csv_recap'], // Passer l'URL du CSV (ancien format)
        'excel_recap': response['excel_recap'], // Passer l'URL du Excel (nouveau format)
      };
    } catch (e) {
      return {
        'status_code': 500,
        'message': "Échec de l'ajout des documents : $e",
      };
    }
  }



  Future<Map<String, dynamic>> updateDocument(
      int documentId, DocumentsModel documentsModel) async {
    try {
      log("Appel au service pour mettre à jour un document");

      final response =
          await DocumentService.updateDocument(documentId, documentsModel);
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

  Future<Map<String, dynamic>> getDocumentById(int documentId) async {
    try {
      log("Appel au service pour récupérer le document ID: $documentId");
      final response = await DocumentService.getDocumentById(documentId);

      if (response['status_code'] == 200) {
        log("Document récupéré avec succès: ${response['data']}");
        return {
          'data': response['data'],
          'message': response['message'],
        };
      } else {
        log("Erreur: Code de statut inattendu ${response['status_code']}");
        throw Exception(
            "Erreur lors de la récupération du document: ${response['message']}");
      }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération du document");
    }
  }
}
