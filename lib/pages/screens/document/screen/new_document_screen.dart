import 'dart:developer';
import 'package:doc_authentificator/pages/screens/document/widgets/manual_document_form_widget.dart';
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

import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';

import 'dart:typed_data';

import '../../../../models/documents_model.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../../../pdf_drop_zone_widget.dart';
import '../widgets/choose_file_widget.dart';
import '../widgets/extract_data_widget.dart';

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

  PlatformFile? _selectedFile;
  late TabController _tabController;

  Map<String, dynamic>? extractedEntities;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
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

  Widget _buildTabButton(BuildContext context, String title, int index, IconData icon) {
    final isSelected = _tabController.index == index;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.PRIMARY_BLUE_COLOR : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1150;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state.documentStatus == DocumentStatus.sucess) {
          ElegantNotification.success(
            background: theme.cardColor,
            description: Text(
              state.errorMessage,
              style: theme.textTheme.labelSmall,
            ),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
          ).show(context);

          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) context.go('/document/List_document');
          });
        } else if (state.documentStatus == DocumentStatus.error) {
          ElegantNotification.error(
            background: theme.cardColor,
            description: Text(
              state.errorMessage,
              style: theme.textTheme.labelSmall,
            ),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
          ).show(context);
        }
      },
      child: BlocBuilder<TypeDocCubit, TypeDocState>(
        builder: (context, state) {
          return Scaffold(
              drawer: isLargeScreen ? null : const NewDrawerDashboard(),
              body: SafeArea(
                child: Row(
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
                        child: Column(
                          children: [
                            // Onglets web-style
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              constraints: const BoxConstraints(maxWidth: 900),
                              decoration: BoxDecoration(
                                color: theme.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTabButton(
                                      context,
                                      "Enregistrement Manuel",
                                      0,
                                      Icons.edit_document,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.grey[300],
                                  ),
                                  Expanded(
                                    child: _buildTabButton(
                                      context,
                                      "Enregistrement par PDF",
                                      1,
                                      Icons.picture_as_pdf,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Contenu des onglets
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                physics: const NeverScrollableScrollPhysics(), // Désactive le glissement
                                children: [
                                  // Onglet 1: Enregistrement Manuel
                                  SingleChildScrollView(
                                    child: ManualDocumentForm(state: state),
                                  ),
                                  // Onglet 2: Enregistrement par PDF
                                  SingleChildScrollView(
                                    child: _tabController.index == 1
                                        ? (extractedEntities != null
                                            ? ExtractedDataReviewForm(
                                                extractedData: extractedEntities!,
                                                documentIdentifier: _identifierController,
                                                onSubmit: ({
                                                  required String identifier,
                                                  required String description,
                                                  required String typeCertificat,
                                                  required String beneficiaire,
                                                  String? date,
                                                }) {
                                                  log("Enregistrement document...: $description");
                                                  context.read<DocumentCubit>().addDocument(
                                                    DocumentsModel(
                                                      identifier: identifier,
                                                      descriptionDocument: description,
                                                      typeName: typeCertificat,
                                                      dateInfo: date,
                                                      beneficiaire: beneficiaire,
                                                    ),
                                                  );
                                                },
                                              )
                                            : _buildUploadForm(context, state))
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
  Widget _buildUploadForm(BuildContext context, TypeDocState state) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                ),
                child: Text("Cette section accepte uniquement les fichiers PDF. Assurez-vous que votre fichier est au bon format.",
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              const SizedBox(height: 16),
              Text("Identifiant du document", style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _identifierController,
                style: Theme.of(context).textTheme.labelSmall,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[500]),
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
                    Expanded(
                      child: Text(
                        _selectedFileName ?? 'Fichier sélectionné',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedFileBytes == null || _identifierController.text.isEmpty) {
                      ElegantNotification.error(
                        background: theme.cardColor,
                        description: Text(
                          "Veuillez renseigner l'identifiant ou uploader le fichier pdf.",
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

                      // final extracted = response['data']?[0]['entities'];
                      //
                      // setState(() {
                      //   extractedEntities = extracted;
                      //   _isUploading = false; // ✅ Fin du chargement
                      // });
                      final data = response['data'];
                      // final firstItem = response['data']?[0]['entities'];

                      if (data is List && data.isNotEmpty) {
                        // On récupère le premier élément de la liste
                        final firstItem = data[0];
                        if (firstItem is Map<String, dynamic>) {
                          final extracted = firstItem['entities'] as Map<String, dynamic>?;

                          setState(() {
                            extractedEntities = extracted;
                            log("Extracted entities: $extractedEntities");
                            _isUploading = false; // Fin du chargement
                          });
                        } else {
                          // Cas où le premier élément n'est pas un Map
                          setState(() {
                            extractedEntities = null;
                            _isUploading = false;
                          });
                        }
                      } else {
                        // Cas où data n'est pas une liste ou est vide
                        setState(() {
                          extractedEntities = null;
                          _isUploading = false;
                        });
                      }
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
