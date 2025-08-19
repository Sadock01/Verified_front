import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/rapports/report_cubit.dart';
import 'package:doc_authentificator/cubits/rapports/report_state.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../widgets/document_detail_tab_widget.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final int documentId;
  const DocumentDetailsScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    context.read<ReportCubit>().getAllDocReport(1, widget.documentId);
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
        backgroundColor: Colors.grey[200],
        body: Row(
          children: [
            DrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  AppbarDashboard(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: Const.screenWidth(context),
                    height: Const.screenHeight(context) * 0.1,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Details Document",
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  if (state.reportStatus == ReportStatus.loading)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ),
                    )
                  else if (state.reportStatus == ReportStatus.error)
                    Center(
                        child: Container(
                      width: 225,
                      height: 225,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/undraw_cancel_7zdh.png",
                              ))),
                    ))
                  else if (state.reportStatus == ReportStatus.loaded)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Historiques du documents",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Du dernier document verifié au premier.",
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.grey[300]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width,
                                  ),
                                  child: DocumentDetailTabWidget(state: state),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Center()
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
