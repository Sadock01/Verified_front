import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:equatable/equatable.dart';

enum CollaborateurStatus {
  initial,
  loading,
  success,
  loaded,
  error,
}

class CollaborateursState extends Equatable {
  final CollaborateurStatus collaborateurStatus;
  final List<CollaborateursModel> listCollaborateurs;
  final CollaborateursModel? selectedCollaborateur;
  final int currentPage;
  final int lastPage;
  final String? searchKey;
  final String errorMessage;

  const CollaborateursState({
    required this.collaborateurStatus,
    required this.listCollaborateurs,
    this.selectedCollaborateur,
    required this.currentPage,
    required this.lastPage,
    required this.errorMessage,
    required this.searchKey,
  });

  factory CollaborateursState.initial() {
    return CollaborateursState(
      collaborateurStatus: CollaborateurStatus.initial,
      listCollaborateurs: [],
      selectedCollaborateur: null,
      currentPage: 1,
      lastPage: 1,
      errorMessage: "",
      searchKey: '',
    );
  }

  CollaborateursState copyWith({
    CollaborateurStatus? collaborateurStatus,
    List<CollaborateursModel>? listCollaborateurs,
    CollaborateursModel? selectedCollaborateur,
    int? currentPage,
    int? lastPage,
    String? errorMessage,
    String? searchKey,
  }) {
    return CollaborateursState(
      collaborateurStatus: collaborateurStatus ?? this.collaborateurStatus,
      listCollaborateurs: listCollaborateurs ?? this.listCollaborateurs,
      selectedCollaborateur: selectedCollaborateur ?? this.selectedCollaborateur,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        collaborateurStatus,
        listCollaborateurs,
        selectedCollaborateur,
        lastPage,
        errorMessage,
        searchKey,
      ];
}
