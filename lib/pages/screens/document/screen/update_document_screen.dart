import 'dart:developer';

import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_state.dart';

import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../utils/utilitaire.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import 'package:flutter/services.dart';

class UpdateDocumentScreen extends StatefulWidget {
  final int documentId;
  const UpdateDocumentScreen({super.key, required this.documentId});

  @override
  State<UpdateDocumentScreen> createState() => _UpdateDocumentScreenState();
}

class _UpdateDocumentScreenState extends State<UpdateDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _identifierController;
  late TextEditingController _descriptionController;
  late TextEditingController _beneficiaryController;
  late TextEditingController _dateInfo;

  TypeDocModel? _selectedType;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _identifierController = TextEditingController();
    _descriptionController = TextEditingController();
    _beneficiaryController = TextEditingController();
    _dateInfo = TextEditingController();
    // Charger le document depuis le cubit
    context.read<DocumentCubit>().getDocumentById(widget.documentId);
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      // Rediriger vers la page de login
      context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _descriptionController.dispose();
    _beneficiaryController.dispose();
    _dateInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return BlocBuilder<DocumentCubit, DocumentState>(
    builder: (context, docState) {
        return  BlocListener<DocumentCubit, DocumentState>(
          listener: (context, state) {
            if (state.documentStatus == DocumentStatus.sucess) {
              ElegantNotification.success(
                background: theme.cardColor,
                width: Const.screenWidth(context) * 0.5,
                description: Text(
                  state.errorMessage,
                  style: theme.textTheme.labelSmall,
                ),
                position: Alignment.topRight,
                animation: AnimationType.fromRight,
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
              ).show(context);
              log("document update state : ${state.documentStatus} ");
              context.read<SwitchPageCubit>().switchPage(1);
              Future.delayed(Duration(milliseconds: 300), () {
                if (mounted) context.go('/document/List_document');
              });
            }
            if (state.documentStatus == DocumentStatus.error) {
              ElegantNotification.error(
                background: theme.cardColor,
                width: Const.screenWidth(context) * 0.5,
                description: Text(
                  "Une erreur est survenue.",
                  style: theme.textTheme.labelSmall,
                ),
                position: Alignment.topRight,
                animation: AnimationType.fromRight,
                icon: const Icon(Icons.error_outline, color: Colors.red),
              ).show(context);
            }
          },
          child: BlocBuilder<DocumentCubit, DocumentState>(
            builder: (context, docState) {
              if (docState.selectedDocument == null) {
                return SizedBox();
              }

              final document = docState.selectedDocument!;

              _identifierController.text = document.identifier;
              _descriptionController.text = document.descriptionDocument;
              _beneficiaryController.text = document.beneficiaire ?? "";
              _dateInfo.text = document.dateInfo ?? "";

              return BlocBuilder<TypeDocCubit, TypeDocState>(
                builder: (context, typeState) {
                  if (typeState.typeStatus == TypeStatus.loaded) {
                    _selectedType ??= typeState.listType.firstWhere(
                      (type) => type.id == document.typeId,
                      orElse: () => typeState.listType.first,
                    );
                  }

                  return Scaffold(
                    body: Row(
                      children: [
                        NewDrawerDashboard(),
                        Expanded(
                          child: Column(
                            children: [
                              AppBarDrawerWidget(),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                width: Const.screenWidth(context),
                                height: Const.screenHeight(context) * 0.1,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_BLUE_COLOR,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "Modifier Document",
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                padding: const EdgeInsets.all(10),
                                width: Const.screenWidth(context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: theme.cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: TextFormField(
                                              controller: _identifierController,
                                              style: Theme.of(context).textTheme.labelSmall,
                                              decoration: InputDecoration(
                                                hintStyle: Theme.of(context).textTheme.labelSmall,
                                                hintText: "Ex: DOC-2025-XYZ",
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                              ),
                                              validator: (value) => value == null || value.isEmpty ? "Veuillez entrer l'identifiant." : null,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: TextFormField(
                                              controller: _beneficiaryController,
                                              style: Theme.of(context).textTheme.labelSmall,
                                              decoration: InputDecoration(
                                                hintStyle: Theme.of(context).textTheme.labelSmall,
                                                hintText: "Ex: John Doe",
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                              ),
                                              validator: (value) => value == null || value.isEmpty ? "Veuillez entrer l'identifiant." : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      TextFormField(
                                        controller: _dateInfo,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                          DateInputFormatter(), // ton formatter custom
                                        ],
                                        style: theme.textTheme.labelSmall,
                                        decoration: InputDecoration(
                                          hintStyle: theme.textTheme.labelSmall,
                                          hintText: "jj-mm-aaaa (ex. : 22-07-2023)",
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                        ),
                                        validator: (value) => value == null || value.isEmpty ? "Veuillez entrer la date de delivrance" : null,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _descriptionController,
                                        maxLines: 4,
                                        style: Theme.of(context).textTheme.labelSmall,
                                        decoration: InputDecoration(
                                          hintStyle: Theme.of(context).textTheme.labelSmall,
                                          hintText: "Ex: Attestation délivrée par...",
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                        ),
                                        validator: (value) => value == null || value.isEmpty ? "Veuillez entrer une description." : null,
                                      ),
                                      const SizedBox(height: 10),
                                      typeState.typeStatus == TypeStatus.loading
                                          ? const Center(child: LinearProgressIndicator(minHeight: 1))
                                          : SizedBox(
                                              // padding: const EdgeInsets.symmetric(horizontal: 12),
                                              // decoration: BoxDecoration(
                                              //   color: theme.cardColor,
                                              //   borderRadius: BorderRadius.circular(5),
                                              //   border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
                                              //   boxShadow: [
                                              //     BoxShadow(
                                              //       color: Colors.grey.withOpacity(0.1),
                                              //       blurRadius: 10,
                                              //       offset: const Offset(0, 4),
                                              //     ),
                                              //   ],
                                              // ),
                                              width: 365,
                                              height: 50,
                                              child: DropdownButtonFormField<TypeDocModel>(
                                                value: _selectedType,
                                                hint: Text(
                                                  "Choisir un type",
                                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600), // ✅ Texte local
                                                ),
                                                items: typeState.listType.map((type) {
                                                  return DropdownMenuItem<TypeDocModel>(
                                                    value: type,
                                                    child: Text(
                                                      type.name,
                                                      style: theme.textTheme.labelSmall, // ✅ Texte des options
                                                    ),
                                                  );
                                                }).toList(),

                                                borderRadius: BorderRadius.circular(4),
                                                onChanged: (value) => setState(() => _selectedType = value),
                                                validator: (value) => value == null ? "Veuillez sélectionner un type." : null,
                                                isExpanded: false,
                                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey), // ✅ Icône personnalisée
                                                dropdownColor: theme.cardColor, // ✅ Couleur du menu déroulant
                                                style: theme.textTheme.labelSmall, // ✅ Texte sélectionné
                                              )
                                              // largeur contrôlée, adaptée au web
                                              ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.save, color: Colors.white),
                                          onPressed: () {
                                            if (_formKey.currentState!.validate() && _selectedType != null) {
                                              context.read<DocumentCubit>().updateDocument(
                                                    widget.documentId,
                                                    DocumentsModel(
                                                      identifier: _identifierController.text,
                                                      descriptionDocument: _descriptionController.text,
                                                      beneficiaire: _beneficiaryController.text,
                                                      dateInfo: _dateInfo.text,
                                                      typeId: _selectedType!.id,
                                                    ),
                                                  );
                                            }
                                          },
                                          label: docState.documentStatus == DocumentStatus.loading
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                ))
                                              : Text(
                                                  "Enregistrer",
                                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white),
                                                ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
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
                },
              );
            },
          ),
        );
      }
    );
  }
}
