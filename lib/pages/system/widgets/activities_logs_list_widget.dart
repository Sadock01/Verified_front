import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_state.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/pages/screens/collaborateur/widgets/collaborateur_actions_button.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/customs_data_table.dart';

class CollaborateurTabWidget extends StatelessWidget {
  const CollaborateurTabWidget({super.key, required this.state});

  final CollaborateursState state;

  @override
  Widget build(BuildContext context) {
    final collab = state.listCollaborateurs;
    return CustomDataTable(
      columns: _buildColumns(context),
      rows: _buildRows(context, collab),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("User ID", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Nom et Prenom", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Email", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Status", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Action", style: Theme.of(context).textTheme.displayMedium),
      ),
    ];
  }

  List<DataRow> _buildRows(BuildContext context, List<CollaborateursModel> collab) {
    return collab.map((collab) {
      return DataRow(
        cells: [
          DataCell(Text(collab.firstName, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(collab.lastName, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(collab.email, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: collab.status == 1 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              ),
              child: Text(
                collab.status == 1 ? 'Activer' : 'Désactiver',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: collab.status == 1 ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          DataCell(CollaborateurActionsButton(collab: collab)),
        ],
      );
    }).toList();
  }
}
