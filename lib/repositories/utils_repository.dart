import 'dart:developer';

import 'package:doc_authentificator/services/utils_services.dart';

class UtilsRepository {
  Future<Map<String, dynamic>> statistiquesByDays() async {
    try {
      log("Appel au service pour récupérer les stats ");
      final response = await UtilsServices.statistiquesByDays();
      if (response['status_code'] == 200) {
        return {
          'status_code': response['status_code'],
          'data': response['data']
        };
      } else {
        log("Erreur : Code de statut inattendu ${response['status_code']}");
        throw Exception("Erreur lors de la récupération des stats");
      }
    } catch (e) {
      log("Erreur dans UtilsRepositoryRepository: $e");
      throw Exception("Erreur lors de la récupération des stats");
    }
  }

  Future<Map<String, dynamic>> totalVerifications() async {
    try {
      log("Appel au service pour récupérer les stats ");
      final response = await UtilsServices.totalVerifications();
      if (response['success'] == true) {
        return {
          'total_verifications': response['total_verifications'],
        };
      } else {
        log("Erreur : Code de statut inattendu ${response['success']}");
        throw Exception("Erreur lors de la récupération des stats");
      }
    } catch (e) {
      log("Erreur dans UtilsRepositoryRepository: $e");
      throw Exception("Erreur lors de la récupération des stats");
    }
  }

  Future<Map<String, dynamic>> totalDocuments() async {
    try {
      log("Appel au service pour récupérer les stats ");
      final response = await UtilsServices.totalDocuments();
      if (response['success'] == true) {
        return {
          'success': response['success'],
          'total_documents': response['total_documents'],
        };
      } else {
        log("Erreur : Code de statut inattendu ${response['success']}");
        throw Exception("Erreur lors de la récupération des stats");
      }
    } catch (e) {
      log("Erreur dans UtilsRepositoryRepository: $e");
      throw Exception("Erreur lors de la récupération des stats");
    }
  }

  Future<List<Map<String, dynamic>>> statistiquesByVerificationStatus() async {
    try {
      log("Appel au service pour récupérer les stats ");
      final response = await UtilsServices.statistiquesByVerificationStatus();

      if (response['status_code'] == 200) {
        final Map<String, dynamic> data = response;
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception("Erreur lors de la récupération des statistiques.");
      }
    } catch (e) {
      log("Erreur: $e");
      throw Exception("Erreur lors de la récupération des statistiques.");
    }
  }
}
