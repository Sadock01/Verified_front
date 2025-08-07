import 'dart:developer';

import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/login/login_cubit.dart';
import 'package:doc_authentificator/cubits/rapports/report_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';

import 'package:doc_authentificator/pages/dashboard_home_screen.dart';
import 'package:doc_authentificator/pages/screens/authentification/screen/login_page.dart';
import 'package:doc_authentificator/pages/screens/collaborateur/screen/new_collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/document/screen/document_details_screen.dart';
import 'package:doc_authentificator/pages/screens/document/screen/list_document_screen.dart';
import 'package:doc_authentificator/pages/screens/document/screen/new_document_screen.dart';
import 'package:doc_authentificator/pages/screens/rapport/Rapports_screen.dart';

import 'package:doc_authentificator/pages/screens/history/screens/history_screen.dart';
import 'package:doc_authentificator/pages/screens/collaborateur/screen/list_collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/document/screen/update_document_screen.dart';
import 'package:doc_authentificator/pages/screens/dashboard/screen/statistiques_screen.dart';
import 'package:doc_authentificator/pages/screens/verify/screen/user_verify_page.dart';
import 'package:doc_authentificator/repositories/auth_repository.dart';
import 'package:doc_authentificator/repositories/collaborateur_repository.dart';
import 'package:doc_authentificator/repositories/document_repository.dart';
import 'package:doc_authentificator/repositories/report_repository.dart';
import 'package:doc_authentificator/repositories/type_doc_repository.dart';
import 'package:doc_authentificator/repositories/verification_repository.dart';
import 'package:doc_authentificator/utils/shared_preferences_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

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

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(0);
        return const StatistiquesScreen();
      },
    ),
    GoRoute(
      path: '/document/List_document',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(1); // Sélectionner la page Liste des documents
        return ListDocumentScreen();
      },
    ),
    GoRoute(
      path: '/document/nouveau-document',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(2); // Sélectionner la page Nouveau document
        return const NewDocumentScreen();
      },
    ),
    GoRoute(
      path: '/historiques',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(3); // Sélectionner la page Collaborateurs
        return DashboardHomeScreen(widget: const HistoryScreen());
      },
    ),
    GoRoute(
      path: '/collaborateur/List_collaborateurs',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(7); // Sélectionner la page Liste des documents
        return ListCollaborateurScreen();
      },
    ),
    GoRoute(
      path: '/collaborateur/nouveau_collaborateur',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(8);
        return const NewCollaborateurScreen();
      },
    ),
    GoRoute(
      path: '/collaborateur/details/:identifier',
      builder: (context, state) {
        final identifier = state.pathParameters['identifier']!;
        return UpdateDocumentScreen(
          documentId: 1,
        );
      },
    ),
    GoRoute(
      path: '/rapports',
      builder: (BuildContext context, GoRouterState state) {
        context.read<SwitchPageCubit>().switchPage(4);
        return const RapportsScreen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const UserVerifyPage();
      },
    ),
    GoRoute(
      path: '/document/details/:identifier',
      builder: (context, state) {
        final identifier = state.pathParameters['identifier']!;
        return UpdateDocumentScreen(
          documentId: 1,
        );
      },
    ),
    GoRoute(
      path: '/document/view/:identifier',
      builder: (context, state) {
        final identifier = state.pathParameters['identifier']!;
        return DocumentDetailsScreen(
          documentId: 1,
        );
      },
    ),
  ],
);

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 18, 40, 149),
  primary: const Color.fromARGB(255, 18, 40, 149),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DocumentRepository>(
          create: (context) => DocumentRepository(),
        ),
        RepositoryProvider<TypeDocRepository>(
          create: (context) => TypeDocRepository(),
        ),
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<VerificationRepository>(create: (context) => VerificationRepository()),
        RepositoryProvider<CollaborateurRepository>(create: (context) => CollaborateurRepository()),
        RepositoryProvider<ReportRepository>(create: (context) => ReportRepository())
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<SwitchPageCubit>(
              create: (context) => SwitchPageCubit(),
              child: DashboardHomeScreen(
                widget: SizedBox(),
              ),
            ),
            BlocProvider(
              create: (context) => LoginCubit(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<TypeDocCubit>(
                create: (context) => TypeDocCubit(
                      typeDocRepository: context.read<TypeDocRepository>(),
                    )..getAllType(1)),
            BlocProvider<DocumentCubit>(
              create: (context) => DocumentCubit(
                documentRepository: context.read<DocumentRepository>(),
              )..getAllDocument(1),
            ),
            BlocProvider<VerificationCubit>(
              create: (context) => VerificationCubit(
                verificationRepository: context.read<VerificationRepository>(),
              )..getAllVerification(1),
            ),
            BlocProvider<CollaborateursCubit>(
              create: (context) => CollaborateursCubit(
                collaborateurRepository: context.read<CollaborateurRepository>(),
              )..getAllCollaborateur(1),
            ),
            BlocProvider<ReportCubit>(
              create: (context) => ReportCubit(
                reportRepository: context.read<ReportRepository>(),
              )..getAllReports(1),
            ),
          ],
          child: Builder(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {});
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              routerConfig: _router,
              theme: ThemeData().copyWith(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFFFCFCFC),
                ),
                scaffoldBackgroundColor: const Color(0xFFFCFCFC),
                colorScheme: kColorScheme,
                textTheme: const TextTheme().copyWith(
                  displayLarge: GoogleFonts.montserrat(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                  labelLarge: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  displayMedium: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  labelSmall: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  displaySmall: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                  labelMedium: GoogleFonts.montserrat(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  titleSmall: GoogleFonts.montserrat(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          })),
    );
  }
}
