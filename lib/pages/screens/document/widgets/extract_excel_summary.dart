import 'package:flutter/material.dart';

class ExtractedExcelDataSummary extends StatefulWidget {
  final List<Map<String, dynamic>> extractedDocuments;
  final VoidCallback onCancel;
  final void Function(List<Map<String, dynamic>>) onConfirm;

  const ExtractedExcelDataSummary({
    super.key,
    required this.extractedDocuments,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<ExtractedExcelDataSummary> createState() => _ExtractedExcelDataSummaryState();
}

class _ExtractedExcelDataSummaryState extends State<ExtractedExcelDataSummary> {
  late List<Map<String, dynamic>> editableDocs;

  @override
  void initState() {
    super.initState();
    // Cloner les données pour modification
    editableDocs = widget.extractedDocuments
        .map((doc) => {
      ...doc,
      'entities': Map<String, dynamic>.from(doc['entities'] ?? {}),
    })
        .toList();
  }

  void updateEntity(int index, String key, dynamic newValue) {
    setState(() {
      editableDocs[index]['entities'][key] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: Text(
                "Veuillez vérifier les données extraites du fichier Excel et les modifier si nécessaire avant validation.",
                style: theme.textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Tableau des documents extraits",
              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(

                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    columnSpacing: 20,
                              dataRowHeight: 60,
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Type")),
                      DataColumn(label: Text("Description")),
                      DataColumn(label: Text("Bénéficiaire")),
                      DataColumn(label: Text("Date d'information")),
                    ],
                    rows: List.generate(editableDocs.length, (index) {
                      final entity = editableDocs[index]['entities'] ?? {};

                      return DataRow(
                        cells: [
                          DataCell(

                            TextFormField(
                              style: Theme.of(context).textTheme.labelSmall,
                              initialValue: entity['identifier'] ?? '',
                              onChanged: (val) => updateEntity(index, 'identifier', val),
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              style: Theme.of(context).textTheme.labelSmall,
                              initialValue: entity['type_document'] ?? '',
                              onChanged: (val) => updateEntity(index, 'type_document', val),
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              style: Theme.of(context).textTheme.labelSmall,
                              initialValue: entity['description'] ?? '',
                              onChanged: (val) => updateEntity(index, 'description', val),
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              style: Theme.of(context).textTheme.labelSmall,
                              initialValue: entity['beneficiaire'] ?? '',
                              onChanged: (val) => updateEntity(index, 'beneficiaire', val),
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              style: Theme.of(context).textTheme.labelSmall,
                              initialValue: entity['date_information'] ?? '',
                              onChanged: (val) => updateEntity(index, 'date_information', val),
                              decoration: const InputDecoration(hintText: 'YYYY-MM-DD'),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  label: const Text("Annuler"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: widget.onCancel,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text("Valider et enregistrer (${editableDocs.length})"),
                  onPressed: () => widget.onConfirm(editableDocs),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
