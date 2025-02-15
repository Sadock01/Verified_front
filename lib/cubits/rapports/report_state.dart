import 'package:equatable/equatable.dart';
import 'package:doc_authentificator/models/report_model.dart';

enum ReportStatus {
  initial,
  loading,
  loaded,
  error,
}

class ReportState extends Equatable {
  final ReportStatus reportStatus;
  final List<ReportModel> listReports;
  final int currentPage;
  final int lastPage;
  final String? searchKey;
  final String errorMessage;

  const ReportState({
    required this.reportStatus,
    required this.listReports,
    required this.errorMessage,
    required this.currentPage,
    required this.lastPage,
    required this.searchKey,
  });

  factory ReportState.initial() {
    return ReportState(
      reportStatus: ReportStatus.initial,
      listReports: [],
      currentPage: 1,
      lastPage: 1,
      errorMessage: "",
      searchKey: '',
    );
  }

  ReportState copyWith({
    ReportStatus? reportStatus,
    List<ReportModel>? listReports,
    int? currentPage,
    int? lastPage,
    String? errorMessage,
    String? searchKey,
  }) {
    return ReportState(
      reportStatus: reportStatus ?? this.reportStatus,
      listReports: listReports ?? this.listReports,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        reportStatus,
        listReports,
        currentPage,
        lastPage,
        errorMessage,
        searchKey,
      ];
}
