import 'dart:developer';

import 'package:doc_authentificator/cubits/login/login_state.dart';
import 'package:doc_authentificator/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  LoginCubit({required this.authRepository}) : super(LoginState.initial());
  Future<void> login(String email, String password) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading, errorMessage: ''));
    try {
      final response = await AuthRepository.login(email, password);
      log("voici la response: ${response}");
      if (response['status_code'] == 200) {
        emit(state.copyWith(
          loginStatus: LoginStatus.loaded,
          errorMessage: response['message'],
        ));
        log('voici la response: ${response['message']}');
      } else {
        emit(state.copyWith(
          errorMessage: response['message'],
          loginStatus: LoginStatus.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        loginStatus: LoginStatus.error,
      ));
    }
  }
}
