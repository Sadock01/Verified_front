import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/cubits/types/type_doc_state.dart';
import 'package:doc_authentificator/pages/pdf_drop_zone_widget.dart';
import 'package:doc_authentificator/services/verification_service.dart';
import 'package:doc_authentificator/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../const/const.dart';
import '../../../../models/type_doc_model.dart';
import '../../../../utils/utilitaire.dart';
import '../../../../utils/utils.dart';
import '../../../hover_step_widget.dart';

class UserVerifyPage extends StatefulWidget {
  const UserVerifyPage({super.key});

  @override
  State<UserVerifyPage> createState() => _UserVerifyPageState();
}

class _UserVerifyPageState extends State<UserVerifyPage> with TickerProviderStateMixin {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _manualTypeController = TextEditingController();

  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  bool _isLoading = false;
  TypeDocModel? _selectedType;

  final _formKey = GlobalKey<FormState>();
  bool _showUpload = false;

  late AnimationController _step1Controller;
  late AnimationController _step2Controller;
  late AnimationController _step3Controller;

  late Animation<double> _step1Scale;
  late Animation<double> _step2Scale;
  late Animation<double> _step3Scale;

  @override
  void initState() {
    super.initState();
    log("je suis ici");
    _step1Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _step2Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _step3Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    _step1Scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _step1Controller, curve: Curves.elasticOut),
    );
    _step2Scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _step2Controller, curve: Curves.elasticOut),
    );
    _step3Scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _step3Controller, curve: Curves.elasticOut),
    );

    _step1Controller.forward();
    Future.delayed(Duration(milliseconds: 300), () => _step2Controller.forward());
    Future.delayed(Duration(milliseconds: 600), () => _step3Controller.forward());
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _step1Controller.dispose();
    _step2Controller.dispose();
    _step3Controller.dispose();
    super.dispose();
  }
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.displaySmall,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }


  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Important : récupère les bytes !
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFileBytes = result.files.single.bytes!;
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.deepPurple.shade700,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "FRIARE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "© ${DateTime.now().year} FRIARE. Tous droits réservés.",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.facebook, color: Colors.white),
                tooltip: "Facebook",
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.mail, color: Colors.white),
              //   tooltip: "Twitter",
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.mail, color: Colors.white),
              //   tooltip: "LinkedIn",
              // ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.email, color: Colors.white),
                tooltip: "Contact Email",
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      // margin: EdgeInsets.only(top: 10),
      width: Const.screenWidth(context),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2), // Couleur de l'ombre
            spreadRadius: 10, // Étalement de l'ombre
            blurRadius: 10, // Flou de l'ombre
            offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Const.screenWidth(context) * 0.1,
            height: 30,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Verified_original.png'))),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Contactez-nous",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(

              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          "Processus de vérification de l'authenticité d'un document:",
                          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        // Les étapes animées
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            HoverAnimatedStep(
                              number: 1,
                              title: "Remplir manuellement",
                              desc: "Indiquez l'identifiant, la date de délivrance, le nom du bénéficiaire et le type de document.",
                              color: Colors.deepPurple,
                              icon: Icons.confirmation_number,
                            ),
                            HoverAnimatedStep(
                              number: 2,
                              title: "Téléverser un PDF",
                              desc: "Importez directement le fichier PDF original du document si vous en avez.",
                              color: Colors.indigo,
                              icon: Icons.upload_file,
                            ),
                            HoverAnimatedStep(
                              number: 0,
                              title: "Vérifiez l'authenticité",
                              desc: "Lancez la vérification avec nos services sécurisés et vous verrez les resultats de votre recherche.",
                              color: Colors.teal,
                              icon: Icons.verified,
                            ),
                          ],
                        ),

                        SizedBox(height: 50),


                        //option mobile
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isMobile = constraints.maxWidth < 1024;

                            return Form(
                              key: _formKey,
                              child: Container(
                                width: isMobile ? null : 1000,
                                padding: EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20, offset: Offset(0, 8)),
                                  ],
                                ),
                                child: isMobile
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Onglets : Boutons pour naviguer
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => setState(() => _showUpload = false),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: !_showUpload ? AppColors.PRIMARY_BLUE_COLOR : Colors.grey[300],
                                            ),
                                            child: Text(
                                              "Entrée personnalisée",
                                              style: TextStyle(color: !_showUpload ? Colors.white : Colors.black),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => setState(() => _showUpload = true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _showUpload ? AppColors.PRIMARY_BLUE_COLOR : Colors.grey[300],
                                            ),
                                            child: Text(
                                              "Vérification par fichier",
                                              style: TextStyle(color: _showUpload ? Colors.white : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),

                                    // Affichage selon le bouton sélectionné
                                    _showUpload ? _buildUploadSection() : _buildFormFields(),


                                  ],
                                )

                                // ----------- GRAND ÉCRAN -------------
                                    : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _buildFormFields(),
                                    ),
                                    SizedBox(width: 24),
                                    Column(
                                      children: [
                                        SizedBox(height: 80),
                                        Text("Ou", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[600])),
                                        SizedBox(height: 5),
                                        Container(
                                          height: 100,
                                          width: 1,
                                          color: Colors.grey[300],
                                        ),
                                      ],
                                    ),
                                    // VerticalDivider(color: Colors.grey[300], thickness: 1),
                                    SizedBox(width: 24),
                                    Expanded(
                                      flex: 2,
                                      child: _buildUploadSection(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 32),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                // if (_selectedFileBytes == null) {
                                //   Utils.showVerificationModal(
                                //     context: context,
                                //     isSuccess: false,
                                //     title: "Fichier manquant",
                                //     message: "Veuillez téléverser un fichier PDF pour lancer la vérification.",
                                //   );
                                //   return;
                                // }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final identifier = _identifierController.text;
                                  final name = _nameController.text;
                                  String? typeName;

                                  if (_selectedType != null) {
                                    typeName = _selectedType!.name;
                                  } else if (_manualTypeController.text.isNotEmpty) {
                                    typeName = _manualTypeController.text.trim();
                                  }

                                  // final type = _selectedType!.name;
                                  final date = _dateController.text;
                                  // final response = await VerificationService.verifyDocumentWithFile(
                                  //   identifier,
                                  //
                                  //   _selectedFileBytes,
                                  //   filename: _selectedFileName ?? 'document.pdf',
                                  // );
                                  final response = await VerificationService.verifyDocWithFile(
                                    identifier,
                                    name,
                                    typeName,
                                    date,
                                    _selectedFileBytes,
                                    filename: _selectedFileName ?? 'document.pdf',
                                  );
                                  log("🧪 Test des conditions - status: ${response['status']} | success: ${response['success']}");
                                  log("Type de status: ${response['status'].runtimeType}");
                                  log("Valeur de status: '${response['status']}'");


                                  if (response['success'] == true && response['status'] == 'authentic') {
                                    await Utils.showVerificationModelNew(
                                      context: context,
                                      isSuccess: response['success'],
                                      title: "Document trouvé",
                                      message: response['message'],
                                      enteredData: response['enteredData'],
                                      description: response['description'],
                                    );
                                  } else if (response['success'] == false && response['status'] == 'not_found') {
                                    await Utils.showVerificationModelNew(
                                      context: context,
                                      isSuccess: false,
                                      title: "Vérification échouée",
                                      message: response?['message'] ?? response['message'] ?? "Erreur inconnue.",
                                      enteredData: response['enteredData'],
                                    );
                                  } else if (response['status'] == 'mismatch') {
                                    log("✅ Bloc mismatch déclenché");
                                    log("response['success']: ${response['success']}");
                                    log("response: ${response}");

                                    log("il vient dans le mismatch: ${response['mismatches']}");
                                    await Utils.showVerificationModelNew(
                                      context: context,
                                      isSuccess: false,
                                      title: "Vérification échouée",
                                      message: response?['message'] ?? response['message'] ?? "Erreur inconnue.",
                                      enteredData: response['enteredData'],
                                      misMatch: response['misMatch'],
                                    );
                                  } else if (response['status'] == 'extraction_failed' && response['success'] == false ) {
                                    Utils.showVerificationModelNew(
                                      context: context,
                                      isSuccess: false,
                                      title: "Échec de Vérification",
                                      message: response['message'] ?? "Le document n'a pas pu être vérifié.",
                                    );
                                  }else if (response['status'] == null) {
                                    Utils.showVerificationModal(
                                      context: context,
                                      isSuccess: false,
                                      title: "Document non trouvé",
                                      message:
                                      "Il semble que le document associé à cet identifiant n'existe pas. Veuillez vérifier les informations et réessayer.",
                                    );
                                  } else if (response['status'] == "mi-authentic") {
                                    Utils.showVerificationModal(
                                      context: context,
                                      isSuccess: true,
                                      title: "Document Vérifié",
                                      message: """Document trouvé
                                    Vous venez d’effectuer une vérification publique limitée basée uniquement sur l’identifiant du document.
                                    Cette vérification confirme que le document est bien enregistré et authentique dans notre base, mais ne donne pas accès aux détails sensibles.
                                    
                                    Pour obtenir une vérification complète avec toutes les métadonnées et informations, merci de téléverser une copie originale du document ou de vous connecter avec un compte autorisé.""",
                                    );
                                  } else {
                                    Utils.showVerificationModal(
                                      context: context,
                                      isSuccess: false,
                                      title: "Échec de Vérification",
                                      message: response['message'] ?? "Le document n'a pas pu être vérifié.",
                                      reasons: Map<String, dynamic>.from(response['data']['reasons'] ?? {}),
                                    );
                                  }
                                } catch (e) {
                                  Utils.showVerificationModal(
                                    context: context,
                                    isSuccess: false,
                                    title: "Échec de Vérification",
                                    message: "Une erreur est survenue : $e",
                                  );
                                } finally {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            child: _isLoading
                                ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                                : Text(
                              "Vérifier l'authenticité",
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  _buildFooter(),
                ],
              ),

            ),
          ),



        ],
      ),
    );
  }

  // Widget _buildTypeDropdown(TypeDocState state) {
  //   final theme = Theme.of(context);
  //
  //   if (state.typeStatus == TypeStatus.loading) {
  //     return const LinearProgressIndicator(minHeight: 1);
  //   } else if (state.typeStatus == TypeStatus.error) {
  //     return Text(
  //       "Erreur lors du chargement des types.",
  //       style: theme.textTheme.labelSmall?.copyWith(color: Colors.red),
  //     );
  //   }
  //
  //   return SizedBox(
  //     width: 365,
  //     child: DropdownButtonFormField<TypeDocModel>(
  //       value: _selectedType,
  //       decoration: InputDecoration(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  //         hintText: "Choisir un type de document",
  //         hintStyle: theme.textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(5),
  //           borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(5),
  //           borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(5),
  //           borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
  //         ),
  //       ),
  //       isExpanded: true,
  //       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
  //       items: state.listType.map((type) {
  //         return DropdownMenuItem<TypeDocModel>(
  //           value: type,
  //           child: Text(
  //             type.name,
  //             style: theme.textTheme.labelSmall,
  //           ),
  //         );
  //       }).toList(),
  //       onChanged: (value) {
  //         setState(() => _selectedType = value);
  //       },
  //       validator: (value) {
  //         return value == null ? "Veuillez sélectionner un type." : null;
  //       },
  //     ),
  //   );
  // }

  Widget _buildTypeDropdown(TypeDocState state) {
    final theme = Theme.of(context);

    if (state.typeStatus == TypeStatus.loading) {
      return const LinearProgressIndicator(minHeight: 1);
    }


    if (state.typeStatus == TypeStatus.error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Type du Document",
            style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: _manualTypeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer le Type du document unique du document";
              }
              return null;
            },
            style: Theme.of(context).textTheme.labelSmall,
            decoration: InputDecoration( filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(5),
              ),
              hintText: "Type du document",
              hintStyle: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: Const.screenWidth(context),
      child: DropdownButtonFormField<TypeDocModel>(
        style: theme.textTheme.labelSmall,
        value: _selectedType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          hintText: "Choisir un type de document",
          hintStyle: theme.textTheme.displaySmall?.copyWith(color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: state.listType.map((type) {
          return DropdownMenuItem<TypeDocModel>(
            value: type,
            child: Text(
              type.name,
              style: theme.textTheme.labelSmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedType = value);
        },

      ),
    );
  }
  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Entrez les informations du document", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 15),

        // Identifiant
        Text("Identifiant", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextFormField(
          controller: _identifierController,
          validator: (value) => (value == null || value.isEmpty) ? "Veuillez entrer l'identifiant unique du document" : null,
          style: Theme.of(context).textTheme.labelSmall,
          decoration: _inputDecoration("Identifiant unique du document"),
        ),
        SizedBox(height: 10),

        // Nom complet
        Text("Nom complet du porteur", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextFormField(
          controller: _nameController,
          onChanged: (value) {
            final upper = Utils.toUpperCaseInput(value);
            _nameController.value = TextEditingValue(
              text: upper,
              selection: TextSelection.collapsed(offset: upper.length),
            );
          },
          style: Theme.of(context).textTheme.labelSmall,
          decoration: _inputDecoration("Nom de famille du bénéficiaire"),
        ),
        SizedBox(height: 10),

        // Type document
        Text("Type du document", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        BlocBuilder<TypeDocCubit, TypeDocState>(
          builder: (context, state) {
            return _buildTypeDropdown(state);
          },
        ),
        SizedBox(height: 10),

        // Date
        Text("Date de délivrance", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextFormField(
          controller: _dateController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
            DateInputFormatter(),
          ],
          style: Theme.of(context).textTheme.labelSmall,
          decoration: _inputDecoration("JJ/MM/AAAA (ex : 22/07/2023)"),
        ),
      ],
    );
  }


  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text("Identifiant", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextFormField(
          controller: _identifierController,
          validator: (value) => (value == null || value.isEmpty) ? "Veuillez entrer l'identifiant unique du document" : null,
          style: Theme.of(context).textTheme.labelSmall,
          decoration: _inputDecoration("Identifiant unique du document"),
        ),
        SizedBox(height: 12),
        Text("Téléversez votre fichier PDF", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
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
      ],
    );
  }

}
