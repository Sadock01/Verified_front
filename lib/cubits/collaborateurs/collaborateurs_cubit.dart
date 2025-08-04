import 'dart:developer';

import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_state.dart';
import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:doc_authentificator/repositories/collaborateur_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollaborateursCubit extends Cubit<CollaborateursState> {
  final CollaborateurRepository collaborateurRepository;
  CollaborateursCubit({
    required this.collaborateurRepository,
  }) : super(CollaborateursState.initial()) {}

  Future<void> getAllCollaborateur(int page) async {
    try {
      emit(state.copyWith(collaborateurStatus: CollaborateurStatus.loading, errorMessage: ""));
      final response = await collaborateurRepository.getAllCollaborateur(page);
      final List<CollaborateursModel> collaborateurs = (response['data'] as List).map((col) => CollaborateursModel.fromJson(col)).toList();
      emit(state.copyWith(
          collaborateurStatus: CollaborateurStatus.loaded,
          listCollaborateurs: collaborateurs,
          currentPage: page,
          lastPage: response['last_page'],
          errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), collaborateurStatus: CollaborateurStatus.error));
    }
  }

  Future<void> addCollaborateur(CollaborateursModel documentsModel) async {
    try {
      emit(state.copyWith(collaborateurStatus: CollaborateurStatus.loading, errorMessage: ""));
      final response = await collaborateurRepository.addCollaborateur(documentsModel);
      log("${response['status_code']}");
      if (response['status_code'] == 200) {
        log("État actuel: ${state.collaborateurStatus}");
        emit(state.copyWith(
          collaborateurStatus: CollaborateurStatus.success,
          errorMessage: response['message'],
        ));
        log("voici ma response: ${response['message']}");
      } else {
        emit(state.copyWith(
          collaborateurStatus: CollaborateurStatus.error,
          errorMessage: response['message'],
        ));
        log("voici ma response: ${response['message']}");
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), collaborateurStatus: CollaborateurStatus.error));
    }
  }

  Future<void> updateCollaborateur(int collaborateurId, CollaborateursModel collaborateurModel) async {
    try {
      emit(state.copyWith(collaborateurStatus: CollaborateurStatus.loading, errorMessage: ""));
      final response = await collaborateurRepository.updateCollaborateur(collaborateurId, collaborateurModel);
      log("${response['message']}");
      if (response['status_code'] == 200) {
        emit(state.copyWith(collaborateurStatus: CollaborateurStatus.loaded, errorMessage: response['message']));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), collaborateurStatus: CollaborateurStatus.error));
    }
  }

  Future<void> getCustomerDetails() async {
    emit(state.copyWith(collaborateurStatus: CollaborateurStatus.loading, errorMessage: ""));

    try {
      final response = await CollaborateurRepository.getClientDetails();
      log("customerCubit response: $response");

      final CollaborateursModel customer = CollaborateursModel.fromMap(response['data']);

      emit(state.copyWith(
        collaborateurStatus: CollaborateurStatus.loaded,
        selectedCollaborateur: customer,
      ));
    } catch (e) {
      log("l'erreur gravissime: $e");
      emit(state.copyWith(
        collaborateurStatus: CollaborateurStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void goToNextPage() {
    if (state.currentPage < state.lastPage) {
      final nextPage = state.currentPage + 1;
      emit(state.copyWith(currentPage: nextPage));
      getAllCollaborateur(nextPage);
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 1) {
      final prevPage = state.currentPage - 1;
      emit(state.copyWith(currentPage: prevPage));
      getAllCollaborateur(prevPage);
    }
  }
}
