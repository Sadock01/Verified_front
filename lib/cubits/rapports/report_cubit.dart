import 'dart:developer';

import 'package:doc_authentificator/cubits/rapports/report_state.dart';
import 'package:doc_authentificator/models/report_model.dart';
import 'package:doc_authentificator/repositories/report_repository.dart';
import 'package:doc_authentificator/services/report_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository reportRepository;
  ReportCubit({
    required this.reportRepository,
  }) : super(ReportState.initial()) {}

  Future<void> getAllReports(int page) async {
    try {
      // Mettre l'état en "loading"
      emit(
          state.copyWith(reportStatus: ReportStatus.loading, errorMessage: ''));

      // Appel au service pour récupérer les données
      final response = await ReportService.getAllReports(page);

      // Mapper les données en objets ReportModel
      log("Voici je teste encore l'intestable");
       final List<ReportModel> reports = response['data'];

      // Mettre l'état avec les rapports récupérés
      emit(state.copyWith(
        reportStatus: ReportStatus.loaded,
        listReports: reports,
        currentPage: page,
        lastPage: response['last_page'],
        errorMessage: '',
      ));
    } catch (e) {
      log("$e");
      // En cas d'erreur, mettre l'état en "error" avec un message
      emit(state.copyWith(
        reportStatus: ReportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void goToNextPage() {
    if (state.currentPage < state.lastPage) {
      final nextPage = state.currentPage + 1;
      emit(state.copyWith(currentPage: nextPage));
      getAllReports(nextPage);
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 1) {
      final prevPage = state.currentPage - 1;
      emit(state.copyWith(currentPage: prevPage));
      getAllReports(prevPage);
    }
  }

  void setSearchKey(String searchKey) {
    emit(state.copyWith(searchKey: searchKey));
  }
}
