import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/login/login_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';

import 'package:doc_authentificator/pages/dashboard_home_screen.dart';
import 'package:doc_authentificator/pages/login_page.dart';
import 'package:doc_authentificator/pages/screens/Rapports_screen.dart';
import 'package:doc_authentificator/pages/screens/collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/list_document_screen.dart';
import 'package:doc_authentificator/pages/screens/new_document_screen.dart';
import 'package:doc_authentificator/pages/screens/update_document_screen.dart';
import 'package:doc_authentificator/pages/statistiques_screen.dart';
import 'package:doc_authentificator/pages/user_verify_page.dart';
import 'package:doc_authentificator/repositories/auth_repository.dart';
import 'package:doc_authentificator/repositories/document_repository.dart';
import 'package:doc_authentificator/repositories/type_doc_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
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
        context
            .read<SwitchPageCubit>()
            .switchPage(1); // Sélectionner la page Liste des documents
        return  ListDocumentScreen();
      },
    ),
    GoRoute(
      path: '/document/nouveau_document',
      builder: (BuildContext context, GoRouterState state) {
        context
            .read<SwitchPageCubit>()
            .switchPage(2); // Sélectionner la page Nouveau document
        return  const NewDocumentScreen();
      },
    ),
    GoRoute(
      path: '/collaborateurs',
      builder: (BuildContext context, GoRouterState state) {
        context
            .read<SwitchPageCubit>()
            .switchPage(3); // Sélectionner la page Collaborateurs
        return DashboardHomeScreen(widget: const CollaborateurScreen());
      },
    ),
    GoRoute(
      path: '/rapports',
      builder: (BuildContext context, GoRouterState state) {
        context
            .read<SwitchPageCubit>()
            .switchPage(4); // Sélectionner la page Rapports
        return const RapportsScreen();
      },
    ),
    GoRoute(
      path: '/verify_document',
      builder: (BuildContext context, GoRouterState state) {
        return const UserVerifyPage();
      },
    ),
    GoRoute(
      path: '/document/update/:id',
      builder: (BuildContext context, GoRouterState state) {
        //  context
        //     .read<SwitchPageCubit>()
        //     .switchPage(5);
        final documentId = int.parse(state.pathParameters['id']!);

        return UpdateDocumentScreen(
          documentId: documentId,
        );
      },
    )
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
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository())
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
