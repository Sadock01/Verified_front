import 'package:doc_authentificator/models/documents_model.dart';
import 'package:equatable/equatable.dart';

enum DocumentStatus {
  initial,
  loading,
  loaded,
sucess,
  error,
}

class DocumentState extends Equatable {
  final DocumentStatus documentStatus;
  final List<DocumentsModel> listDocuments;
  final String? apiResponse;
  final DocumentsModel? selectedDocument;
  final int currentPage;
  final int lastPage;
  final String? searchKey;
  final String errorMessage;


  const DocumentState({
    required this.documentStatus,
    required this.listDocuments,
    required this.errorMessage,
    required this.apiResponse,
    required this.currentPage,
    required this.lastPage,
    this.selectedDocument,
    required this.searchKey,
  });

  factory DocumentState.initial() {
    return DocumentState(
      documentStatus: DocumentStatus.initial,
      listDocuments: [],
      selectedDocument: null,
      currentPage: 1,
      lastPage: 1,
      errorMessage: "",
      apiResponse: '',
      searchKey: '',
    );
  }

  DocumentState copyWith({
    DocumentStatus? documentStatus,
    List<DocumentsModel>? listDocuments,
    String? apiresponse,
    DocumentsModel? selectedDocument,
    int? currentPage,
    int? lastPage,
    String? errorMessage,
    String? searchKey,
  }) {
    return DocumentState(
      documentStatus: documentStatus ?? this.documentStatus,
      listDocuments: listDocuments ?? this.listDocuments,
      apiResponse: apiresponse ?? this.apiResponse,
      selectedDocument: selectedDocument ?? this.selectedDocument,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
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
        errorMessage,
        searchKey,
      ];
}
