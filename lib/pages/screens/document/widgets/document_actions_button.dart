import 'dart:developer';

import 'package:doc_authentificator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/documents_model.dart';
// adapte le chemin selon ton projet

class DocumentActionButtons extends StatelessWidget {
  final DocumentsModel document;

  const DocumentActionButtons({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Row(
      children: [
        InkWell(
            onTap: () {
              context.go('/document/update/${document.id}');
              log("l'id du doc updated: ${document.id}");
            },
            child: Row(
              children: [

                  Image.asset(
                    "assets/images/editer.png",
                    width: 22,
                    height: 22,
                    color:  Colors.blue,
                  ),


                // Text("Editer",style: Theme.of(context).textTheme.displaySmall,)
              ],
            ),
          ),

        SizedBox(width: 8),
         InkWell(
            onTap: () {
              context.go('/document/view/${document.identifier}');
            },
            child: Row(
              children: [
               Image.asset(
                    "assets/images/vue.png",
                    width: 22,
                    height: 22,
                    color: Colors.grey[500],
                  ),


                // Text("Afficher",style: Theme.of(context).textTheme.displaySmall,)
              ],
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
