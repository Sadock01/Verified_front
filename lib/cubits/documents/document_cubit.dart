import 'dart:developer';

import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/repositories/document_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository documentRepository;
  DocumentCubit({
    required this.documentRepository,
  }) : super(DocumentState.initial()) {}

  Future<void> getAllDocument() async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      final List<DocumentsModel> documents =
          await documentRepository.getAllDocument();
      // final int totalPages = response['last_page'];
      emit(state.copyWith(
          documentStatus: DocumentStatus.loaded,
          listDocuments: documents,
          errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
    }
  }

  Future<void> addDocument(DocumentsModel documentsModel) async {
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

  Future<void> updateDocument(DocumentsModel documentsModel) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      await documentRepository.updateDocument(documentsModel);
      emit(state.copyWith(
          documentStatus: DocumentStatus.loaded, errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), documentStatus: DocumentStatus.error));
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
            documentStatus: DocumentStatus.loaded,
            apiresponse: response['data'].toString(),
            errorMessage: ""));
      } else {
        emit(state.copyWith(
          documentStatus: DocumentStatus.error,
          errorMessage: response['message'],
        ));
      }
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
