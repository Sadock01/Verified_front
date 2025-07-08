import 'dart:developer';
import 'package:doc_authentificator/services/document_service.dart';
import 'package:file_picker/file_picker.dart'; // Pour le fichier
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:doc_authentificator/const/const.dart';
import 'dart:typed_data';

import '../pdf_drop_zone_widget.dart';

class NewDocumentScreen extends StatefulWidget {
  const NewDocumentScreen({super.key});

  @override
  State<NewDocumentScreen> createState() => _NewDocumentScreenState();
}

class _NewDocumentScreenState extends State<NewDocumentScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newTypeController = TextEditingController();
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  TypeDocModel? _selectedType;
  bool _isAutoDescription = false;
  PlatformFile? _selectedFile;
  late TabController _tabController;
  bool _isDescriptionReady = false;
  Map<String, dynamic>? extractedEntities;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _descriptionController.dispose();
    _newTypeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  void _showDescriptionDialog() {
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
                      _customTextField("Quel est le type du document ?", (v) => reponse1 = v),
                      const SizedBox(height: 12),
                      _customTextField("À qui est destiné ce document ?", (v) => reponse2 = v),
                      const SizedBox(height: 12),
                      _customTextField("Quel organisme a délivré le document ?", (v) => reponse3 = v),
                      const SizedBox(height: 12),
                      _customTextField("Informations supplémentaires ?", (v) => reponse4 = v),

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
                            _descriptionController.text = "Type: $reponse1\nDestinataire: $reponse2\nOrganisme: $reponse3\nInfos: $reponse4";
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

  Widget _customTextField(String label, Function(String) onChanged) {
    return TextField(
      onChanged: onChanged,
      maxLines: 1,
      style: Theme.of(context).textTheme.labelSmall,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.labelSmall,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _showAddTypeDialog() {
    _newTypeController.clear();

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
                        "Ajouter un type",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _newTypeController,
                        style: Theme.of(context).textTheme.labelSmall,
                        decoration: InputDecoration(
                          hintText: "Nom du type",
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_newTypeController.text.trim().isNotEmpty) {
                              context.read<TypeDocCubit>().addType(
                                    TypeDocModel(name: _newTypeController.text.trim()),
                                  );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            "Ajouter",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton fermer dans le coin supérieur droit
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
                          shape: BoxShape.circle,
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

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: Theme.of(context).textTheme.labelSmall,
            decoration: InputDecoration(
              hintText: 'Modifier si nécessaire...',
              hintStyle: Theme.of(context).textTheme.labelSmall,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state.documentStatus == DocumentStatus.sucess) {
          ElegantNotification.success(
            description: Text(state.errorMessage),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
          ).show(context);

          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) context.go('/document/List_document');
          });
        } else if (state.documentStatus == DocumentStatus.error) {
          ElegantNotification.error(
            description: Text(state.errorMessage),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
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
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              labelStyle: Theme.of(context).textTheme.labelSmall,
                              labelColor: Theme.of(context).colorScheme.primary,
                              indicatorColor: Theme.of(context).colorScheme.primary,
                              tabs: const [
                                Tab(text: "Saisie manuelle"),
                                Tab(text: "Auto record"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildManualForm(context, state),
                            extractedEntities != null
                                ? buildExtractedDataReviewForm(extractedEntities!, () {
                                    ElegantNotification.info(
                                      description: Text(
                                        "Fonction de soumission non encore implémentée.",
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                    ).show(context);
                                  })
                                : _buildUploadForm(context, state)
                          ],
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

  // Ajoute un bool pour savoir si la description auto est validée / affichée

  Widget _buildManualForm(BuildContext context, TypeDocState state) {
    final theme = Theme.of(context);

    return Center(
        child: Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
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

            // Identifiant
            Text("Identifiant du document", style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _identifierController,
                    style: Theme.of(context).textTheme.labelSmall,
                    decoration: InputDecoration(
                      hintStyle: theme.textTheme.labelSmall,
                      hintText: "Ex: DOC-2025-XYZ",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "Veuillez entrer l'identifiant." : null,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _identifierController,
                    style: Theme.of(context).textTheme.labelSmall,
                    decoration: InputDecoration(
                      hintStyle: theme.textTheme.labelSmall,
                      hintText: "Ex: John Doe",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    // validator: (value) => value == null || value.isEmpty ? "Veuillez renseigner le Beneficiaire." : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Choix auto / manuel
            Text("Méthode de description", style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: _isAutoDescription,
                  onChanged: (val) {
                    setState(() {
                      _isAutoDescription = val!;
                      if (!val) _isDescriptionReady = false; // Reset si on revient en manuel
                    });
                  },
                ),
                Text(
                  "Saisie manuelle",
                  style: theme.textTheme.labelSmall,
                ),
                const SizedBox(width: 20),
                Radio<bool>(
                  value: true,
                  groupValue: _isAutoDescription,
                  onChanged: (val) => setState(() => _isAutoDescription = val!),
                ),
                Text(
                  "Génération guidée",
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (_isAutoDescription)
              !_isDescriptionReady
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.auto_fix_high, color: Colors.white),
                        onPressed: () async {
                          _showDescriptionDialog();
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
                        Text(
                          "Description générée :",
                          style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            _descriptionController.text,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isAutoDescription = false; // Passe en mode manuel pour modifier
                              _isDescriptionReady = false;
                            });
                          },
                          child: Text(
                            "Modifier la description",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    )
            else
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

            const SizedBox(height: 24),

            // Dropdown type
            Text("Type de document", style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),
            _buildTypeDropdown(state),

            const SizedBox(height: 30),

            // Bouton Enregistrer
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
                          ),
                        );
                  }
                },
                label: Text(
                  "Enregistrer",
                  style: theme.textTheme.labelSmall!.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildUploadForm(BuildContext context, TypeDocState state) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ElevatedButton.icon(
            //   icon: Icon(Icons.upload_file),
            //   onPressed: _pickFile,
            //   label: Text(_selectedFile != null ? "Fichier sélectionné: ${_selectedFile!.name}" : "Choisir un fichier"),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            //     backgroundColor: Theme.of(context).colorScheme.secondary,
            //     foregroundColor: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            Text("Identifiant du document", style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            TextFormField(
              controller: _identifierController,
              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.labelSmall,
                hintText: "Ex: DOC-2025-XYZ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
              validator: (value) => value == null || value.isEmpty ? "Veuillez entrer l'identifiant." : null,
            ),
            const SizedBox(height: 16),
            // _buildTypeDropdown(state),
            Text(
              "Téléversez votre fichier PDF",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            _selectedFileBytes == null
                ? PdfDropZone(
                    selectedFileBytes: _selectedFileBytes,
                    selectedFileName: _selectedFileName,
                    onFilePicked: (bytes, name) {
                      setState(() {
                        _selectedFileBytes = bytes;
                        _selectedFileName = name;
                      });
                    },
                  )
                : Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade700),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _selectedFileName ?? 'Fichier sélectionné',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.green.shade700),
                          onPressed: () {
                            setState(() {
                              _selectedFileBytes = null;
                              _selectedFileName = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                if (_selectedFileBytes == null || _identifierController.text.isEmpty) {
                  ElegantNotification.error(
                    description: Text(
                      "Veuillez compléter tous les champs.",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ).show(context);
                  return;
                }

                setState(() => _isUploading = true); // ⏳ Démarre le chargement

                try {
                  final identifier = _identifierController.text;
                  final response = await DocumentService.uploadDocumentWithFile(
                    identifier,
                    _selectedFileBytes!,
                    filename: _selectedFileName ?? 'document.pdf',
                  );

                  final extracted = response['data']?[0]['entities'];

                  setState(() {
                    extractedEntities = extracted;
                    _isUploading = false; // ✅ Fin du chargement
                  });
                } catch (e) {
                  setState(() => _isUploading = false);
                  ElegantNotification.error(
                    description: Text(
                      "Erreur lors de l'envoi : ${e.toString()}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ).show(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: _isUploading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save_alt, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Uploader et enregistrer",
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExtractedDataReviewForm(
    Map<String, dynamic> extractedData,
    VoidCallback onSubmit,
  ) {
    final typeController = TextEditingController(text: (extractedData['type_certificat'] as List?)?.join(', ') ?? '');
    final descriptionController = TextEditingController(text: (extractedData['description'] as List?)?.join(', ') ?? '');
    final beneficiaireController = TextEditingController(text: (extractedData['beneficiaire'] as List?)?.join(', ') ?? '');
    // final infoComplementaireController = TextEditingController(text: (extractedData['information_complementaire'] as List?)?.join(', ') ?? '');
    // final dateInfoController = TextEditingController(text: (extractedData['date_information'] as List?)?.join(', ') ?? '');

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Vérification des données extraites",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 25),

              // Champs dans un scrollable
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildLabeledField(label: "Identifiant du document", controller: typeController),
                    _buildLabeledField(label: "Type de certificat", controller: typeController),
                    _buildLabeledField(label: "Description", controller: descriptionController, maxLines: 4),
                    _buildLabeledField(label: "Bénéficiaire", controller: beneficiaireController),
                    // _buildLabeledField(label: "Information complémentaire", controller: infoComplementaireController),
                    // _buildLabeledField(label: "Date d'information", controller: dateInfoController),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Bouton toujours visible
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: onSubmit, // callback passé depuis parent
                  label: Text(
                    "Valider et enregistrer",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(TypeDocState state) {
    final theme = Theme.of(context);

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          width: 365,
          height: 35,
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<TypeDocModel>(
              value: _selectedType,
              hint: Text(
                "Choisir un type",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
              ),
              items: state.listType.map((type) {
                return DropdownMenuItem<TypeDocModel>(
                  value: type,
                  child: Text(
                    type.name,
                    style: theme.textTheme.labelMedium,
                  ),
                );
              }).toList(),
              decoration: const InputDecoration.collapsed(hintText: ""),
              borderRadius: BorderRadius.circular(12),
              onChanged: (value) => setState(() => _selectedType = value),
              validator: (value) => value == null ? "Veuillez sélectionner un type." : null,
              isExpanded: false,
              icon: const Icon(Icons.keyboard_arrow_down),
              dropdownColor: Colors.white,
            ),
          ), // largeur contrôlée, adaptée au web
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
            onPressed: _showAddTypeDialog,
          ),
        ),
      ],
    );
  }
}
