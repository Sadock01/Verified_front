import 'dart:developer';

import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
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

class NewDocumentScreen extends StatefulWidget {
  const NewDocumentScreen({super.key});

  @override
  State<NewDocumentScreen> createState() => _NewDocumentScreenState();
}

class _NewDocumentScreenState extends State<NewDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newTypeController = TextEditingController();

  // Stocker le type sélectionné
  TypeDocModel? _selectedType;
  bool _isAutoDescription = false;
  @override
  void dispose() {
    _identifierController.dispose();
    _descriptionController.dispose();
    _newTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void showDescriptionDialog() {
      String? reponse1, reponse2, reponse4, reponse3;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Génération automatique de la description",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: Theme.of(context).textTheme.labelSmall,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelText: "Quel est le type du document ?",
                      labelStyle: Theme.of(context).textTheme.labelSmall),
                  onChanged: (value) => reponse1 = value,
                ),
                SizedBox(height: 5),
                TextField(
                  style: Theme.of(context).textTheme.labelSmall,
                  decoration: InputDecoration(
                      labelText: "À qui est destiné ce document ?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelStyle: Theme.of(context).textTheme.labelSmall),
                  onChanged: (value) => reponse2 = value,
                ),
                SizedBox(height: 5),
                TextField(
                  style: Theme.of(context).textTheme.labelSmall,
                  decoration: InputDecoration(
                      labelText: "Quel organisme a délivré le documment?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelStyle: Theme.of(context).textTheme.labelSmall),
                  onChanged: (value) => reponse3 = value,
                ),
                SizedBox(height: 5),
                TextField(
                  style: Theme.of(context).textTheme.labelSmall,
                  decoration: InputDecoration(
                      labelText: "Informations supplémentaires ?",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      labelStyle: Theme.of(context).textTheme.labelSmall),
                  onChanged: (value) => reponse4 = value,
                ),SizedBox(height: 15),
                
                
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _descriptionController.text =
                        " Type: $reponse1\n\n Délivré à: $reponse2\n\n Délivré par: $reponse3\n\n Informations supplémentaires : $reponse4.";
                  });
                  Navigator.pop(context);
                },
                child: Text("Générer"),
              ),
            ],
          );
        },
      );
    }

    void showAddTypeDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Ajouter un nouveau type",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            content: TextField(
              controller: _newTypeController,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                hintText: "Entrez le nom du type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Annuler"),
              ),
              TextButton(
                onPressed: () {
                  if (_newTypeController.text.isNotEmpty) {
                    context.read<TypeDocCubit>().addType(TypeDocModel(
                          name: _newTypeController.text,
                        ));
                  }
                   Navigator.of(context).pop();
                },
                child: Text("Ajouter"),
              ),
            ],
          );
        },
      );
    }

    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state.documentStatus == DocumentStatus.sucess) {
          log("il est ici: ${state.documentStatus}");
          ElegantNotification.success(
            notificationMargin: 10,
            description: Text(state.errorMessage,
                style: Theme.of(context).textTheme.labelSmall),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ).show(context);
          log("j'observe l'etat: ${state.documentStatus}");
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              context.go('/document/List_document');
            }
          });
        }
        if (state.documentStatus == DocumentStatus.error) {
          log("il est ici: ${state.documentStatus}");
          ElegantNotification.error(
            notificationMargin: 10,
            description: Text(state.errorMessage,
                style: Theme.of(context).textTheme.labelSmall),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          ).show(context);
        }
      },
      child: BlocBuilder<TypeDocCubit, TypeDocState>(
        builder: (context, state) {
          return Scaffold(
            body: Row(
              children: [
                DrawerDashboard(),
                Expanded(
                  child: Column(
                    children: [
                      AppbarDashboard(),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Nouveau Document",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Formulaire
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        width: Const.screenWidth(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Const.screenWidth(context) * 0.25,
                                height: 40,
                                child: TextFormField(
                                  controller: _identifierController,
                                  decoration: InputDecoration(
                                    labelText: "Identifiant",
                                    labelStyle:
                                        Theme.of(context).textTheme.labelMedium,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez entrer l'identifiant du document.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Radio(
                                    value: false,
                                    groupValue: _isAutoDescription,
                                    onChanged: (value) => setState(
                                        () => _isAutoDescription = value!),
                                  ),
                                  Text(
                                    "Saisie manuelle",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  Radio(
                                    value: true,
                                    groupValue: _isAutoDescription,
                                    onChanged: (value) => setState(
                                        () => _isAutoDescription = value!),
                                  ),
                                  Text(
                                    "Génération automatique",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              if (_isAutoDescription)
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    onPressed: showDescriptionDialog,
                                    child: Text(
                                      "Générer une description",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                )
                              else
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: "Description",
                                    labelStyle:
                                        Theme.of(context).textTheme.labelMedium,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Veuillez entrer une description"
                                      : null,
                                ),
                              if (!_isAutoDescription)
                                const SizedBox(height: 10),
                              state.typeStatus == TypeStatus.loading
                                  ? const Center(
                                      child:
                                          LinearProgressIndicator(minHeight: 1),
                                    )
                                  : state.typeStatus == TypeStatus.error
                                      ? Text(
                                          "Erreur lors du chargement des types.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width:
                                                  Const.screenWidth(context) *
                                                      0.3,
                                              child: DropdownButtonFormField<
                                                  TypeDocModel>(
                                                value: _selectedType,
                                                hint: Text(
                                                  "Choisir un type",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                items:
                                                    state.listType.map((type) {
                                                  return DropdownMenuItem<
                                                      TypeDocModel>(
                                                    value: type,
                                                    child: Text(
                                                      type.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedType = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "Veuillez sélectionner un type.";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              onPressed: () {
                                                showAddTypeDialog(context);
                                              },
                                              child: Text(
                                                "Nouveau type",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!.copyWith(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<DocumentCubit>().addDocument(
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
                                      .copyWith(
                                        color: Colors.white,
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
      ),
    );
  }
}
