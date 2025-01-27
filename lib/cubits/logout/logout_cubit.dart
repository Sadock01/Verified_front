// import 'dart:developer';

// import 'package:doc_authentificator/cubits/logout/logout._state.dart';
// import 'package:doc_authentificator/repositories/auth_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LogoutCubit extends Cubit<LogoutState> {
//   final AuthRepository authRepository;

//   LogoutCubit({required this.authRepository}) : super(LogoutState.initial());

//   Future<void> logout() async {
//     emit(state.copyWith(
//       logoutStatus: LogoutStatus.loading,
//       errorMessage: '',
//     ));
//     try {
//       await AuthRepository.logout();
//       emit(state.copyWith(
//         errorMessage: '',
//         logoutStatus: LogoutStatus.loaded,
//       ));
//       log("$state");
//     } catch (e) {
//       emit(
//         state.copyWith(
//           logoutStatus: LogoutStatus.error,
//           errorMessage: e.toString().replaceFirst("Exception: ", ""),
//         ),
//       );
//       log("$state");
//     }
//   }
// }
