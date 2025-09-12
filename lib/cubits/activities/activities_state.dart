import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/activites_logs.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:equatable/equatable.dart';

enum ActivitiesSatus {
  initial,
  loading,
  loaded,
  error,
}

class ActivitiesState extends Equatable {
  final ActivitiesSatus activitiesSatus;

  final List<ActivitesLogs>? listActivities;
  final String? apiResponse;

  final int currentPage;
  final int lastPage;
  final String? searchKey;
  final String errorMessage;

  const ActivitiesState({
    required this.activitiesSatus,
    required this.listActivities,
    required this.errorMessage,
    required this.apiResponse,
    required this.currentPage,
    required this.lastPage,
    required this.searchKey,
  });

  factory ActivitiesState.initial() {
    return ActivitiesState(
      activitiesSatus: ActivitiesSatus.initial,
      listActivities: [],
      currentPage: 1,
      lastPage: 1,
      errorMessage: "",
      apiResponse: '',
      searchKey: '',
    );
  }

  ActivitiesState copyWith({
    ActivitiesSatus? activitiesSatus,
    List<ActivitesLogs>? listActivities,
    String? apiresponse,
    int? currentPage,
    int? lastPage,
    String? errorMessage,
    String? searchKey,
  }) {
    return ActivitiesState(
      activitiesSatus: activitiesSatus ?? this.activitiesSatus,
      listActivities: listActivities ?? this.listActivities,
      apiResponse: apiresponse ?? this.apiResponse,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        activitiesSatus,
        listActivities,
        currentPage,
        lastPage,
        errorMessage,
        searchKey,
      ];
}
