import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/verification/verification_cubit.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/pages/screens/history/widgets/history_tab_widget.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/appbar_dashboard.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
    return BlocBuilder<VerificationCubit, VerificationState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Row(
          children: [
            DrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  AppbarDashboard(),
                  if (state.verificationStatus == VerificationStatus.loading) ...[
                    const Center(
                      child: CircularProgressIndicator(strokeWidth: 3.0),
                    ),
                  ] else if (state.verificationStatus == VerificationStatus.error) ...[
                    const Center(
                      child: SizedBox(),
                    ),
                  ] else if (state.verificationStatus == VerificationStatus.loaded)
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
                                      "Historiques des verifications",
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Du dernier document verifié au premier.",
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.grey[300]),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
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
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                  child: Icon(Icons.picture_in_picture_alt_outlined, size: 18, color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.grid_view, size: 18, color: Colors.grey),
                                      Icon(
                                        Icons.table_rows_outlined,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                )
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
                                  child: HistoryTabWidget(state: state),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Show: 2",
                                        style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.swap_vert,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: state.currentPage > 1 ? () => context.read<VerificationCubit>().goToPreviousPage() : null,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                  child: Icon(
                                    Icons.more_horiz_outlined,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      "12",
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: state.currentPage < state.lastPage ? () => context.read<VerificationCubit>().goToNextPage() : null,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                  ),
                                ),
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
