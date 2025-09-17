import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubits/documents/document_cubit.dart';
import '../../../../cubits/types/type_doc_state.dart';
import '../../../../models/documents_model.dart';
import '../../../../utils/utils.dart';
import 'custom_text_field.dart';

class ManualDocumentForm extends StatefulWidget {
  final TypeDocState state;

  const ManualDocumentForm({super.key, required this.state});

  @override
  State<ManualDocumentForm> createState() => _ManualDocumentFormState();
}

class _ManualDocumentFormState extends State<ManualDocumentForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _beneficiaireController = TextEditingController();
  final TextEditingController _newTypeController = TextEditingController();

  bool _isAutoDescription = false;
  bool _isDescriptionReady = false;

  TypeDocModel? _selectedType; // à adapter selon ton modèle

  @override
  void dispose() {
    _identifierController.dispose();
    _descriptionController.dispose();
    _beneficiaireController.dispose();
    super.dispose();
  }

  // void _showDescriptionDialog() async {
  //   // Ici tu peux mettre un showDialog() si nécessaire

  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 910),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Saisie manuelle du document",
                style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text("Identifiant du document", style: theme.textTheme.labelSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _identifierController,
                      style: theme.textTheme.labelSmall,
                      decoration: InputDecoration(
                        hintStyle: theme.textTheme.labelSmall,
                        hintText: "Ex: DOC-2025-XYZ",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Veuillez entrer l'identifiant." : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _beneficiaireController,
                      style: theme.textTheme.labelSmall,
                      decoration: InputDecoration(
                        hintStyle: theme.textTheme.labelSmall,
                        hintText: "Ex: John Doe",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text("Méthode de description", style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: _isAutoDescription,
                    onChanged: (val) => setState(() {
                      _isAutoDescription = val!;
                      _isDescriptionReady = false;
                    }),
                  ),
                  Text("Saisie manuelle", style: theme.textTheme.labelSmall),
                  const SizedBox(width: 20),
                  Radio<bool>(
                    value: true,
                    groupValue: _isAutoDescription,
                    onChanged: (val) => setState(() => _isAutoDescription = val!),
                  ),
                  Text("Génération guidée", style: theme.textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 8),
              _isAutoDescription
                  ? !_isDescriptionReady
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.auto_fix_high, color: Colors.white),
                            onPressed: () async {
                              showDescriptionDialog();
                              setState(() {
                                _isDescriptionReady = _descriptionController.text.isNotEmpty;
                              });
                            },
                            label: Text(
                              "Générer une description",
                              style: theme.textTheme.labelSmall!.copyWith(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              backgroundColor: theme.colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description générée :", style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(_descriptionController.text, style: theme.textTheme.labelSmall),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => setState(() {
                                _isAutoDescription = false;
                                _isDescriptionReady = false;
                              }),
                              child: Text("Modifier la description", style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.primary)),
                            ),
                          ],
                        )
                  : TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: theme.textTheme.labelSmall,
                      decoration: InputDecoration(
                        hintStyle: theme.textTheme.labelSmall,
                        hintText: "Ex: Attestation délivrée par...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? "Veuillez entrer une description." : null,
                    ),
              const SizedBox(height: 24),
              Text("Type de document", style: theme.textTheme.labelSmall),
              const SizedBox(height: 8),
              _buildTypeDropdown(widget.state),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedType != null) {
                      context.read<DocumentCubit>().addDocument(
                            DocumentsModel(
                                identifier: _identifierController.text,
                                descriptionDocument: _descriptionController.text,
                                typeId: _selectedType!.id,
                                typeName: _selectedType!.name,
                                beneficiaire: _beneficiaireController.text),
                          );
                    }
                  },
                  label: Text("Enregistrer", style: theme.textTheme.labelSmall!.copyWith(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(TypeDocState state) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    if (state.typeStatus == TypeStatus.loading) {
      return const LinearProgressIndicator(minHeight: 1);
    } else if (state.typeStatus == TypeStatus.error) {
      return Text(
        "Erreur lors du chargement des types.",
        style: theme.textTheme.labelSmall,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
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
              items: state.listType.map((type) {
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
        const SizedBox(width: 12),
        Tooltip(
          message: "Ajouter un nouveau type",
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              icon: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
              label: Text(
                "Ajouter",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white),
              ),
              onPressed: () async {
                await Utils.showAddTypeDialog(context, _newTypeController);
                context.read<TypeDocCubit>().getAllType(1);
              }),
        ),
      ],
    );
  }

  void showDescriptionDialog() {
    String? reponse1, reponse2, reponse3, reponse4;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "Génération automatique de la description",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Champs
                      CustomTextField(label: "Quel est le type du document ?", onChanged: (v) => reponse1 = v),
                      const SizedBox(height: 12),
                      CustomTextField(label: "À qui est destiné ce document ?", onChanged: (v) => reponse2 = v),
                      const SizedBox(height: 12),
                      CustomTextField(label: "Quel organisme a délivré le document ?", onChanged: (v) => reponse3 = v),
                      const SizedBox(height: 12),
                      CustomTextField(label: "Informations supplémentaires ?", onChanged: (v) => reponse4 = v),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.auto_fix_high,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Générer la description",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            setState(() {
                              _descriptionController.text = "Type: $reponse1\nDestinataire: $reponse2\nOrganisme: $reponse3\nInfos: $reponse4";
                              _isDescriptionReady = true;
                            });
                            // _descriptionController.text =
                            // _isDescriptionReady = true;
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton de fermeture dans le coin
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 6,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
