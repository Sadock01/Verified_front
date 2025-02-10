import 'dart:developer';

import 'package:doc_authentificator/services/verification_service.dart';

class VerificationRepository {
  Future<Map<String, dynamic>> getAllVerification(int page) async {
    try {
      log("Appel au service pour récupérer les documents à la page ");
      final response = await VerificationService.getAllVerification(page);
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
}
