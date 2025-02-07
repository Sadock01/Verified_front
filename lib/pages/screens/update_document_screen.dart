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

  TypeDocModel? _selectedType;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
    _descriptionController = TextEditingController();

    // Charger le document depuis le cubit
    context.read<DocumentCubit>().getDocumentById(widget.documentId);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state.documentStatus == DocumentStatus.sucess) {
          ElegantNotification.success(
            width: Const.screenWidth(context) * 0.5,
            description: Text(state.errorMessage),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          ).show(context);
          context.read<SwitchPageCubit>().switchPage(1);
          Future.delayed(const Duration(seconds: 1), () {
           
            if (state.documentStatus == DocumentStatus.loaded) {
              context.go('/document/List_document');
            }
          });
        }
        if (state.documentStatus == DocumentStatus.error) {
          ElegantNotification.error(
            width: Const.screenWidth(context) * 0.12,
            description: const Text("Une erreur est survenue."),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(Icons.error_outline, color: Colors.red),
          ).show(context);
        }
      },
      child: BlocBuilder<DocumentCubit, DocumentState>(
        builder: (context, docState) {
          if (docState.documentStatus == DocumentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (docState.selectedDocument == null) {
            return const Center(child: Text("Document introuvable."));
          }

          final document = docState.selectedDocument!;

          _identifierController.text = document.identifier;
          _descriptionController.text = document.descriptionDocument;

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
                    DrawerDashboard(),
                    Expanded(
                      child: Column(
                        children: [
                          AppbarDashboard(),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            width: Const.screenWidth(context),
                            height: Const.screenHeight(context) * 0.1,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Modifier Document",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            width: Const.screenWidth(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _identifierController,
                                    decoration: InputDecoration(
                                      labelText: "Identifiant",
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Veuillez entrer l'identifiant."
                                            : null,
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Veuillez entrer une description."
                                            : null,
                                  ),
                                  const SizedBox(height: 10),
                                  typeState.typeStatus == TypeStatus.loading
                                      ? const Center(
                                          child: LinearProgressIndicator(
                                              minHeight: 1))
                                      : DropdownButtonFormField<TypeDocModel>(
                                          value: _selectedType,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          items: typeState.listType.map((type) {
                                            return DropdownMenuItem<
                                                TypeDocModel>(
                                              value: type,
                                              child: Text(type.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedType = value;
                                            });
                                          },
                                          validator: (value) => value == null
                                              ? "Veuillez sélectionner un type."
                                              : null,
                                        ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context
                                            .read<DocumentCubit>()
                                            .updateDocument(
                                              widget.documentId,
                                              DocumentsModel(
                                                identifier:
                                                    _identifierController.text,
                                                descriptionDocument:
                                                    _descriptionController.text,
                                                typeId: _selectedType!.id,
                                              ),
                                            );
                                      }
                                    },
                                    child: Text(
                                      "Enregistrer",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(color: Colors.white),
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
}
