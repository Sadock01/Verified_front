import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:flutter/material.dart';

import '../../../../const/const.dart';
import '../../../../widgets/customs_data_table.dart';
import 'document_actions_button.dart';

class DocumentsTabWidget extends StatelessWidget {
  const DocumentsTabWidget({super.key, required this.state});

  final DocumentState state;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final documents = state.listDocuments;

    return CustomDataTable(
      columns: _buildColumns(context),
      rows: _buildRows(context, documents),
    );
  }

  List<DataRow> _buildRows(BuildContext context, List<DocumentsModel> documents) {
    return documents.map((doc) {
      return DataRow(
        cells: [
          DataCell(
            Text(doc.identifier, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
          ),
          DataCell(
            Text(doc.typeName.toString(), overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
          ),
          DataCell(
            Text(doc.beneficiaire ?? "John Doe", overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall),
          ),
          DataCell(DocumentActionButtons(document: doc)),
        ],
      );
    }).toList();
  }


  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("Identifiant", style: Theme.of(context).textTheme.displayMedium),
      ),
      // DataColumn(
      //   label: Text("Description", style: Theme.of(context).textTheme.displayMedium),
      // ),
      DataColumn(
        label: Text("Type", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Beneficiaire", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Action", style: Theme.of(context).textTheme.displayMedium),
      ),
    ];
  }

  // List<DataRow> _buildRows(BuildContext context, List<DocumentsModel> documents) {
  //   return documents.map((doc) {
  //     return DataRow(
  //       cells: [
  //         DataCell(
  //           Text(doc.identifier, overflow: TextOverflow.ellipsis),
  //         ),
  //
  //         // DataCell(SizedBox(
  //         //     width: Const.screenWidth(context) * 0.2,
  //         //     child: Text(doc.descriptionDocument, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis))),
  //
  //         DataCell(Text(doc.typeName.toString(), style: Theme.of(context).textTheme.labelSmall)),
  //         DataCell(Text(doc.beneficiaire ?? "John Doe", style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
  //
  //         DataCell(DocumentActionButtons(document: doc)),
  //       ],
  //     );
  //   }).toList();
  // }
}
