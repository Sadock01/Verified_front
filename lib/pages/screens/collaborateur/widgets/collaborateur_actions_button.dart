import 'dart:developer';

import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/documents_model.dart';
// adapte le chemin selon ton projet

class CollaborateurActionsButton extends StatelessWidget {
  final CollaborateursModel collab;

  const CollaborateurActionsButton({super.key, required this.collab});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: "Modifier Collaborateur",
          child: IconButton(
            icon: Image.asset(
              "assets/images/editer.png",
              width: 22,
              height: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              context.go('/document/update/${collab.id}');
              log("l'id du collaborateur updated: ${collab.id}");
            },
          ),
        ),
        Tooltip(
          message: "Afficher Collaborateur",
          child: IconButton(
            icon: Image.asset(
              "assets/images/vue.png",
              width: 22,
              height: 22,
              color: Colors.black,
            ),
            onPressed: () {
              context.go('/document/details/${collab.id}');
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
