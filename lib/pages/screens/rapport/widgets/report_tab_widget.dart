import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/cubits/rapports/report_state.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/models/report_model.dart';
import 'package:doc_authentificator/models/verification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/customs_data_table.dart';

class ReportTabWidget extends StatelessWidget {
  const ReportTabWidget({super.key, required this.state});

  final ReportState state;

  @override
  Widget build(BuildContext context) {
    final reports = state.listReports;
    return CustomDataTable(
      columns: _buildColumns(context),
      rows: _buildRows(context, reports),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("Prenom", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Nom", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Date de modification", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Ancienne valeur", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Nouvelle Valeur", style: Theme.of(context).textTheme.displayMedium),
      ),
    ];
  }

  List<DataRow> _buildRows(BuildContext context, List<ReportModel> reports) {
    return reports.map((rep) {
      return DataRow(
        cells: [
          DataCell(Text(rep.firstName, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(rep.lastName, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text("${DateFormat('dd/MM/yyyy  HH:mm').format(rep.modifiedAt!.toLocal())}",
              style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(rep.changes.isNotEmpty ? rep.changes[0].oldValue : "N/A",
              style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(Text(rep.changes.isNotEmpty ? rep.changes[0].newValue : "N/A",
              style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
        ],
      );
    }).toList();
  }
}
