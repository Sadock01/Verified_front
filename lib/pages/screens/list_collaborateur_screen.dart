import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_state.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../utils/shared_preferences_utils.dart';

class ListCollaborateurScreen extends StatefulWidget {
  const ListCollaborateurScreen({super.key});

  @override
  State<ListCollaborateurScreen> createState() => _ListCollaborateurScreenState();
}

class _ListCollaborateurScreenState extends State<ListCollaborateurScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
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
    return BlocBuilder<CollaborateursCubit, CollaborateursState>(builder: (context, state) {
      return Scaffold(
        body: Row(
          children: [
            DrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  AppbarDashboard(),
                  Flexible(
                    flex: 8,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          width: Const.screenWidth(context),
                          height: Const.screenHeight(context) * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 5),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                ),
                                onPressed: () {
                                  context.go('/document/nouveau_document');
                                },
                                child: Text(
                                  "Nouveau Document +",
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            if (state.collaborateurStatus == CollaborateurStatus.loading)
                              const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                              )
                            else if (state.collaborateurStatus == CollaborateurStatus.error)
                              Center(child: SizedBox())
                            else if (state.collaborateurStatus == CollaborateurStatus.loaded)
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    width: Const.screenWidth(context),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: DataTable(
                                      headingRowHeight: 30,
                                      dataRowMaxHeight: 50,
                                      columns: [
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.1, // Largeur définie pour éviter l'overflow
                                            child: Text("Prenom", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.25,
                                            child: Text("Nom", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.1,
                                            child: Text("Email", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.1,
                                            child: Text("Status", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.12,
                                            child: Text("Action", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                      ],
                                      rows: state.listCollaborateurs
                                          .map((collaborateur) => DataRow(
                                                cells: [
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.1,
                                                    child: Text(
                                                      collaborateur.firstName.toString(),
                                                      style: Theme.of(context).textTheme.displayMedium,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.1,
                                                    child: Text(
                                                      collaborateur.lastName,
                                                      style: Theme.of(context).textTheme.labelSmall,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.1,
                                                    child: Text(
                                                      collaborateur.email,
                                                      style: Theme.of(context).textTheme.displayMedium,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.1,
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: collaborateur.status == 1
                                                              ? Colors.green.withValues(alpha: 0.2)
                                                              : Colors.red.withValues(alpha: 0.2)),
                                                      child: Text(
                                                        collaborateur.status == 1 ? 'activer' : "desactiver",
                                                        style: Theme.of(context).textTheme.displayMedium,
                                                      ),
                                                    ),
                                                  )),
                                                  DataCell(PopupMenuButton<String>(
                                                    onSelected: (value) {
                                                      // if (value == "edit") {
                                                      //   context.go(
                                                      //       '/document/update/${document.id}');
                                                      // } else if (value ==
                                                      //     "view") {
                                                      //   context.go(
                                                      //       '/document/view/${document.identifier}');
                                                      // }
                                                    },
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(value: "edit", child: Text("Modifier document")),
                                                      PopupMenuItem(value: "view", child: Text("Afficher document")),
                                                    ],
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors.click,
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.primary,
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Text(
                                                          "Option",
                                                          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: state.currentPage > 1 ? () => context.read<CollaborateursCubit>().goToPreviousPage() : null,
                                        child: Container(
                                            decoration:
                                                BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                                            child: Icon(Icons.arrow_back_ios)),
                                      ),
                                      Text(
                                        '${state.currentPage} sur ${state.lastPage}',
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                      InkWell(
                                        onTap: state.currentPage < state.lastPage ? () => context.read<CollaborateursCubit>().goToNextPage() : null,
                                        child: Container(
                                            decoration:
                                                BoxDecoration(color: Colors.grey..withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                                            child: Icon(Icons.arrow_forward_ios)),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            else
                              Center(
                                child: Text(
                                  "Erreur inattendue",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              )
                          ],
                        )
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
