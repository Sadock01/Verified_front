  import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/models/verification_model.dart';
import 'package:doc_authentificator/repositories/verification_repository.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

  class VerificationCubit extends Cubit<VerificationState> {
    final VerificationRepository verificationRepository;
    VerificationCubit({
      required this.verificationRepository,
    }) : super(VerificationState.initial()) {}

 Future<void> getAllVerification(int page) async {
    try {
      emit(state.copyWith(
          verificationStatus: VerificationStatus.loading, errorMessage: ""));
      final response = await verificationRepository.getAllVerification(page);
      final List<VerificationModel> verifications = (response['data'] as List)
          .map((vef) => VerificationModel.fromJson(vef))
          .toList();
      emit(state.copyWith(
          verificationStatus: VerificationStatus.loaded,
          listVerifications: verifications,
          currentPage: page,
          lastPage: response['last_page'],
          errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), verificationStatus: VerificationStatus.error));
    }
  }

   void goToNextPage() {
    if (state.currentPage < state.lastPage) {
      final nextPage = state.currentPage + 1;
      emit(state.copyWith(currentPage: nextPage));
      getAllVerification(nextPage);
    }
  }

  void goToPreviousPage() {
    if (state.currentPage > 1) {
      final prevPage = state.currentPage - 1;
      emit(state.copyWith(currentPage: prevPage));
      getAllVerification(prevPage);
    }
  }

  void setSearchKey(String searchKey) {
    emit(state.copyWith(searchKey: searchKey));
  }


  }