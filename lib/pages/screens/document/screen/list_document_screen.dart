import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../widgets/documents_tab_widget.dart';

class ListDocumentScreen extends StatefulWidget {
  const ListDocumentScreen({super.key});

  @override
  State<ListDocumentScreen> createState() => _ListDocumentScreenState();
}

class _ListDocumentScreenState extends State<ListDocumentScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    Future.delayed(Duration.zero, () {
      context.read<DocumentCubit>().getAllDocument(1);
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
    return BlocBuilder<DocumentCubit, DocumentState>(builder: (context, state) {
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
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
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Documents",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Du dernier document enregistrement au premier.",
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.grey[300]),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  context.go('/document/nouveau-document');
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
                                        "Nouveau document",
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
                                      color: Colors.grey[300],
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width,
                                ),
                                child: DocumentsTabWidget(state: state),
                              ),
                            ),
                          ),
                          Spacer(),
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
                                onTap: state.currentPage > 1 ? () => context.read<DocumentCubit>().goToPreviousPage() : null,
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
                                onTap: state.currentPage < state.lastPage ? () => context.read<DocumentCubit>().goToNextPage() : null,
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
                  //       if (state.documentStatus == DocumentStatus.loading)
                  //         const Center(
                  //           child: CircularProgressIndicator(
                  //             strokeWidth: 3.0,
                  //           ),
                  //         )
                  //       else if (state.documentStatus == DocumentStatus.error)
                  //         Center(child: SizedBox())
                  //       else if (state.documentStatus == DocumentStatus.loaded || state.documentStatus == DocumentStatus.sucess)
                  //         Expanded(
                  //           flex: 9,
                  //           child: SingleChildScrollView(
                  //             scrollDirection: Axis.horizontal,
                  //             child: ConstrainedBox(
                  //               constraints: BoxConstraints(
                  //                 minWidth: MediaQuery.of(context).size.width,
                  //               ),
                  //               child: DocumentsTabWidget(state: state),
                  //             ),
                  //           ),
                  //         )
                  //       else
                  //         Center(child: SizedBox())
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
