import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/appbar_dashboard.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationCubit, VerificationState>(
        builder: (context, state) {
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
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                              // OutlinedButton(
                              //   style: OutlinedButton.styleFrom(
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(5)),
                              //     side: BorderSide(
                              //         color: Theme.of(context).colorScheme.primary),
                              //   ),
                              //   onPressed: () {
                              //     context.go('/document/nouveau_document');
                              //   },
                              //   child: Text(
                              //     "Nouveau Document +",
                              //     style: Theme.of(context).textTheme.displayMedium,
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            if (state.verificationStatus ==
                                VerificationStatus.loading)
                              const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.0,
                                ),
                              )
                            else if (state.verificationStatus ==
                                VerificationStatus.error)
                              Center(
                                child: Text(
                                  state.errorMessage,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              )
                            else if (state.verificationStatus ==
                                VerificationStatus.loaded)
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
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
                                            width: Const.screenWidth(context) *
                                                0.1, // Largeur définie pour éviter l'overflow
                                            child: Text("Identifiant",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) *
                                                0.25,
                                            child: Text("Date de verification",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: Const.screenWidth(context) *
                                                0.12,
                                            child: Text("Status",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium),
                                          ),
                                        ),
                                      ],
                                      rows: state.listVerifications
                                          .map((verification) => DataRow(
                                                cells: [
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(
                                                            context) *
                                                        0.1,
                                                    child: Text(
                                                      verification.identifier
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(
                                                            context) *
                                                        0.25,
                                                    height: Const.screenHeight(
                                                            context) *
                                                        0.05,
                                                    child: Text(
                                                      verification
                                                          .verificationDate
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )),
                                                  DataCell(SizedBox(
                                                    width: Const.screenWidth(
                                                            context) *
                                                        0.1,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: verification
                                                                      .status ==
                                                                  'Authentique'
                                                              ? Colors.green
                                                                  .withValues(
                                                                      alpha:
                                                                          0.2)
                                                              : Colors.red
                                                                  .withValues(
                                                                      alpha:
                                                                          0.2)),
                                                      child: Text(
                                                        verification.status,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium,
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
                                        onTap: state.currentPage > 1
                                            ? () => context
                                                .read<VerificationCubit>()
                                                .goToPreviousPage()
                                            : null,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: Icon(Icons.arrow_back_ios)),
                                      ),
                                      Text(
                                        '${state.currentPage} sur ${state.lastPage}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      InkWell(
                                        onTap:
                                            state.currentPage < state.lastPage
                                                ? () => context
                                                    .read<VerificationCubit>()
                                                    .goToNextPage()
                                                : null,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                  ..withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child:
                                                Icon(Icons.arrow_forward_ios)),
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
