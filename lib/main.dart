import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/pages/dashboard_home_screen.dart';
import 'package:doc_authentificator/pages/screens/Rapports_screen.dart';
import 'package:doc_authentificator/pages/screens/collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/list_document_screen.dart';
import 'package:doc_authentificator/pages/screens/new_document_screen.dart';
import 'package:doc_authentificator/pages/user_verify_page.dart';
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
    builder: (BuildContext context, GoRouterState state) =>
        DashboardHomeScreen(),
  ),
  GoRoute(
    path: '/document/List_document',
    builder: (BuildContext context, GoRouterState state) =>
        ListDocumentScreen(),
  ),
  GoRoute(
    path: '/document/nouveau_document',
    builder: (BuildContext context, GoRouterState state) => NewDocumentScreen(),
  ),
  GoRoute(
    path: '/rapports',
    builder: (BuildContext context, GoRouterState state) => RapportsScreen(),
  ),
  GoRoute(
    path: '/collaborateurs',
    builder: (BuildContext context, GoRouterState state) =>
        CollaborateurScreen(),
  ),
  GoRoute(
    path: '/verify_document',
    builder: (BuildContext context, GoRouterState state) => UserVerifyPage(),
  ),
]);

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 18, 40, 149),
  primary: const Color.fromARGB(255, 18, 40, 149),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DocumentRepository>(
          create: (context) => DocumentRepository(),
        ),
        RepositoryProvider<TypeDocRepository>(
          create: (context) => TypeDocRepository(),
        )
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<SwitchPageCubit>(
              create: (context) => SwitchPageCubit(),
              child: DashboardHomeScreen(),
            ),
            // BlocProvider(
            //   create: (context) => DocumentCubit(
            //     documentRepository: context.read<DocumentRepository>(),
            //   ),
            // ),
            BlocProvider<TypeDocCubit>(
                create: (context) => TypeDocCubit(
                      typeDocRepository: context.read<TypeDocRepository>(),
                    )..getAllType(1)),
            BlocProvider<DocumentCubit>(
              create: (context) => DocumentCubit(
                documentRepository: context.read<DocumentRepository>(),
              )..getAllDocument(),
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
