import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

import '../utils/shared_preferences_utils.dart';

class DocumentService {
  static Dio api = ApiConfig.api();

  static Future<Map<String, dynamic>> getAllDocument(int page) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = '$token';
    log("token: $token");
    final response = await api.get("documents",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          'page': page,
          'per_page': 10,
        });
    log("Il a commencé à récupérer les documents");

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("Voici la response de la requête: ${response.data}");
      List<dynamic> allDocumentMap = response.data['data'];
      log("Il a récupéré les documents: $allDocumentMap");
      return {
        // allDocumentMap
        //   .map((documentMap) =>
        //       DocumentsModel.fromJson(documentMap as Map<String, dynamic>))
        //   .toList();
        'status_code': response.data['status_code'],
        'data': response.data['data'], // Liste des documents
        'current_page': response.data['current_page'], // Page actuelle
        'last_page': response.data['last_page'], // Dernière page
      };
    } else {
      throw Exception("Echec lors de la recuperation des articles");
    }
  }

  static Future<Map<String, dynamic>> filterDocuments({
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
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    
    // Préparer le body de la requête en excluant les valeurs null ou vides
    final Map<String, dynamic> requestBody = {};
    
    if (identifier != null && identifier.isNotEmpty) {
      requestBody['identifier'] = identifier;
    }
    if (typeName != null && typeName.isNotEmpty) {
      requestBody['type_name'] = typeName;
    }
    if (typeId != null) {
      requestBody['type_id'] = typeId;
    }
    if (search != null && search.isNotEmpty) {
      requestBody['search'] = search;
    }
    if (dateInformationStart != null && dateInformationStart.isNotEmpty) {
      requestBody['date_information_start'] = dateInformationStart;
    }
    if (dateInformationEnd != null && dateInformationEnd.isNotEmpty) {
      requestBody['date_information_end'] = dateInformationEnd;
    }
    if (createdStart != null && createdStart.isNotEmpty) {
      requestBody['created_start'] = createdStart;
    }
    if (createdEnd != null && createdEnd.isNotEmpty) {
      requestBody['created_end'] = createdEnd;
    }
    
    // Toujours inclure la pagination
    requestBody['page'] = page;
    requestBody['per_page'] = perPage;
    
    log("Filtrage des documents avec les paramètres: $requestBody");

    try {
      final response = await api.post(
        "documents/filter",
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      log("Réponse du filtrage: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'status_code': response.data['status_code'] ?? 200,
          'message': response.data['message'] ?? 'Documents filtrés avec succès',
          'data': response.data['data'] ?? [],
          'current_page': response.data['current_page'] ?? 1,
          'last_page': response.data['last_page'] ?? 1,
          'total': response.data['total'] ?? 0,
          'filters_applied': response.data['filters_applied'] ?? {},
        };
      } else {
        throw Exception("Échec lors du filtrage des documents");
      }
    } catch (e) {
      log("Erreur lors du filtrage des documents: $e");
      throw Exception("Erreur lors du filtrage des documents: $e");
    }
  }

  static Future<Map<String, dynamic>> addDocument(DocumentsModel documentsModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';
    log("il est la?? ${documentsModel.toJson()}");
    final response = await api.post("/documents/add", data: documentsModel.toJson());
    log("Il a commencé à ajouter un document");
    log("$response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'] ?? "Document ajouté avec succès",
        'data': response.data['data'] ?? {},
      };
    } else {
      log("${response.statusCode}");
      log("la response du backend $response");
      throw Exception("Echec lors de l'ajout d'un document");
    }
  }
  static Future<Map<String, dynamic>> addListDocuments(List<DocumentsModel> documentsList) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    // Transformation en liste de JSON
    final documentsJsonList = documentsList.map((doc) => doc.toJson()).toList();

    log("Données envoyées : $documentsJsonList");

    try {
      final response = await api.post(
        "/documents/create",
        data: {
          'documents': documentsJsonList,
        },
      );

      log("Réponse du backend : $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': response.data['success'] ?? [],
          'failed': response.data['failed'] ?? [],
          'csv_recap': response.data['csv_recap'], // URL du rapport CSV (ancien format)
          'excel_recap': response.data['excel_recap'], // URL du rapport Excel (nouveau format)
        };
      } else {
        log("Erreur HTTP ${response.statusCode}");
        throw Exception("Échec de l'ajout des documents");
      }
    } catch (e) {
      log("Exception lors de l'envoi des documents : $e");
      throw Exception("Erreur lors de l'envoi des documents : $e");
    }
  }

  static Future<Map<String, dynamic>> uploadDocumentWithFile(
    String identifier,
    Uint8List pdfBytes, {
    String filename = 'document.pdf',
  }) async {
    try {
      final formData = FormData.fromMap({
        'identifiers': identifier,
        'files': MultipartFile.fromBytes(
          pdfBytes,
          filename: filename,
          contentType: MediaType('application', 'pdf'),
        ),
      });
      final token = SharedPreferencesUtils.getString('auth_token');
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      final response = await api.post(
        '/uploadDocument', // Remplace par ton endpoint complet si nécessaire
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      log("Réponse de upload document: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } catch (e) {
      log("Erreur lors de la création du document : $e");
      return {
        'success': false,
        'message': 'Erreur lors de la création du document : $e',
      };
    }
  }

  static Future<Map<String, dynamic>> uploadExcelFile(
    Uint8List pdfBytes, {
    String filename = 'document.pdf',
  }) async {
    try {
      final formData = FormData.fromMap({
        'excel_file': MultipartFile.fromBytes(
          pdfBytes,
          filename: filename,
          contentType: MediaType('application', 'pdf'),
        ),
      });
      final token = SharedPreferencesUtils.getString('auth_token');
      api.options.headers['AUTHORIZATION'] = 'Bearer $token';
      final response = await api.post(
        '/uploadExcel', // Remplace par ton endpoint complet si nécessaire
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      log("Réponse de upload document: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Erreur inconnue',
        };
      }
    } catch (e) {
      log("Erreur lors de la création du document : $e");
      return {
        'success': false,
        'message': 'Erreur lors de la création du document : $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateDocument(int documentId, DocumentsModel documentsModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final response = await api.put("documents/edit/document/$documentId", data: documentsModel.toJson());
    log("response update :$response");
    log("Il a commencé à mettre à jour un document");
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("${response.data['message']}");
      return {
        'status_code': response.data['status_code'],
        'message': response.data['message'],
      };
    } else {
      throw Exception("Echec lors de la mise à jour d'un document");
    }
  }

  static Future<Map<String, dynamic>> verifyDocument(String? identifier) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    try {
      final response = await api.post("documents/verify-document", data: {'identifier': identifier});
      log('voici la response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Aucun document ne correspond a cet identifiant',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur : $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getDocumentById(int documentId) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    try {
      log("Début de récupération du document ID: $documentId");
      final response = await api.get("/documents/$documentId");

      if (response.statusCode == 200) {
        log("Réponse reçue: ${response.data}");
        return {
          'status_code': response.data['status_code'],
          'message': response.data['message'],
          'data': response.data['data'], // Document récupéré
        };
      } else {
        log("Erreur: ${response.statusCode}");
        throw Exception("Échec lors de la récupération du document");
      }
    } catch (e) {
      log("Exception: $e");
      return {
        'status_code': 404,
        'message': "Document introuvable",
        'error': e.toString(),
      };
    }
  }


  static Future<Map<String, dynamic>> deleteDocument(DocumentsModel documentsModel) async {
    final token = SharedPreferencesUtils.getString('auth_token');
    api.options.headers['AUTHORIZATION'] = 'Bearer $token';

    final documentId = documentsModel.id; // Assure-toi que l'id existe dans ton modèle

    try {
      log("Suppression du document avec l'id: $documentId");

      final response = await api.delete("/documents/$documentId");

      log("Réponse de la suppression: $response");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'status_code': response.data?['status_code'] ?? 200,
          'message': response.data?['message'] ?? "Document supprimé avec succès",
          'data': response.data?['data'] ?? {},
        };
      } else {
        log("Code réponse inattendu: ${response.statusCode}");
        throw Exception("Échec lors de la suppression du document");
      }
    } catch (e) {
      log("Erreur lors de la suppression: $e");
      throw Exception("Erreur lors de la suppression du document: $e");
    }
  }

  // Méthode pour télécharger automatiquement le rapport CSV
  static Future<void> downloadCsvReport(String csvUrl) async {
    try {
      log("Téléchargement du rapport CSV depuis: $csvUrl");
      
      if (kIsWeb) {
        // Pour le web, utiliser une approche directe avec le navigateur
        await _downloadCsvWebDirect(csvUrl);
      } else {
        // Pour mobile/desktop, télécharger avec Dio
        await _downloadCsvMobile(csvUrl);
      }
      
    } catch (e) {
      log("Erreur lors du téléchargement du rapport CSV: $e");
      throw Exception("Erreur lors du téléchargement du rapport: $e");
    }
  }

  static Future<void> _downloadCsvWebDirect(String csvUrl) async {
    try {
      // Détecter l'extension du fichier (CSV ou Excel)
      String fileName = "rapport_documents";
      if (csvUrl.toLowerCase().contains('.xlsx')) {
        fileName = "rapport_documents.xlsx";
      } else if (csvUrl.toLowerCase().contains('.csv')) {
        fileName = "rapport_documents.csv";
      } else {
        // Extraire le nom du fichier de l'URL si possible
        try {
          final uri = Uri.parse(csvUrl);
          final pathSegments = uri.pathSegments;
          if (pathSegments.isNotEmpty) {
            fileName = pathSegments.last;
          }
        } catch (e) {
          fileName = "rapport_documents.csv";
        }
      }
      
      // Pour le web, créer un lien de téléchargement avec un nom de fichier
      final anchor = html.AnchorElement(href: csvUrl)
        ..setAttribute("download", fileName)
        ..setAttribute("target", "_blank")
        ..click();
      
      log("Rapport téléchargé via lien direct (web): $fileName");
    } catch (e) {
      // Fallback: ouvrir dans un nouvel onglet si le téléchargement direct échoue
      try {
        html.window.open(csvUrl, '_blank');
        log("Rapport ouvert dans un nouvel onglet (fallback)");
      } catch (fallbackError) {
        throw Exception("Erreur lors du téléchargement web: $e, fallback: $fallbackError");
      }
    }
  }

  static Future<void> _downloadCsvMobile(String csvUrl) async {
    try {
      // Pour mobile/desktop, utiliser Dio avec headers spéciaux pour ngrok
      final Dio downloadDio = Dio();
      
      // Détecter l'extension du fichier (CSV ou Excel)
      String fileExtension = ".csv";
      String mimeType = 'text/csv,application/csv,*/*';
      if (csvUrl.toLowerCase().contains('.xlsx')) {
        fileExtension = ".xlsx";
        mimeType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,*/*';
      }
      
      // Extraire le nom du fichier de l'URL si possible
      String fileName = "rapport_documents";
      try {
        final uri = Uri.parse(csvUrl);
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty && pathSegments.last.contains('.')) {
          fileName = pathSegments.last;
          fileExtension = fileName.substring(fileName.lastIndexOf('.'));
        }
      } catch (e) {
        // Utiliser l'extension par défaut
      }
      
      // Headers pour contourner les restrictions ngrok
      downloadDio.options.headers.addAll({
        'ngrok-skip-browser-warning': 'true',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': mimeType,
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
      });
      
      final response = await downloadDio.get(
        csvUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500, // Accepter les redirections
        ),
      );
      
      if (response.statusCode == 403) {
        throw Exception("Accès refusé (403) - Vérifiez que l'URL ngrok est accessible");
      }
      
      final Uint8List bytes = Uint8List.fromList(response.data);
      
      // Obtenir le répertoire de téléchargement
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Impossible d'accéder au répertoire de téléchargement");
      }
      
      // Créer le fichier avec le bon nom et extension
      final String uniqueFileName = fileName.contains('.') 
          ? '${fileName.split('.').first}_${DateTime.now().millisecondsSinceEpoch}${fileExtension}'
          : 'rapport_documents_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final File file = File('${downloadsDir.path}/$uniqueFileName');
      await file.writeAsBytes(bytes);
      
      log("Rapport téléchargé avec succès (mobile): ${file.path}");
    } catch (e) {
      log("Erreur détaillée du téléchargement mobile: $e");
      throw Exception("Erreur lors du téléchargement mobile: $e");
    }
  }

}
