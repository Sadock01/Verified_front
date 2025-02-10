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
      emit(state.copyWith(
          collaborateurStatus: CollaborateurStatus.loading, errorMessage: ""));
      final response = await collaborateurRepository.getAllCollaborateur(page);
      final List<CollaborateursModel> collaborateurs = (response['data'] as List)
          .map((col) => CollaborateursModel.fromJson(col))
          .toList();
      emit(state.copyWith(
          collaborateurStatus: CollaborateurStatus.loaded,
          listCollaborateurs: collaborateurs,
          currentPage: page,
          lastPage: response['last_page'],
          errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), collaborateurStatus: CollaborateurStatus.error));
    }
  }
}