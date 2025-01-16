import 'package:doc_authentificator/models/documents_model.dart';
import 'package:equatable/equatable.dart';

enum DocumentStatus {
  initial,
  loading,
  loaded,
  error,
}

class DocumentState extends Equatable {
  final DocumentStatus documentStatus;
  final List<DocumentsModel> listDocuments;
  final String errorMessage;
  // int? offset;
  // final String? searchKey;
  const DocumentState({
    required this.documentStatus,
    required this.listDocuments,
    required this.errorMessage,
    // this.searchKey,
  });

  factory DocumentState.initial() {
    return DocumentState(
      documentStatus: DocumentStatus.initial,
      listDocuments: [],
      errorMessage: "",
    );
  }

  DocumentState copyWith({
    DocumentStatus? documentStatus,
    List<DocumentsModel>? listDocuments,
    String? errorMessage,
    // int? offset,
    // String? searchKey,
  }) {
    return DocumentState(
      documentStatus: documentStatus ?? this.documentStatus,
      listDocuments: listDocuments ?? this.listDocuments,
      errorMessage: errorMessage ?? this.errorMessage,
      // offset: offset ?? this.offset,
      // searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        documentStatus,
        listDocuments,
        errorMessage,
      ];
}
