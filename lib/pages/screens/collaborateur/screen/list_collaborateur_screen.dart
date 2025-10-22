import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_state.dart';
import 'package:doc_authentificator/pages/screens/collaborateur/widgets/collaborateur_tab_widget.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../widgets/collaborateur_filters_widget.dart';
import '../../../../widgets/custom_expanded_table_collaborateurs.dart';
import '../widgets/smart_pagination_widget.dart';
import '../widgets/items_per_page_selector.dart';

class ListCollaborateurScreen extends StatefulWidget {
  const ListCollaborateurScreen({super.key});

  @override
  State<ListCollaborateurScreen> createState() => _ListCollaborateurScreenState();
}

class _ListCollaborateurScreenState extends State<ListCollaborateurScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    Future.delayed(Duration.zero, () {
      context.read<CollaborateursCubit>().getAllCollaborateur(1);
    });
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
    final isLargeScreen = MediaQuery.of(context).size.width > 1150;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return BlocBuilder<CollaborateursCubit, CollaborateursState>(builder: (context, state) {
      return Scaffold(
        drawer: isLargeScreen ? null : const NewDrawerDashboard(),
        body: Row(
          children: [
            if (isLargeScreen) const NewDrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double width = constraints.maxWidth;
                      if (width > 900) {
                        return SizedBox(height: 60, child: AppBarDrawerWidget());
                      } else {
                        return AppBarVendorWidget();
                      }
                    },
                  ),
                  // Filtres
                  const CollaborateurFiltersWidget(),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          isLight
                              ? BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              : BoxShadow()
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Collaborateurs",
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Du dernier collaborateur enregistré au premier.",
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.grey[300]),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  context.go('/collaborateur/nouveau_collaborateur');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 18,
                                      ),
                                      Text(
                                        "Nouveau Collaborateur",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/filtre.png",
                                      width: 18,
                                      height: 18,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Filter",
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/reload.png', width: 18, height: 18, color: Colors.grey[300]),
                                    const SizedBox(width: 10),
                                    Text('Reload', style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            flex: 9,
                            child: state.listCollaborateurs.isEmpty
                                ? SingleChildScrollView(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/undraw_not-found_6bgl.png",
                                              width: 150,
                                              height: 150,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              "Aucun collaborateur trouvé",
                                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Il n'y a actuellement aucun collaborateur disponible.",
                                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: Colors.grey[500],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : ScrollbarTheme(
                                    data: ScrollbarThemeData(
                                      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (states.contains(MaterialState.dragged)) {
                                          return Colors.grey;
                                        }
                                        return Colors.grey[300]!;
                                      }),
                                      thickness: MaterialStateProperty.all(8),
                                      radius: const Radius.circular(8),
                                    ),
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                      trackVisibility: true,
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: MediaQuery.of(context).size.width,
                                          ),
                                          child: CustomExpandedTableCollaborateurs(state: state),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Spacer(),
                          if (state.listCollaborateurs.isNotEmpty)
                            Row(
                              children: [
                                ItemsPerPageSelector(state: state),
                                Spacer(),
                                SmartPaginationWidget(state: state),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Flexible(
                  //   flex: 8,
                  //   child: SingleChildScrollView(
                  //     child: Column(children: [
                  //       Container(
                  //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //         width: Const.screenWidth(context),
                  //         height: Const.screenHeight(context) * 0.2,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(25),
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.grey.withValues(alpha: 0.2),
                  //               spreadRadius: 10,
                  //               blurRadius: 10,
                  //               offset: Offset(0, 3),
                  //             ),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             SizedBox(height: 5),
                  //             OutlinedButton(
                  //               style: OutlinedButton.styleFrom(
                  //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  //                 side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  //               ),
                  //               onPressed: () {
                  //                 context.go('/document/nouveau_document');
                  //               },
                  //               child: Text(
                  //                 "Nouveau Document +",
                  //                 style: Theme.of(context).textTheme.displayMedium,
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(width: 10),
                  //       Column(
                  //         children: [
                  //           if (state.collaborateurStatus == CollaborateurStatus.loading)
                  //             const Center(
                  //               child: CircularProgressIndicator(
                  //                 strokeWidth: 3.0,
                  //               ),
                  //             )
                  //           else if (state.collaborateurStatus == CollaborateurStatus.error)
                  //             Center(child: SizedBox())
                  //           else if (state.collaborateurStatus == CollaborateurStatus.loaded)
                  //             Column(
                  //               mainAxisSize: MainAxisSize.max,
                  //               children: [
                  //                 Container(
                  //                   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //                   width: Const.screenWidth(context),
                  //                   decoration: const BoxDecoration(
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(15),
                  //                       topRight: Radius.circular(15),
                  //                     ),
                  //                     color: Colors.white,
                  //                   ),
                  //                   child: DataTable(
                  //                     headingRowHeight: 30,
                  //                     dataRowMaxHeight: 50,
                  //                     columns: [
                  //                       DataColumn(
                  //                         label: SizedBox(
                  //                           width: Const.screenWidth(context) * 0.1, // Largeur définie pour éviter l'overflow
                  //                           child: Text("Prenom", style: Theme.of(context).textTheme.displayMedium),
                  //                         ),
                  //                       ),
                  //                       DataColumn(
                  //                         label: SizedBox(
                  //                           width: Const.screenWidth(context) * 0.25,
                  //                           child: Text("Nom", style: Theme.of(context).textTheme.displayMedium),
                  //                         ),
                  //                       ),
                  //                       DataColumn(
                  //                         label: SizedBox(
                  //                           width: Const.screenWidth(context) * 0.1,
                  //                           child: Text("Email", style: Theme.of(context).textTheme.displayMedium),
                  //                         ),
                  //                       ),
                  //                       DataColumn(
                  //                         label: SizedBox(
                  //                           width: Const.screenWidth(context) * 0.1,
                  //                           child: Text("Status", style: Theme.of(context).textTheme.displayMedium),
                  //                         ),
                  //                       ),
                  //                       DataColumn(
                  //                         label: SizedBox(
                  //                           width: Const.screenWidth(context) * 0.12,
                  //                           child: Text("Action", style: Theme.of(context).textTheme.displayMedium),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                     rows: state.listCollaborateurs
                  //                         .map((collaborateur) => DataRow(
                  //                               cells: [
                  //                                 DataCell(SizedBox(
                  //                                   width: Const.screenWidth(context) * 0.1,
                  //                                   child: Text(
                  //                                     collaborateur.firstName.toString(),
                  //                                     style: Theme.of(context).textTheme.displayMedium,
                  //                                     overflow: TextOverflow.ellipsis,
                  //                                   ),
                  //                                 )),
                  //                                 DataCell(SizedBox(
                  //                                   width: Const.screenWidth(context) * 0.1,
                  //                                   child: Text(
                  //                                     collaborateur.lastName,
                  //                                     style: Theme.of(context).textTheme.labelSmall,
                  //                                     overflow: TextOverflow.ellipsis,
                  //                                   ),
                  //                                 )),
                  //                                 DataCell(SizedBox(
                  //                                   width: Const.screenWidth(context) * 0.1,
                  //                                   child: Text(
                  //                                     collaborateur.email,
                  //                                     style: Theme.of(context).textTheme.displayMedium,
                  //                                   ),
                  //                                 )),
                  //                                 DataCell(SizedBox(
                  //                                   width: Const.screenWidth(context) * 0.1,
                  //                                   child: Container(
                  //                                     padding: EdgeInsets.symmetric(horizontal: 12),
                  //                                     decoration: BoxDecoration(
                  //                                         borderRadius: BorderRadius.circular(10),
                  //                                         color: collaborateur.status == 1
                  //                                             ? Colors.green.withValues(alpha: 0.2)
                  //                                             : Colors.red.withValues(alpha: 0.2)),
                  //                                     child: Text(
                  //                                       collaborateur.status == 1 ? 'activer' : "desactiver",
                  //                                       style: Theme.of(context).textTheme.displayMedium,
                  //                                     ),
                  //                                   ),
                  //                                 )),
                  //                                 DataCell(PopupMenuButton<String>(
                  //                                   onSelected: (value) {
                  //                                     // if (value == "edit") {
                  //                                     //   context.go(
                  //                                     //       '/document/update/${document.id}');
                  //                                     // } else if (value ==
                  //                                     //     "view") {
                  //                                     //   context.go(
                  //                                     //       '/document/view/${document.identifier}');
                  //                                     // }
                  //                                   },
                  //                                   itemBuilder: (context) => [
                  //                                     PopupMenuItem(value: "edit", child: Text("Modifier document")),
                  //                                     PopupMenuItem(value: "view", child: Text("Afficher document")),
                  //                                   ],
                  //                                   child: MouseRegion(
                  //                                     cursor: SystemMouseCursors.click,
                  //                                     child: Container(
                  //                                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  //                                       decoration: BoxDecoration(
                  //                                         color: Theme.of(context).colorScheme.primary,
                  //                                         borderRadius: BorderRadius.circular(5),
                  //                                       ),
                  //                                       child: Text(
                  //                                         "Option",
                  //                                         style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                 )),
                  //                               ],
                  //                             ))
                  //                         .toList(),
                  //                   ),
                  //                 ),
                  //                 Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     InkWell(
                  //                       onTap: state.currentPage > 1 ? () => context.read<CollaborateursCubit>().goToPreviousPage() : null,
                  //                       child: Container(
                  //                           decoration:
                  //                               BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                  //                           child: Icon(Icons.arrow_back_ios)),
                  //                     ),
                  //                     Text(
                  //                       '${state.currentPage} sur ${state.lastPage}',
                  //                       style: Theme.of(context).textTheme.labelSmall,
                  //                     ),
                  //                     InkWell(
                  //                       onTap: state.currentPage < state.lastPage ? () => context.read<CollaborateursCubit>().goToNextPage() : null,
                  //                       child: Container(
                  //                           decoration:
                  //                               BoxDecoration(color: Colors.grey..withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                  //                           child: Icon(Icons.arrow_forward_ios)),
                  //                     ),
                  //                   ],
                  //                 )
                  //               ],
                  //             )
                  //           else
                  //             Center(
                  //               child: Text(
                  //                 "Erreur inattendue",
                  //                 style: Theme.of(context).textTheme.labelLarge,
                  //               ),
                  //             )
                  //         ],
                  //       )
                  //     ]),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
