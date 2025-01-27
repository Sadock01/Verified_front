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
  final String apiResponse;
  final int currentPage;
  final int lastPage;
  final String errorMessage;

  // final String? searchKey;
  const DocumentState(
     {
    required this.documentStatus,
    required this.listDocuments,
    required this.errorMessage,
    required this.apiResponse,
    required this.currentPage,
    required this.lastPage,
    // required this.currentPage,
    // required this.totalPage,
    // this.searchKey,
  });

  factory DocumentState.initial() {
    return DocumentState(
      documentStatus: DocumentStatus.initial,
      listDocuments: [],
      currentPage: 1,
      lastPage: 1,
      errorMessage: "",
      apiResponse: '',
    );
  }

  DocumentState copyWith({
    DocumentStatus? documentStatus,
    List<DocumentsModel>? listDocuments,
    String? apiresponse,
    int? currentPage,
    int? lastPage,
    String? errorMessage,

    // String? searchKey,
  }) {
    return DocumentState(
      documentStatus: documentStatus ?? this.documentStatus,
      listDocuments: listDocuments ?? this.listDocuments,
      apiResponse: apiresponse ?? this.apiResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      // searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        documentStatus,
        listDocuments,
        // currentPage,
        // totalPage,
        errorMessage,
      ];
}
