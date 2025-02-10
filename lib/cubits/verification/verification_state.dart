
import 'package:doc_authentificator/models/verification_model.dart';
import 'package:equatable/equatable.dart';

enum VerificationStatus {
  initial,
  loading,
  loaded,
  error,
}

class VerificationState extends Equatable {
  final VerificationStatus verificationStatus;
  final List<VerificationModel> listVerifications;
  final int currentPage;
  final int lastPage;
  final String? searchKey;
  final String errorMessage;

  const VerificationState({
    required this.verificationStatus,
    required this.listVerifications,
    required this.errorMessage,
    required this.currentPage,
    required this.lastPage,
    required this.searchKey,
  });

  factory VerificationState.initial() {
    return VerificationState(
      verificationStatus: VerificationStatus.initial,
      listVerifications: [],
      currentPage: 1,
      lastPage: 1,
      errorMessage: "",
      searchKey: '',
    );
  }

  VerificationState copyWith({
    VerificationStatus? verificationStatus,
    List<VerificationModel>? listVerifications,
    int? currentPage,
    int? lastPage,
    String? errorMessage,
    String? searchKey,
  }) {
    return VerificationState(
      verificationStatus: verificationStatus ?? this.verificationStatus,
      listVerifications: listVerifications ?? this.listVerifications,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        verificationStatus,
        listVerifications,
        currentPage,
        lastPage,
        errorMessage,
        searchKey,
      ];
}
