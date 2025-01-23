import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/repositories/document_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository documentRepository;
  DocumentCubit({
    required this.documentRepository,
  }) : super(DocumentState.initial()) {}

  Future<void> getAllDocument(int page) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      final List<DocumentsModel> documents =
          await documentRepository.getAllDocument(page);
            // final int totalPages = response['last_page'];
      emit(state.copyWith(
          documentStatus: DocumentStatus.loaded,
          listDocuments: documents,currentPage: page,totalPage: 10 ,
          errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  Future <void> addDocument(DocumentsModel documentsModel) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      await documentRepository.addDocument(documentsModel);
      emit(state.copyWith(
          documentStatus: DocumentStatus.loaded, errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  Future <void> updateDocument(DocumentsModel documentsModel) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading ,errorMessage: ""));
      await documentRepository.updateDocument(documentsModel);
      emit(state.copyWith(
          documentStatus: DocumentStatus.loaded, errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  // Future<void> showDocument(DocumentsModel documentsModel) async {
  //   emit(state.copyWith(
  //       documentStatus: DocumentStatus.loaded, selectedDocument: documentsModel));
  // }
}
