// import 'dart:developer';
//
// import 'package:doc_authentificator/cubits/activities/activities_state.dart';
// import 'package:doc_authentificator/cubits/rapports/report_state.dart';
// import 'package:doc_authentificator/models/activites_logs.dart';
// import 'package:doc_authentificator/models/report_model.dart';
// import 'package:doc_authentificator/repositories/report_repository.dart';
// import 'package:doc_authentificator/services/report_service.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class ActivitiesCubit extends Cubit<ActivitiesState> {
//   final ReportRepository reportRepository;
//   ActivitiesCubit({
//     required this.reportRepository,
//   }) : super(ActivitiesState.initial()) {}
//
//   Future<void> getAllActivities(int page) async {
//     try {
//       // Mettre l'état en "loading"
//       emit(state.copyWith(activitiesSatus: ActivitiesSatus.loading, errorMessage: ''));
//
//       final response = await ReportService.getAllReports(page);
//
//       log("Voici je teste encore l'intestable");
//       final List<ActivitesLogs> reports = response['data'];
//
//       // Mettre l'état avec les rapports récupérés
//       emit(state.copyWith(
//         activitiesSatus: ActivitiesSatus.loaded,
//         listActivities: reports,
//         currentPage: page,
//         lastPage: response['last_page'],
//         errorMessage: '',
//       ));
//     } catch (e) {
//       log("$e");
//       // En cas d'erreur, mettre l'état en "error" avec un message
//       emit(state.copyWith(
//         activitiesSatus: ActivitiesSatus.error,
//         errorMessage: e.toString(),
//       ));
//     }
//   }
//
//   void goToNextPage() {
//     if (state.currentPage < state.lastPage) {
//       final nextPage = state.currentPage + 1;
//       emit(state.copyWith(currentPage: nextPage));
//       getAllReports(nextPage);
//     }
//   }
//
//   void goToPreviousPage() {
//     if (state.currentPage > 1) {
//       final prevPage = state.currentPage - 1;
//       emit(state.copyWith(currentPage: prevPage));
//       getAllReports(prevPage);
//     }
//   }
//
//   void setSearchKey(String searchKey) {
//     emit(state.copyWith(searchKey: searchKey));
//   }
// }
