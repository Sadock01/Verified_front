import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_state.dart';

import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewDocumentScreen extends StatefulWidget {
  const NewDocumentScreen({super.key});

  @override
  State<NewDocumentScreen> createState() => _NewDocumentScreenState();
}

class _NewDocumentScreenState extends State<NewDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Stocker le type sélectionné
  TypeDocModel? _selectedType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypeDocCubit, TypeDocState>(
      builder: (context, state) {
        if (state.typeStatus == TypeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.typeStatus == TypeStatus.loaded) {
          final List<TypeDocModel> types = state.listType;

          return BlocBuilder<DocumentCubit, DocumentState>(
            builder: (context, sate) {
              return SingleChildScrollView(
                child: Column(
                  children: [
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
                            // Champ Identifiant
                            TextFormField(
                              controller: _identifierController,
                              decoration: InputDecoration(
                                labelText: "Identifiant",
                                labelStyle:
                                    Theme.of(context).textTheme.labelMedium,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer l'identifiant du document.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            // Champ Description
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "Description",
                                labelStyle:
                                    Theme.of(context).textTheme.labelMedium,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "La description pour ce document est requise.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            // Dropdown des types
                            DropdownButtonFormField<TypeDocModel>(
                              value: _selectedType,
                              hint: Text(
                                "Choisir un type",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: types.map((type) {
                                return DropdownMenuItem<TypeDocModel>(
                                  value: type,
                                  child: Text(type.name),
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
                            const SizedBox(height: 20),
                            // Bouton Enregistrer
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
              );
            },
          );
        } else {
          return Center(
            child: Text(
              "Erreur lors du chargement des types.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          );
        }
      },
    );
  }
}
