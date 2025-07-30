import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/rapports/report_cubit.dart';
import 'package:doc_authentificator/cubits/rapports/report_state.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../utils/shared_preferences_utils.dart';
import '../../widgets/appbar_dashboard.dart';

class RapportsScreen extends StatefulWidget {
  const RapportsScreen({super.key});

  @override
  State<RapportsScreen> createState() => _RapportsScreenState();
}

class _RapportsScreenState extends State<RapportsScreen> {
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
    return BlocBuilder<ReportCubit, ReportState>(builder: (context, state) {
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
                            children: [],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            if (state.reportStatus == ReportStatus.loading)
                              const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                              )
                            else if (state.reportStatus == ReportStatus.error)
                              Center(
                                child: Text(
                                  state.errorMessage,
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              )
                            else if (state.reportStatus == ReportStatus.loaded)
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
                                            width: Const.screenWidth(context) * 0.05,
                                            child: Text("nom", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.15,
                                            child: Text("Ancienne valeur", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.15,
                                            child: Text("Nouvelle Valeur", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) * 0.12,
                                            child: Text("Date de modification", style: Theme.of(context).textTheme.displayMedium),
                                          ),
                                        ),
                                      ],
                                      rows: state.listReports
                                          .map((report) => DataRow(
                                                cells: [
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.1,
                                                    child: Text(
                                                      report.firstName.toString(),
                                                      style: Theme.of(context).textTheme.displayMedium,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.1,
                                                    child: Text(
                                                      report.lastName.toString(),
                                                      style: Theme.of(context).textTheme.labelSmall,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.15,
                                                    child: Text(
                                                      report.changes.isNotEmpty ? report.changes[0].oldValue : "N/A",
                                                      style: Theme.of(context).textTheme.displayMedium,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.15,
                                                    child: Text(
                                                      report.changes.isNotEmpty ? report.changes[0].newValue : "N/A",
                                                      style: Theme.of(context).textTheme.displayMedium,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(context) * 0.12,
                                                    child: Text(
                                                      report.modifiedAt.toString(),
                                                      style: Theme.of(context).textTheme.displayMedium,
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
                                        onTap: state.currentPage > 1 ? () => context.read<VerificationCubit>().goToPreviousPage() : null,
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
                                        onTap: state.currentPage < state.lastPage ? () => context.read<VerificationCubit>().goToNextPage() : null,
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
