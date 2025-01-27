import 'package:equatable/equatable.dart';

enum LogoutStatus {
  initial,
  loading,
  loaded,
  error,
}

class LogoutState extends Equatable {
  final LogoutStatus logoutStatus;
  final String errorMessage;
  const LogoutState({
    required this.logoutStatus,
    required this.errorMessage,
  });

  factory LogoutState.initial() {
    return const LogoutState(
      logoutStatus: LogoutStatus.initial,
      errorMessage: '',
    );
  }

  LogoutState copyWith({
    LogoutStatus? logoutStatus,
    String? errorMessage,
  }) {
    return LogoutState(
      logoutStatus: logoutStatus ?? this.logoutStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [logoutStatus, errorMessage];
}
