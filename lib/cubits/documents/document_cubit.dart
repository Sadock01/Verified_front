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

  Future<void> getAllDocument(int page) async {
    try {
      emit(state.copyWith(
          documentStatus: DocumentStatus.loading, errorMessage: ""));
      final response = await documentRepository.getAllDocument(page);
      final List<DocumentsModel> documents = (response['data'] as List)
          .map((doc) => DocumentsModel.fromJson(doc))
          .toList();
      emit(state.copyWith(
          documentStatus: DocumentStatus.loaded,
          listDocuments: documents,
          currentPage: page,
          lastPage: response['last_page'],
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
      final response = await documentRepository.addDocument(documentsModel);
      if (response['status_code'] == 200) {
        log("État actuel: ${state.documentStatus}");
        emit(state.copyWith(
          documentStatus: DocumentStatus.loaded,
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

  void goToNextPage() {
    if (state.currentPage < state.lastPage) {
      final nextPage = state.currentPage + 1;
      emit(state.copyWith(currentPage: nextPage));
      getAllDocument(nextPage);
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 1) {
      final prevPage = state.currentPage - 1;
      emit(state.copyWith(currentPage: prevPage));
      getAllDocument(prevPage);
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

  int statisticsByDays(){
    emit(state.copyWith(
        documentStatus: DocumentStatus.loading,
        errorMessage: "",
      ));
      log("Récupération des stats");
  }
}
