import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
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

  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("Identifiant", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Date de  verification", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Status", style: Theme.of(context).textTheme.displayMedium),
      ),
    ];
  }

  List<DataRow> _buildRows(BuildContext context, List<VerificationModel> verifies) {
    return verifies.map((verif) {
      return DataRow(
        cells: [
          DataCell(Text(verif.identifier, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text("${DateFormat('dd/MM/yyyy  HH:mm').format(verif.verificationDate!.toLocal())}",
              style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: verif.status == "Authentique" ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              ),
              child: Text(
                verif.status,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: verif.status == "Authentique" ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
