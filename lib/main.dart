import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/login/login_cubit.dart';
import 'package:doc_authentificator/cubits/rapports/report_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/cubits/theme/theme_cubit.dart';

import 'package:doc_authentificator/pages/dashboard_home_screen.dart';
import 'package:doc_authentificator/repositories/auth_repository.dart';
import 'package:doc_authentificator/repositories/collaborateur_repository.dart';
import 'package:doc_authentificator/repositories/document_repository.dart';
import 'package:doc_authentificator/repositories/report_repository.dart';
import 'package:doc_authentificator/repositories/type_doc_repository.dart';
import 'package:doc_authentificator/repositories/verification_repository.dart';

import 'package:doc_authentificator/routes/routes.dart';
import 'package:doc_authentificator/utils/app_theme.dart';
import 'package:doc_authentificator/utils/shared_preferences_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log('💥 Flutter error: ${details.exception}');
  };

  await SharedPreferencesUtils.init();
  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (_) => DocumentRepository()),
              RepositoryProvider(create: (_) => TypeDocRepository()),
              RepositoryProvider(create: (_) => AuthRepository()),
              RepositoryProvider(create: (_) => VerificationRepository()),
              RepositoryProvider(create: (_) => CollaborateurRepository()),
              RepositoryProvider(create: (_) => ReportRepository()),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => SwitchPageCubit()),
                BlocProvider(
                  create: (context) => LoginCubit(
                    authRepository: context.read<AuthRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => TypeDocCubit(
                    typeDocRepository: context.read<TypeDocRepository>(),
                  )..getAllType(1),
                ),
                BlocProvider(
                  create: (context) => DocumentCubit(
                    documentRepository: context.read<DocumentRepository>(),
                  )..getAllDocument(1),
                ),
                BlocProvider(
                  create: (context) => VerificationCubit(
                    verificationRepository: context.read<VerificationRepository>(),
                  )..getAllVerification(1),
                ),
                BlocProvider(
                  create: (context) => CollaborateursCubit(
                    collaborateurRepository: context.read<CollaborateurRepository>(),
                  )..getAllCollaborateur(1),
                ),
                BlocProvider(
                  create: (context) => ReportCubit(
                    reportRepository: context.read<ReportRepository>(),
                  )..getAllReports(1),
                ),
              ],
              child: Builder(
                builder: (context) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    title: 'Doc Authenticator',
                    routerConfig: AppRouter.router,
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: themeMode,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
