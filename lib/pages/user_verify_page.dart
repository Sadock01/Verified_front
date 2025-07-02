import 'dart:io';

import 'package:doc_authentificator/pages/pdf_drop_zone_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';
import 'hover_step_widget.dart';

class UserVerifyPage extends StatefulWidget {
  const UserVerifyPage({super.key});

  @override
  State<UserVerifyPage> createState() => _UserVerifyPageState();
}

class _UserVerifyPageState extends State<UserVerifyPage> with TickerProviderStateMixin {
  final TextEditingController _identifierController = TextEditingController();
  File? _selectedFile;

  late AnimationController _step1Controller;
  late AnimationController _step2Controller;
  late AnimationController _step3Controller;

  late Animation<double> _step1Scale;
  late Animation<double> _step2Scale;
  late Animation<double> _step3Scale;

  @override
  void initState() {
    super.initState();

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
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _verifyDocument() {
    final identifier = _identifierController.text.trim();
    if (identifier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un identifiant.")),
      );
      return;
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez sélectionner un fichier PDF.")),
      );
      return;
    }

    // Ici on enverra l’identifiant + fichier PDF vers la logique métier (API, Bloc, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vérification en cours...")),
    );
  }

  // Widget _buildAnimatedStep(Animation<double> animation, int number, String title, String desc, Color color, IconData icon) {
  //   return ScaleTransition(
  //     scale: animation,
  //     child: Container(
  //       width: 280,
  //       padding: EdgeInsets.all(24),
  //       margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: color.withOpacity(0.2),
  //             blurRadius: 25,
  //             offset: Offset(0, 10),
  //           ),
  //         ],
  //         border: Border.all(color: color.withOpacity(0.3), width: 2),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           CircleAvatar(
  //             backgroundColor: color,
  //             radius: 30,
  //             child: Icon(icon, size: 32, color: Colors.white),
  //           ),
  //           SizedBox(height: 16),
  //           Text(
  //             "Étape $number",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             title,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  //           ),
  //           SizedBox(height: 6),
  //           Text(
  //             desc,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(color: Colors.grey[700], fontSize: 14),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
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
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.mail, color: Colors.white),
                tooltip: "Twitter",
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.mail, color: Colors.white),
                tooltip: "LinkedIn",
              ),
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
                    Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          TextField(
                            controller: _identifierController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              hintText: "Identifiant unique du document",
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Téléversez votre fichier PDF",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          PdfDropZone(
                            selectedFile: _selectedFile,
                            onFilePicked: (file) {
                              setState(() {
                                _selectedFile = file;
                              });
                            },
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _verifyDocument,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            child: Text("Vérifier l'authenticité",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 18, color: Colors.white)),
                          ),
                        ],
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
