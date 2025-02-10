import 'dart:developer';

import 'package:doc_authentificator/services/collaborateur_service.dart';

class CollaborateurRepository {
  Future<Map<String, dynamic>> getAllCollaborateur(int page) async {
    try {
      log("Appel au service pour récupérer les documents à la page ");
      final response = await CollaborateurService.getAllCollaborateur(page);
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
      throw Exception("Erreur lors de la récupération des collaborateurs");
    }
  }

}