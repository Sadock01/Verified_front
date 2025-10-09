import 'package:doc_authentificator/cubits/types/type_doc_cubit.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:flutter/material.dart';

class TypeWidget extends StatelessWidget {
  final TypeDocModel type;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TypeWidget({
    Key? key,
    required this.type,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nom du type et date de création
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.name,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Créé le ${type.createdAt?.toLocal()}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Boutons Editer et Supprimer
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               TextButton(      onPressed: onEdit, child: Text("Edit",style: Theme.of(context).textTheme.labelSmall!.copyWith(
                 fontSize: 12,
                 color: Colors.grey,
               ),)),
                TextButton(onPressed:onDelete, child: Text("Supprimer",style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontSize: 12,
                  color: Colors.red,
                ),))
              ],
            ),
          ],
        ),
        Divider(
          color: Colors.grey.withOpacity(0.5), // couleur du diviseur
          thickness: 1, // épaisseur du diviseur
        ),
      ],
    );
  }
}
