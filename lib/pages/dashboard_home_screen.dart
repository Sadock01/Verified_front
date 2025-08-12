import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:doc_authentificator/pages/screens/document/screen/list_document_screen.dart';
import 'package:doc_authentificator/pages/screens/collaborateur/screen/new_collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/document/screen/new_document_screen.dart';
import 'package:doc_authentificator/pages/screens/rapport/screen/Rapports_screen.dart';

import 'package:doc_authentificator/pages/screens/history/screens/history_screen.dart';
import 'package:doc_authentificator/pages/screens/collaborateur/screen/list_collaborateur_screen.dart';

import 'package:doc_authentificator/pages/screens/dashboard/screen/statistiques_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../utils/shared_preferences_utils.dart';

class DashboardHomeScreen extends StatefulWidget {
  final Widget widget;

  const DashboardHomeScreen({
    super.key,
    required this.widget,
  });

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    context.read<CollaborateursCubit>().getCustomerDetails();
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      // Rediriger vers la page de login
      context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Expanded(
      child: BlocBuilder<SwitchPageCubit, SwitchPageState>(builder: (context, state) {
        if (state.selectedPage == 0) {
          return StatistiquesScreen();
        } else if (state.selectedPage == 5) {
          return ListDocumentScreen();
        } else if (state.selectedPage == 2) {
          return NewDocumentScreen();
        } else if (state.selectedPage == 3) {
          return HistoryScreen();
        } else if (state.selectedPage == 4) {
          return RapportsScreen();
        } else if (state.selectedPage == 7) {
          return ListCollaborateurScreen();
        } else if (state.selectedPage == 8) {
          return NewCollaborateurScreen();
        } else {
          return Center(
            child: Text("Page not found", style: Theme.of(context).textTheme.labelMedium),
          );
        }
      }),
    ));
  }
}
