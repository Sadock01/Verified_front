import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/models/verification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/customs_data_table.dart';

class HistoryTabWidget extends StatelessWidget {
  const HistoryTabWidget({super.key, required this.state});

  final VerificationState state;

  @override
  Widget build(BuildContext context) {
    final verifies = state.listVerifications;
    return CustomDataTable(
      columns: _buildColumns(context),
      rows: _buildRows(context, verifies),
    );
  }

  // Colonnes à afficher pour les informations clés (en français et plus claires)
  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("Adresse IP", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Navigateur", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Type d'appareil", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Document trouvé", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Correspondance", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Erreurs", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Date de vérification", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Actions", style: Theme.of(context).textTheme.displayMedium),
      ),
    ];
  }

  // Construction des lignes avec les données importantes
  List<DataRow> _buildRows(BuildContext context, List<VerificationModel> verifies) {
    return verifies.map((verif) {
      return DataRow(
        cells: [
          DataCell(Text(verif.ipAddress ?? 'Non disponible', style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(verif.browser ?? 'Non disponible', style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(verif.deviceType ?? 'Non disponible', style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),

          // Document trouvé avec un fond coloré (vert pour "Oui" et rouge pour "Non")
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: verif.documentFound ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                verif.documentFound ? 'Oui' : 'Non',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Correspondance avec un fond coloré (vert pour "Oui" et rouge pour "Non")
          DataCell(
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: verif.isMatching ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                verif.isMatching ? 'Oui' : 'Non',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Erreurs
          DataCell(Text(verif.mismatches?.toString() ?? 'Aucune', style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),

          // Date de création avec formatage
          DataCell(Text("${DateFormat('dd/MM/yyyy  HH:mm').format(verif.createdAt.toLocal())}", style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),

          // Actions
          DataCell(
            TextButton(
              onPressed: () {
                // Affiche les détails supplémentaires
              },
              child: Text('Afficher plus', style: Theme.of(context).textTheme.labelSmall),
            ),
          ),
        ],
      );
    }).toList();
  }
}
