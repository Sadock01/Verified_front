import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:doc_authentificator/pages/screens/Rapports_screen.dart';
import 'package:doc_authentificator/pages/screens/collaborateur_screen.dart';
import 'package:doc_authentificator/pages/screens/list_document_screen.dart';
import 'package:doc_authentificator/pages/screens/new_document_screen.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardHomeScreen extends StatefulWidget {
  final Widget widget;

  
  const DashboardHomeScreen({super.key, required this.widget,});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
  
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        DrawerDashboard(),
        Expanded(
          child: Column(children: [
            AppbarDashboard(),
            BlocBuilder<SwitchPageCubit, SwitchPageState>(
                builder: (context, state) {
              if (state.selectedPage == 0) {
                return Container();
              } else if (state.selectedPage == 1) {
                return ListDocumentScreen();
              } else if (state.selectedPage == 2) {
                return NewDocumentScreen();
              } else if (state.selectedPage == 3) {
                return CollaborateurScreen();
              }
              return Center(
                child: Text("Page not found"),
              );
            }),
          ]),
        )
      ],
    ));
  }
}
