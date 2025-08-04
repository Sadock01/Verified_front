import 'dart:developer';

import 'package:doc_authentificator/services/report_service.dart';

class ReportRepository {
  Future<Map<String, dynamic>> getAllReports(int page) async {
    try {
      log("Appel au service pour récupérer les documents à la page $page");
      final response = await ReportService.getAllReports(page);

      if (response['status_code'] == 200) {
        log("Les rapports sont ici");
        log("Réponse réussie pour la page $page : ${response['data']}");

        return {
          'data': response['data'], // Liste des objets ReportModel
          'last_page': response['last_page'], // Dernière page
        };
      } else {
        log("Erreur : Code de statut inattendu ${response['status_code']}");
        throw Exception("Erreur lors de la récupération des documents : ${response['message']}");
      }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération des documents");
    }
  }

  Future<Map<String, dynamic>> getAllDocReport(int documentId, int page) async {
    try {
      log("Appel au service pour récupérer le rapport du document $documentId");
      final response = await ReportService.getAllDocumentReport(documentId, page);

      if (response['status_code'] == 200) {
        log("Les rapports sont ici");
        log("Réponse réussie pour la page $page : ${response['data']}");

        return {
          'data': response['data'], // Liste des objets ReportModel
          'last_page': response['last_page'], // Dernière page
        };
      } else {
        log("Erreur : Code de statut inattendu ${response['status_code']}");
        throw Exception("Erreur lors de la récupération des documents : ${response['message']}");
      }
    } catch (e) {
      log("Erreur dans DocumentRepository: $e");
      throw Exception("Erreur lors de la récupération des documents");
    }
  }
}
