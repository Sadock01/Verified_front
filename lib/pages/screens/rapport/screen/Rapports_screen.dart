import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/rapports/report_cubit.dart';
import 'package:doc_authentificator/cubits/rapports/report_state.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../widgets/report_tab_widget.dart';
import '../widgets/report_filters_widget.dart';
import '../../../../widgets/custom_expanded_table_reports.dart';
import '../widgets/smart_pagination_widget.dart';
import '../widgets/items_per_page_selector.dart';

class RapportsScreen extends StatefulWidget {
  const RapportsScreen({super.key});

  @override
  State<RapportsScreen> createState() => _RapportsScreenState();
}

class _RapportsScreenState extends State<RapportsScreen> {

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    context.read<ReportCubit>().getAllReports(1);
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
    return BlocBuilder<ReportCubit, ReportState>(builder: (context, state) {
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
                      if (isLargeScreen) {
                        return SizedBox(height: 60, child: AppBarDrawerWidget());
                      } else {
                        return AppBarVendorWidget();
                      }
                    },
                  ),
                  // Filtres
                  const ReportFiltersWidget(),
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
                          // Titre et description
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rapports",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Gestion et consultation des rapports.",
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.grey[300]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          
                          // Contenu principal
                          Expanded(
                            child: state.listReports.isEmpty
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
                                              "Aucun rapport trouvé",
                                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Il n'y a actuellement aucun rapport disponible.",
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
                                          child: CustomExpandedTableReports(state: state),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          
                          // Pagination
                          if (state.listReports.isNotEmpty) ...[
                            SizedBox(height: 16),
                            Row(
                              children: [
                                ItemsPerPageSelector(state: state),
                                Spacer(),
                                SmartPaginationWidget(state: state),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // SingleChildScrollView(
                  //   child: Column(children: [
                  //     Container(
                  //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  //       width: Const.screenWidth(context),
                  //       height: Const.screenHeight(context) * 0.2,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(25),
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey.withValues(alpha: 0.2),
                  //             spreadRadius: 10,
                  //             blurRadius: 10,
                  //             offset: Offset(0, 3),
                  //           ),
                  //         ],
                  //       ),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [],
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Column(
                  //       children: [
                  //         if (state.reportStatus == ReportStatus.loading)
                  //           const Center(
                  //             child: CircularProgressIndicator(
                  //               strokeWidth: 3.0,
                  //             ),
                  //           )
                  //         else if (state.reportStatus == ReportStatus.error)
                  //           Center(
                  //             child: Text(
                  //               state.errorMessage,
                  //               style: Theme.of(context).textTheme.labelMedium,
                  //             ),
                  //           )
                  //         else if (state.reportStatus == ReportStatus.loaded)
                  //           Column(
                  //             mainAxisSize: MainAxisSize.max,
                  //             children: [
                  //               Container(
                  //                 margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //                 width: Const.screenWidth(context),
                  //                 decoration: const BoxDecoration(
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(15),
                  //                     topRight: Radius.circular(15),
                  //                   ),
                  //                   color: Colors.white,
                  //                 ),
                  //                 child: DataTable(
                  //                   headingRowHeight: 30,
                  //                   dataRowMaxHeight: 50,
                  //                   columns: [
                  //                     DataColumn(
                  //                       label: SizedBox(
                  //                         width: Const.screenWidth(context) * 0.1, // Largeur définie pour éviter l'overflow
                  //                         child: Text("Prenom", style: Theme.of(context).textTheme.displayMedium),
                  //                       ),
                  //                     ),
                  //                     DataColumn(
                  //                       label: SizedBox(
                  //                         width: Const.screenWidth(context) * 0.05,
                  //                         child: Text("nom", style: Theme.of(context).textTheme.displayMedium),
                  //                       ),
                  //                     ),
                  //                     DataColumn(
                  //                       label: SizedBox(
                  //                         width: Const.screenWidth(context) * 0.15,
                  //                         child: Text("Ancienne valeur", style: Theme.of(context).textTheme.displayMedium),
                  //                       ),
                  //                     ),
                  //                     DataColumn(
                  //                       label: SizedBox(
                  //                         width: Const.screenWidth(context) * 0.15,
                  //                         child: Text("Nouvelle Valeur", style: Theme.of(context).textTheme.displayMedium),
                  //                       ),
                  //                     ),
                  //                     DataColumn(
                  //                       label: SizedBox(
                  //                         width: Const.screenWidth(context) * 0.12,
                  //                         child: Text("Date de modification", style: Theme.of(context).textTheme.displayMedium),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                   rows: state.listReports
                  //                       .map((report) => DataRow(
                  //                             cells: [
                  //                               DataCell(SizedBox(
                  //                                 width: Const.screenWidth(context) * 0.1,
                  //                                 child: Text(
                  //                                   report.firstName.toString(),
                  //                                   style: Theme.of(context).textTheme.displayMedium,
                  //                                   overflow: TextOverflow.ellipsis,
                  //                                 ),
                  //                               )),
                  //                               DataCell(SizedBox(
                  //                                 width: Const.screenWidth(context) * 0.1,
                  //                                 child: Text(
                  //                                   report.lastName.toString(),
                  //                                   style: Theme.of(context).textTheme.labelSmall,
                  //                                   overflow: TextOverflow.ellipsis,
                  //                                 ),
                  //                               )),
                  //                               DataCell(SizedBox(
                  //                                 width: Const.screenWidth(context) * 0.15,
                  //                                 child: Text(
                  //                                   report.changes.isNotEmpty ? report.changes[0].oldValue : "N/A",
                  //                                   style: Theme.of(context).textTheme.displayMedium,
                  //                                 ),
                  //                               )),
                  //                               DataCell(SizedBox(
                  //                                 width: Const.screenWidth(context) * 0.15,
                  //                                 child: Text(
                  //                                   report.changes.isNotEmpty ? report.changes[0].newValue : "N/A",
                  //                                   style: Theme.of(context).textTheme.displayMedium,
                  //                                 ),
                  //                               )),
                  //                               DataCell(SizedBox(
                  //                                 width: Const.screenWidth(context) * 0.12,
                  //                                 child: Text(
                  //                                   report.modifiedAt.toString(),
                  //                                   style: Theme.of(context).textTheme.displayMedium,
                  //                                 ),
                  //                               )),
                  //                             ],
                  //                           ))
                  //                       .toList(),
                  //                 ),
                  //               ),
                  //               Row(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   InkWell(
                  //                     onTap: state.currentPage > 1 ? () => context.read<VerificationCubit>().goToPreviousPage() : null,
                  //                     child: Container(
                  //                         decoration:
                  //                             BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                  //                         child: Icon(Icons.arrow_back_ios)),
                  //                   ),
                  //                   Text(
                  //                     '${state.currentPage} sur ${state.lastPage}',
                  //                     style: Theme.of(context).textTheme.labelSmall,
                  //                   ),
                  //                   InkWell(
                  //                     onTap: state.currentPage < state.lastPage ? () => context.read<VerificationCubit>().goToNextPage() : null,
                  //                     child: Container(
                  //                         decoration:
                  //                             BoxDecoration(color: Colors.grey..withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3)),
                  //                         child: Icon(Icons.arrow_forward_ios)),
                  //                   ),
                  //                 ],
                  //               )
                  //             ],
                  //           )
                  //         else
                  //           Center()
                  //       ],
                  //     )
                  //   ]),
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
