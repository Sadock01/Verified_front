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
  }) {
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
      ];
}
