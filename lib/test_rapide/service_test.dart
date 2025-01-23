import 'dart:developer';

import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/services/document_service.dart';
import 'package:flutter/material.dart';

class ServiceTest extends StatefulWidget {
  const ServiceTest({super.key});

  @override
  State<ServiceTest> createState() => _ServiceTestState();
}

class _ServiceTestState extends State<ServiceTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          ElevatedButton(
            onPressed: () async {
              try {
                // Créez une instance de DocumentsModel
                DocumentsModel document = DocumentsModel(
                  identifier: "Doc-65",
                  descriptionDocument: "Voila le document",
                  typeId: 1,
                );

                // Appel de la méthode addDocument
                final String? message =
                    await DocumentService.addDocument(document);

                // Affichez le message dans la console ou une Snackbar
                log(message ?? "Aucun message reçu");
              } catch (e) {
                // Gérez les erreurs ici
                log("Erreur lors de l'ajout du document : $e");
              }
            },
            child: const Text("addDocument"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Créez une instance de DocumentsModel
                DocumentsModel document = DocumentsModel(
                  identifier: "Pas evident",
                  descriptionDocument: "Voila le document",
                  typeId: 1,
                );

                // Appel de la méthode addDocument
                final String? message =
                    await DocumentService.updateDocument(document);

                // Affichez le message dans la console ou une Snackbar
                log(message ?? "Aucun message reçu");
              } catch (e) {
                // Gérez les erreurs ici
                log("Erreur lors de l'ajout du document : $e");
              }
            },
            child: const Text("updateDocument"),
          ),
        ],
      ),
    );
  }
}
