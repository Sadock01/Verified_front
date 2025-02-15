import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:doc_authentificator/pages/screens/Rapports_screen.dart';

import 'package:doc_authentificator/pages/screens/history_screen.dart';
import 'package:doc_authentificator/pages/screens/list_collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/list_document_screen.dart';
import 'package:doc_authentificator/pages/screens/new_collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/new_document_screen.dart';
import 'package:doc_authentificator/pages/statistiques_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(body: Expanded(
      child: BlocBuilder<SwitchPageCubit, SwitchPageState>(
          builder: (context, state) {
        if (state.selectedPage == 0) {
          return StatistiquesScreen();
        } else if (state.selectedPage == 1) {
          return ListDocumentScreen();
        } else if (state.selectedPage == 2) {
          return NewDocumentScreen();
        } else if (state.selectedPage == 3) {
          return HistoryScreen();
        } else if (state.selectedPage == 4) {
          return RapportsScreen();
        } 
        else if (state.selectedPage == 7) {
          return ListCollaborateurScreen();
        } else if (state.selectedPage == 8) {
          return NewCollaborateurScreen();
        } else {
          return Center(
            child: Text("Page not found",
                style: Theme.of(context).textTheme.labelMedium),
          );
        }
      }),
    ));
  }
}
