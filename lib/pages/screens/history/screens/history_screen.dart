import 'dart:developer';

import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/pages/screens/history/widgets/history_tab_widget.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../../../../widgets/custom_expanded_table_history.dart';
import '../widgets/history_filters_widget.dart';
import '../widgets/smart_pagination_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    Future.delayed(Duration.zero, () {
      context.read<VerificationCubit>().getAllVerification(1);
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
    return BlocBuilder<VerificationCubit, VerificationState>(builder: (context, state) {
      log("state.verificationStatus: ${state.verificationStatus}");
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
                  const HistoryFiltersWidget(),
                  if (state.verificationStatus == VerificationStatus.loading) ...[
                    const Center(
                      child: CircularProgressIndicator(strokeWidth: 1.0),
                    ),
                  ] else if (state.verificationStatus == VerificationStatus.error) ...[
                    const Center(
                      child: SizedBox(),
                    ),
                  ] else if (state.verificationStatus == VerificationStatus.loaded)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(10),
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
                            // Row(
                            //   children: [
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Historiques des verifications",
                            //           style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                            //         ),
                            //         Text(
                            //           "Du dernier document verifié au premier.",
                            //           style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[500]),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 12),
                            Expanded(
                              flex: 7,
                              child: state.listVerifications.isEmpty
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
                                                "Aucun historique trouvé",
                                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Il n'y a actuellement aucun historique de vérification.",
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
                                            child: CustomExpandedTableHistory(state: state),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            Spacer(),
                            if (state.listVerifications.isNotEmpty)
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Nombre de documents : ",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${state.listVerifications.length}",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  SmartPaginationWidget(state: state),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
