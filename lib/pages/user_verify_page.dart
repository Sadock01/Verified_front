import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:doc_authentificator/pages/pdf_drop_zone_widget.dart';
import 'package:doc_authentificator/services/verification_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import '../utils/utils.dart';
import 'hover_step_widget.dart';

class UserVerifyPage extends StatefulWidget {
  const UserVerifyPage({super.key});

  @override
  State<UserVerifyPage> createState() => _UserVerifyPageState();
}

class _UserVerifyPageState extends State<UserVerifyPage> with TickerProviderStateMixin {
  final TextEditingController _identifierController = TextEditingController();

  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

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
        borderRadius: BorderRadius.circular(10),
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
                backgroundColor: Theme.of(context).colorScheme.primary,
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
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  children: [
                    Text(
                      "Vérifiez l’authenticité d’un document en 3 étapes simples",
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
                          title: "Entrez l'identifiant",
                          desc: "Saisissez l'identifiant unique du document à vérifier.",
                          color: Colors.deepPurple,
                          icon: Icons.confirmation_number,
                        ),
                        HoverAnimatedStep(
                          number: 2,
                          title: "Téléversez votre PDF",
                          desc: "Choisissez le fichier PDF original du document.",
                          color: Colors.indigo,
                          icon: Icons.upload_file,
                        ),
                        HoverAnimatedStep(
                          number: 3,
                          title: "Vérifiez l'authenticité",
                          desc: "Lancez la vérification avec nos services sécurisés.",
                          color: Colors.teal,
                          icon: Icons.verified,
                        ),
                      ],
                    ),

                    SizedBox(height: 50),

                    // Formulaire
                    Form(
                      key: _formKey,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Entrez l'identifiant du document",
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _identifierController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez entrer l'identifiant unique du document";
                                }
                                return null;
                              },
                              style: Theme.of(context).textTheme.labelSmall,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Identifiant unique du document",
                                hintStyle: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                            SizedBox(height: 24),
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
                            SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  if (_selectedFileBytes == null) {
                                    Utils.showVerificationModal(
                                      context: context,
                                      isSuccess: false,
                                      title: "Fichier manquant",
                                      message: "Veuillez téléverser un fichier PDF pour lancer la vérification.",
                                    );
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    final identifier = _identifierController.text;
                                    final response = await VerificationService.verifyDocumentWithFile(
                                      identifier,
                                      _selectedFileBytes!,
                                      filename: _selectedFileName ?? 'document.pdf',
                                    );
                                    log('🔍 STATUS: ${response['status']}');

                                    if (response['success'] == true && response['status'] == 'authentic') {
                                      Utils.showVerificationModal(
                                        context: context,
                                        isSuccess: true,
                                        title: "Document Vérifié",
                                        message: response['data']['message'] ?? "Le document est authentique.",
                                        document: Map<String, dynamic>.from(response['data']['document'] ?? {}),
                                      );
                                    } else if (response['status'] == 'invalid') {
                                      Utils.showVerificationModal(
                                        context: context,
                                        isSuccess: false,
                                        title: "Échec de Vérification",
                                        message: response['message'] ?? "Le document n'a pas pu être vérifié.",
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
                                backgroundColor: Theme.of(context).colorScheme.primary,
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }
}
