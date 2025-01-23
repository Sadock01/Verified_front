import 'dart:developer';

import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/services/document_service.dart';

class DocumentRepository {
   Future<List<DocumentsModel>> getAllDocument(int page) async {
    try {
      log("Appel au service pour récupérer les documents à la page $page");
      final documents = await DocumentService.getAllDocument(page);
      log("Nombre de documents récupérés: ${documents.length}");
      return documents;
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération des documents");
    }
  }

  Future<void> addDocument(DocumentsModel documentsModel) async {
    try {
      log("Appel au service pour ajouter un document");
      await DocumentService.addDocument(documentsModel);
      log("Document ajouté");
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de l'ajout du document");
    }
  }

  Future<void> updateDocument(DocumentsModel documentsModel) async {
    try {
      log("Appel au service pour mettre à jour un document");
      await DocumentService.updateDocument(documentsModel);
      log("Document mis à jour");
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la mise à jour du document");
    }
  }
}
