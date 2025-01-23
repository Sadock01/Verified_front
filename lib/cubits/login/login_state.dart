import 'package:equatable/equatable.dart';

enum LoginStatus {
  initial,
  loading,
  loaded,
  error,
}

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final String errorMessage;

  const LoginState({
    required this.loginStatus,
    required this.errorMessage,
  });

  factory LoginState.initial() {
    return const LoginState(
      loginStatus: LoginStatus.initial,
      errorMessage: '',
    );
  }

  LoginState copyWith({LoginStatus? loginStatus, String? errorMessage}) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [loginStatus, errorMessage];
}
