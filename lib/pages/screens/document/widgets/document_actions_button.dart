import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/documents_model.dart';
// adapte le chemin selon ton projet

class DocumentActionButtons extends StatelessWidget {
  final DocumentsModel document;

  const DocumentActionButtons({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: "Modifier document",
          child: IconButton(
            icon: Image.asset(
              "assets/images/editer.png",
              width: 22,
              height: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.go('/document/update/${document.id}');
              log("l'id du doc updated: ${document.id}");
            },
          ),
        ),
        Tooltip(
          message: "Afficher document",
          child: IconButton(
            icon: Image.asset(
              "assets/images/vue.png",
              width: 22,
              height: 22,
              color: Colors.black,
            ),
            onPressed: () {
              context.go('/document/view/${document.identifier}');
            },
          ),
        ),
      ],
    );
  }

  // void _showDeleteConfirmation(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('Confirmer la suppression'),
  //       content: Text('Voulez-vous vraiment supprimer le document "${document.identifier}" ?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(ctx).pop(),
  //           child: const Text('Annuler'),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //             // TODO: Ajouter la logique de suppression (via Cubit par ex.)
  //             print("Suppression confirmée pour ${document.id}");
  //           },
  //           child: const Text('Supprimer'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
