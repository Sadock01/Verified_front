import 'dart:developer';

import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../cubits/types/type_doc_cubit.dart';
import '../../../../cubits/types/type_doc_state.dart';
import '../../../../models/type_doc_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/custom_expanded_table.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../../../../widgets/responsive_action_buttons.dart';
import '../../../../widgets/inline_date_range_picker.dart';
import '../widgets/documents_tab_widget.dart';
import '../widgets/month_filter_widget.dart';
import '../widgets/search_widget.dart';
import '../widgets/type_widget.dart';
import '../widgets/items_per_page_selector.dart';
import '../widgets/smart_pagination_widget.dart';

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

  final ScrollController _scrollController = ScrollController();
  
  // Variables d'état pour les filtres
  final TextEditingController _searchController = TextEditingController();
  TypeDocModel? _selectedType;
  final TextEditingController _manualTypeController = TextEditingController();
  DateTime? _dateInformationStart;
  DateTime? _dateInformationEnd;
  DateTime? _createdStart;
  DateTime? _createdEnd;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _manualTypeController.dispose();
    super.dispose();
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      context.go('/login');
    }
  }

  // Méthode pour formater une date au format YYYY-MM-DD
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year.toString().padLeft(4, '0')}-'
           '${date.month.toString().padLeft(2, '0')}-'
           '${date.day.toString().padLeft(2, '0')}';
  }

  // Méthode pour appliquer les filtres
  void _applyFilters() {
    context.read<DocumentCubit>().filterDocuments(
      identifier: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      typeId: _selectedType?.id,
      typeName: _selectedType == null && _manualTypeController.text.trim().isNotEmpty 
          ? _manualTypeController.text.trim() 
          : null,
      dateInformationStart: _dateInformationStart != null ? _formatDate(_dateInformationStart) : null,
      dateInformationEnd: _dateInformationEnd != null ? _formatDate(_dateInformationEnd) : null,
      createdStart: _createdStart != null ? _formatDate(_createdStart) : null,
      createdEnd: _createdEnd != null ? _formatDate(_createdEnd) : null,
      page: 1,
      perPage: context.read<DocumentCubit>().state.itemsPerPage,
    );
  }

  // Méthode pour réinitialiser les filtres
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedType = null;
      _manualTypeController.clear();
      _dateInformationStart = null;
      _dateInformationEnd = null;
      _createdStart = null;
      _createdEnd = null;
    });
    context.read<DocumentCubit>().clearFilters();
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
                  Container( padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(2),
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
                    ),child: Column(children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: BlocBuilder<TypeDocCubit, TypeDocState>(
                              builder: (context, state) {
                                return TypeDropdownWidget(
                                  state: state,
                                  selectedType: _selectedType,  // Définissez votre type sélectionné
                                  onChanged: (newType) {
                                    setState(() {
                                      _selectedType = newType;
                                    });
                                  },
                                  manualTypeController: _manualTypeController,  // Définir votre contrôleur pour le champ texte
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: _searchController,
                              style: theme.textTheme.labelSmall,
                              decoration: InputDecoration(
                                hintText: "Rechercher par identifiant",
                                hintStyle: theme.textTheme.labelSmall!.copyWith(color: Colors.grey),
                                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: AppColors.PRIMARY_BLUE_COLOR),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            width: 200,
                            child: InlineDateRangePicker(
                              startDate: _dateInformationStart,
                              endDate: _dateInformationEnd,
                              onDateRangeChanged: (startDate, endDate) {
                                setState(() {
                                  _dateInformationStart = startDate;
                                  _dateInformationEnd = endDate;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: _applyFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/filtre.png', width: 22, height: 22, color: Colors.grey[300]),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Filtrer",
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            width: 150,
                            child: OutlinedButton(
                              onPressed: state.hasActiveFilters ? _clearFilters : null,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                side: BorderSide(color: state.hasActiveFilters ? AppColors.PRIMARY_BLUE_COLOR : Colors.grey[300]!),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    size: 20,
                                    color: state.hasActiveFilters ? AppColors.PRIMARY_BLUE_COLOR : Colors.grey[400],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Réinitialiser",
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                      fontSize: 16,
                                      color: state.hasActiveFilters ? AppColors.PRIMARY_BLUE_COLOR : Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],),),
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
                                    "Documents",
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Du dernier document enregistrement au premier.",
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ResponsiveActionButtons(
                                newDocumentRoute: '/document/nouveau-document',
                                onReload: () {
                                  final currentState = context.read<DocumentCubit>().state;
                                  if (currentState.hasActiveFilters) {
                                    // Réappliquer les filtres
                                    _applyFilters();
                                  } else {
                                    // Recharger tous les documents
                                    context.read<DocumentCubit>().getAllDocument(1);
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            flex: 9,
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(MaterialState.dragged)) {
                                    return Colors.grey;
                                  }
                                  return Colors.grey[300]!; // couleur par défaut
                                }),
                                thickness: MaterialStateProperty.all(8),
                                radius: const Radius.circular(8),
                              ),
                              child: Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true, // Force la visibilité de la scrollbar
                                trackVisibility: true, // Optionnel, affiche le track aussi
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: MediaQuery.of(context).size.width,
                                    ),
                                    child: CustomExpandedTable(state: state),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Nombre de documents : ",
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  // ItemsPerPageSelector(currentItemsPerPage: state.itemsPerPage),
                                  SizedBox(width: 10),
                                  Text(
                                    "${state.listDocuments.length}",
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
