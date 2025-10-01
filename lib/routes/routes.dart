import 'package:doc_authentificator/pages/screens/activity/screens/activities_screen.dart';
import 'package:doc_authentificator/pages/system/screens/system_admin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/switch_page/switch_page_cubit.dart';
import '../pages/screens/authentification/screen/login_page.dart';
import '../pages/screens/collaborateur/screen/list_collaborateur_screen.dart';
import '../pages/screens/collaborateur/screen/new_collaborateur_screen.dart';
import '../pages/screens/dashboard/screen/statistiques_screen.dart';
import '../pages/screens/document/screen/create_document_screen.dart';
import '../pages/screens/document/screen/document_details_screen.dart';
import '../pages/screens/document/screen/list_document_screen.dart';
import '../pages/screens/document/screen/new_document_screen.dart';
import '../pages/screens/document/screen/update_document_screen.dart';
import '../pages/screens/history/screens/history_screen.dart';
import '../pages/screens/rapport/screen/Rapports_screen.dart';
import '../pages/screens/verify/screen/user_verify_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/undraw_cancel_7zdh.png",
              width: 252,
              height: 252,
            ),
            SizedBox(height: 10),
            Text(
              "Page not found",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w900),
            )
          ],
        )),
      );
    },
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
          context.read<SwitchPageCubit>().switchPage(1.1); // Sélectionner la page Liste des documents
          return ListDocumentScreen();
        },
      ),
      GoRoute(
        path: '/document/List-document',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(1.1); // Sélectionner la page Liste des documents
          return ListDocumentScreen();
        },
      ),
      GoRoute(
        path: '/document/nouveau-document',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(1.2); // Sélectionner la page Nouveau document
          return const CreateDocumentScreen();
        },
      ),
      GoRoute(
        path: '/document/create-document',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(1.3); // Sélectionner la page Nouveau document
          return const NewDocumentScreen();
        },
      ),
      GoRoute(
        path: '/historiques',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(3); // Sélectionner la page Collaborateurs
          return const HistoryScreen();
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
        path: '/collaborateur/List-collaborateurs',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(5.1); // Sélectionner la page Liste des documents
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
        path: '/collaborateur/nouveau-collaborateur',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(5.2);
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
        path: '/system',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(9.9);
          return const SystemAdminScreen();
        },
      ),
      GoRoute(
        path: '/system/activities-logs',
        builder: (BuildContext context, GoRouterState state) {
          context.read<SwitchPageCubit>().switchPage(9.9);
          return const ActivitiesScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const UserVerifyPage();
        },
      ),
      GoRoute(
        path: '/document/update/:identifier',
        builder: (context, state) {
          final identifier = int.parse(state.pathParameters['identifier']!);
          return UpdateDocumentScreen(
            documentId: identifier,
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
}
