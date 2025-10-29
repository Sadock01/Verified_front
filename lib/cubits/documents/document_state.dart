import 'package:doc_authentificator/models/documents_model.dart';
import 'package:equatable/equatable.dart';

enum DocumentStatus {
  initial,
  loading,
  loaded,
sucess,
failed,
  error,
}

class DocumentState extends Equatable {
  final DocumentStatus documentStatus;
  final DocumentStatus documentStatus1;
  final List<DocumentsModel> listDocuments;
  final String? apiResponse;
  final DocumentsModel? selectedDocument;
  final int currentPage;
  final int lastPage;
  final int itemsPerPage;
  final String? searchKey;
  final String errorMessage;
  
  // Filtres actifs
  final String? filterIdentifier;
  final String? filterTypeName;
  final int? filterTypeId;
  final String? filterSearch;
  final String? filterDateInformationStart;
  final String? filterDateInformationEnd;
  final String? filterCreatedStart;
  final String? filterCreatedEnd;
  final bool hasActiveFilters;

  const DocumentState({
    required this.documentStatus,
    required this.documentStatus1,
    required this.listDocuments,
    required this.errorMessage,
    required this.apiResponse,
    required this.currentPage,
    required this.lastPage,
    required this.itemsPerPage,
    this.selectedDocument,
    required this.searchKey,
    this.filterIdentifier,
    this.filterTypeName,
    this.filterTypeId,
    this.filterSearch,
    this.filterDateInformationStart,
    this.filterDateInformationEnd,
    this.filterCreatedStart,
    this.filterCreatedEnd,
    this.hasActiveFilters = false,
  });

  factory DocumentState.initial() {
    return DocumentState(
      documentStatus: DocumentStatus.initial,
      documentStatus1: DocumentStatus.initial,
      listDocuments: [],
      selectedDocument: null,
      currentPage: 1,
      lastPage: 1,
      itemsPerPage: 5, // Par défaut 5 éléments par page
      errorMessage: "",
      apiResponse: '',
      searchKey: '',
      hasActiveFilters: false,
    );
  }

  DocumentState copyWith({
    DocumentStatus? documentStatus,
    DocumentStatus? documentStatus1,
    List<DocumentsModel>? listDocuments,
    String? apiresponse,
    DocumentsModel? selectedDocument,
    int? currentPage,
    int? lastPage,
    int? itemsPerPage,
    String? errorMessage,
    String? searchKey,
    String? filterIdentifier,
    String? filterTypeName,
    int? filterTypeId,
    String? filterSearch,
    String? filterDateInformationStart,
    String? filterDateInformationEnd,
    String? filterCreatedStart,
    String? filterCreatedEnd,
    bool? hasActiveFilters,
  }) {
    // Déterminer les valeurs finales des filtres
    final String? finalIdentifier = filterIdentifier ?? this.filterIdentifier;
    final String? finalTypeName = filterTypeName ?? this.filterTypeName;
    final int? finalTypeId = filterTypeId ?? this.filterTypeId;
    final String? finalSearch = filterSearch ?? this.filterSearch;
    final String? finalDateInfoStart = filterDateInformationStart ?? this.filterDateInformationStart;
    final String? finalDateInfoEnd = filterDateInformationEnd ?? this.filterDateInformationEnd;
    final String? finalCreatedStart = filterCreatedStart ?? this.filterCreatedStart;
    final String? finalCreatedEnd = filterCreatedEnd ?? this.filterCreatedEnd;
    
    // Calculer hasActiveFilters si non spécifié
    final bool activeFilters = hasActiveFilters ?? 
      ((finalIdentifier != null && finalIdentifier.isNotEmpty) ||
       (finalTypeName != null && finalTypeName.isNotEmpty) ||
       finalTypeId != null ||
       (finalSearch != null && finalSearch.isNotEmpty) ||
       (finalDateInfoStart != null && finalDateInfoStart.isNotEmpty) ||
       (finalDateInfoEnd != null && finalDateInfoEnd.isNotEmpty) ||
       (finalCreatedStart != null && finalCreatedStart.isNotEmpty) ||
       (finalCreatedEnd != null && finalCreatedEnd.isNotEmpty));
    
    return DocumentState(
      documentStatus: documentStatus ?? this.documentStatus,
      documentStatus1: documentStatus1 ?? this.documentStatus1,
      listDocuments: listDocuments ?? this.listDocuments,
      apiResponse: apiresponse ?? this.apiResponse,
      selectedDocument: selectedDocument ?? this.selectedDocument,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      searchKey: searchKey ?? this.searchKey,
      filterIdentifier: finalIdentifier,
      filterTypeName: finalTypeName,
      filterTypeId: finalTypeId,
      filterSearch: finalSearch,
      filterDateInformationStart: finalDateInfoStart,
      filterDateInformationEnd: finalDateInfoEnd,
      filterCreatedStart: finalCreatedStart,
      filterCreatedEnd: finalCreatedEnd,
      hasActiveFilters: activeFilters,
    );
  }
  
  // Méthode pour réinitialiser tous les filtres
  DocumentState clearFilters() {
    return copyWith(
      filterIdentifier: null,
      filterTypeName: null,
      filterTypeId: null,
      filterSearch: null,
      filterDateInformationStart: null,
      filterDateInformationEnd: null,
      filterCreatedStart: null,
      filterCreatedEnd: null,
      hasActiveFilters: false,
      currentPage: 1,
    );
  }

  @override
  List<Object?> get props => [
        documentStatus,
        listDocuments,
        selectedDocument,
        currentPage,
        lastPage,
        itemsPerPage,
        errorMessage,
        searchKey,
        filterIdentifier,
        filterTypeName,
        filterTypeId,
        filterSearch,
        filterDateInformationStart,
        filterDateInformationEnd,
        filterCreatedStart,
        filterCreatedEnd,
        hasActiveFilters,
      ];
}
