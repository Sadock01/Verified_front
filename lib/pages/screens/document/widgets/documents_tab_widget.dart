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
    final documents = state.listDocuments;
    return CustomDataTable(
      columns: _buildColumns(context),
      rows: _buildRows(context, documents),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text("Identifiant", style: Theme.of(context).textTheme.displayMedium),
      ),
      DataColumn(
        label: Text("Description", style: Theme.of(context).textTheme.displayMedium),
      ),
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

  List<DataRow> _buildRows(BuildContext context, List<DocumentsModel> documents) {
    return documents.map((doc) {
      return DataRow(
        cells: [
          DataCell(Text(doc.identifier, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          DataCell(SizedBox(
              width: Const.screenWidth(context) * 0.2,
              child: Text(doc.descriptionDocument, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis))),

          DataCell(Text(doc.typeName.toString(), style: Theme.of(context).textTheme.labelSmall)),
          DataCell(Text(doc.beneficiaire ?? "John Doe", style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          // DataCell(
          //   PopupMenuButton<String>(
          //     onSelected: (value) {
          //       if (value == 'edit') {
          //         // Navigator ou context.go vers page edit
          //       } else if (value == 'view') {
          //         // Navigator ou context.go vers page view
          //       }
          //     },
          //     itemBuilder: (context) => [
          //       PopupMenuItem(
          //         value: 'edit',
          //         child: Text('Modifier document', style: Theme.of(context).textTheme.bodySmall),
          //       ),
          //       PopupMenuItem(
          //         value: 'view',
          //         child: Text('Afficher document', style: Theme.of(context).textTheme.bodySmall),
          //       ),
          //     ],
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).colorScheme.primary,
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       child: Text('Option', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
          //     ),
          //   ),
          // ),
          DataCell(DocumentActionButtons(document: doc)),
        ],
      );
    }).toList();
  }
}
