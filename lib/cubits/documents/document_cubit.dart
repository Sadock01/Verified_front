import 'dart:developer';

import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/repositories/document_repository.dart';
import 'package:doc_authentificator/services/document_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository documentRepository;
  DocumentCubit({
    required this.documentRepository,
  }) : super(DocumentState.initial()) {}

  Future<void> getAllDocument(int page) async {
    try {
      emit(state.copyWith(
        documentStatus: DocumentStatus.loading,
        errorMessage: "",
        currentPage: page,
        // Réinitialiser les filtres quand on charge tous les documents
        filterIdentifier: null,
        filterTypeName: null,
        filterTypeId: null,
        filterSearch: null,
        filterDateInformationStart: null,
        filterDateInformationEnd: null,
        filterCreatedStart: null,
        filterCreatedEnd: null,
        hasActiveFilters: false,
      ));
      final response = await documentRepository.getAllDocument(page);
      final List<DocumentsModel> documents = (response['data'] as List)
          .map((doc) => DocumentsModel.fromJson(doc))
          .toList();
      emit(state.copyWith(
        documentStatus: DocumentStatus.loaded,
        listDocuments: documents,
        currentPage: page,
        lastPage: response['last_page'],
        errorMessage: "",
        hasActiveFilters: false,
      ));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  Future<void> addDocument(DocumentsModel documentsModel) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      final response = await documentRepository.addDocument(documentsModel);
      log("${response['status_code']}");
      if (response['status_code'] == 200) {
        log("État actuel: ${state.documentStatus}");
        emit(state.copyWith(
          documentStatus: DocumentStatus.sucess,
          errorMessage: response['message'],
        ));
        log("voici ma response: ${response['message']}");
      }else {
         emit(state.copyWith(
          documentStatus: DocumentStatus.error,
          errorMessage: response['message'],
        ));
        log("voici ma response: ${response['message']}");
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  Future<void> addDocuments(List<DocumentsModel> documentsList) async {
    try {
      emit(state.copyWith(
        documentStatus: DocumentStatus.loading,
        errorMessage: "",
      ));

      final response = await documentRepository.addDocuments(documentsList);

      if (response['status_code'] == 200) {
        // Télécharger automatiquement le rapport Excel/CSV si disponible
        String? reportUrl;
        if (response['excel_recap'] != null && response['excel_recap'].toString().isNotEmpty) {
          reportUrl = response['excel_recap'];
          log("Rapport Excel détecté: $reportUrl");
        } else if (response['csv_recap'] != null && response['csv_recap'].toString().isNotEmpty) {
          reportUrl = response['csv_recap'];
          log("Rapport CSV détecté: $reportUrl");
        }
        
        if (reportUrl != null && reportUrl.isNotEmpty) {
          try {
            await DocumentService.downloadCsvReport(reportUrl);
            log("Rapport téléchargé automatiquement: $reportUrl");
          } catch (e) {
            log("Erreur lors du téléchargement du rapport: $e");
            // Ne pas faire échouer l'opération principale si le téléchargement échoue
          }
        }
        
        emit(state.copyWith(
          documentStatus: DocumentStatus.sucess,
          errorMessage: response['message'] ?? 'Documents ajoutés et rapport téléchargé.',
        ));
      } else {
        emit(state.copyWith(
          documentStatus: DocumentStatus.error,
          errorMessage: response['message'] ?? "Erreur lors de l'ajout.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        documentStatus: DocumentStatus.error,
        errorMessage: "Erreur : $e",
      ));
    }
  }


  Future<void> updateDocument(
      int documentId, DocumentsModel documentsModel) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      final response =
          await documentRepository.updateDocument(documentId, documentsModel);
      log("${response['message']}");
     if (response['status_code'] == 200) {
       emit(state.copyWith(
          documentStatus: DocumentStatus.sucess,
          errorMessage: response['message'])); 
     }
     
    } catch (e) {
 
      emit(state.copyWith(
          errorMessage: e.toString(),
          documentStatus: DocumentStatus.error));
    }
  }

  Future<void> verifyDocument(String identifier) async {
    try {
      log("Il fait appel au service pour récupérer la data");
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      final response = await documentRepository.verifyDocument(identifier);

      if (response['success']) {
        emit(state.copyWith(
            documentStatus: DocumentStatus.sucess,
            documentStatus1: DocumentStatus.loaded,
            apiresponse: response['data']['description'].toString(),
            errorMessage: ""));
      } else {
        emit(state.copyWith(
          documentStatus: DocumentStatus.failed,
          errorMessage: response['message'],
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  void goToNextPage() {
    if (state.currentPage < state.lastPage) {
      final nextPage = state.currentPage + 1;
      emit(state.copyWith(currentPage: nextPage));
      
      // Si des filtres sont actifs, utiliser filterDocuments
      if (state.hasActiveFilters) {
        _applyFilters(page: nextPage);
      } else {
        getAllDocument(nextPage);
      }
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 1) {
      final prevPage = state.currentPage - 1;
      emit(state.copyWith(currentPage: prevPage));
      
      // Si des filtres sont actifs, utiliser filterDocuments
      if (state.hasActiveFilters) {
        _applyFilters(page: prevPage);
      } else {
        getAllDocument(prevPage);
      }
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= state.lastPage && page != state.currentPage) {
      emit(state.copyWith(currentPage: page));
      
      // Si des filtres sont actifs, utiliser filterDocuments
      if (state.hasActiveFilters) {
        _applyFilters(page: page);
      } else {
        getAllDocument(page);
      }
    }
  }

 

  Future<void> getDocumentById(int documentId) async {
    try {
      emit(state.copyWith(
        documentStatus: DocumentStatus.loading,
        errorMessage: "",
      ));
      log("Récupération du document avec l'ID: $documentId");

      final response = await documentRepository.getDocumentById(documentId);

      final document = DocumentsModel.fromJson(response['data']);

      emit(state.copyWith(
        documentStatus: DocumentStatus.loaded,
        selectedDocument: document,
        errorMessage: response['message'],
      ));
    } catch (e) {
      emit(state.copyWith(
        documentStatus: DocumentStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

   void setSearchKey(String searchKey) {
    emit(state.copyWith(searchKey: searchKey));
  }

  void setItemsPerPage(int itemsPerPage) {
    emit(state.copyWith(itemsPerPage: itemsPerPage, currentPage: 1));
    
    // Si des filtres sont actifs, utiliser filterDocuments, sinon getAllDocument
    if (state.hasActiveFilters) {
      _applyFilters(page: 1, perPage: itemsPerPage);
    } else {
      getAllDocument(1); // Recharger la première page avec le nouveau nombre d'éléments
    }
  }

  // Méthode pour appliquer les filtres
  void _applyFilters({
    int? page,
    int? perPage,
  }) {
    final currentPage = page ?? state.currentPage;
    final currentPerPage = perPage ?? state.itemsPerPage;
    
    filterDocuments(
      identifier: state.filterIdentifier,
      typeName: state.filterTypeName,
      typeId: state.filterTypeId,
      search: state.filterSearch,
      dateInformationStart: state.filterDateInformationStart,
      dateInformationEnd: state.filterDateInformationEnd,
      createdStart: state.filterCreatedStart,
      createdEnd: state.filterCreatedEnd,
      page: currentPage,
      perPage: currentPerPage,
    );
  }

  // Méthode publique pour filtrer les documents
  Future<void> filterDocuments({
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
      emit(state.copyWith(
        documentStatus: DocumentStatus.loading,
        errorMessage: "",
        currentPage: page,
      ));

      final response = await documentRepository.filterDocuments(
        identifier: identifier?.isEmpty == true ? null : identifier,
        typeName: typeName?.isEmpty == true ? null : typeName,
        typeId: typeId,
        search: search?.isEmpty == true ? null : search,
        dateInformationStart: dateInformationStart?.isEmpty == true ? null : dateInformationStart,
        dateInformationEnd: dateInformationEnd?.isEmpty == true ? null : dateInformationEnd,
        createdStart: createdStart?.isEmpty == true ? null : createdStart,
        createdEnd: createdEnd?.isEmpty == true ? null : createdEnd,
        page: page,
        perPage: perPage,
      );

      if (response['status_code'] == 200) {
        final List<dynamic> documentsData = response['data'];
        final List<DocumentsModel> documents = documentsData
            .map((doc) => DocumentsModel.fromJson(doc as Map<String, dynamic>))
            .toList();

        // Mettre à jour l'état avec les filtres actifs
        emit(state.copyWith(
          documentStatus: DocumentStatus.loaded,
          listDocuments: documents,
          currentPage: response['current_page'] ?? page,
          lastPage: response['last_page'] ?? 1,
          itemsPerPage: perPage,
          errorMessage: "",
          filterIdentifier: identifier?.isEmpty == true ? null : identifier,
          filterTypeName: typeName?.isEmpty == true ? null : typeName,
          filterTypeId: typeId,
          filterSearch: search?.isEmpty == true ? null : search,
          filterDateInformationStart: dateInformationStart?.isEmpty == true ? null : dateInformationStart,
          filterDateInformationEnd: dateInformationEnd?.isEmpty == true ? null : dateInformationEnd,
          filterCreatedStart: createdStart?.isEmpty == true ? null : createdStart,
          filterCreatedEnd: createdEnd?.isEmpty == true ? null : createdEnd,
        ));
      } else {
        emit(state.copyWith(
          documentStatus: DocumentStatus.error,
          errorMessage: response['message'] ?? 'Erreur lors du filtrage',
        ));
      }
    } catch (e) {
      log("Erreur lors du filtrage: $e");
      emit(state.copyWith(
        documentStatus: DocumentStatus.error,
        errorMessage: 'Erreur lors du filtrage: $e',
      ));
    }
  }

  // Méthode pour réinitialiser les filtres
  void clearFilters() {
    emit(state.clearFilters());
    getAllDocument(1);
  }

  // Méthode pour mettre à jour un filtre spécifique
  void updateFilter({
    String? identifier,
    String? typeName,
    int? typeId,
    String? search,
    String? dateInformationStart,
    String? dateInformationEnd,
    String? createdStart,
    String? createdEnd,
  }) {
    // Appliquer immédiatement les filtres avec les nouvelles valeurs
    filterDocuments(
      identifier: identifier,
      typeName: typeName,
      typeId: typeId,
      search: search,
      dateInformationStart: dateInformationStart,
      dateInformationEnd: dateInformationEnd,
      createdStart: createdStart,
      createdEnd: createdEnd,
      page: 1, // Réinitialiser à la page 1 lors d'un changement de filtre
      perPage: state.itemsPerPage,
    );
  }

  void statisticsByDays(){
    emit(state.copyWith(
        documentStatus: DocumentStatus.loading,
        errorMessage: "",
      ));
      log("Récupération des stats");
  }
}
