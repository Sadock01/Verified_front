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
  bool isEditing = false;

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

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Widget _buildTableHeader(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: theme.textTheme.displaySmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String value, int index, String key, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: isEditing
          ? TextFormField(
              initialValue: value,
              onChanged: (val) => updateEntity(index, key, val),
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 12),
              decoration: InputDecoration(
                hintText: key == 'date_information' ? 'YYYY-MM-DD' : '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            )
          : Center(
              child: Text(
                value.isEmpty ? '-' : value,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: value.isEmpty ? theme.colorScheme.onSurface.withOpacity(0.5) : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
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
            const SizedBox(height: 20),
            
            // En-tête avec bouton de modification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Documents extraits (${editableDocs.length})",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: toggleEditMode,
                  icon: Icon(isEditing ? Icons.visibility : Icons.edit),
                  label: Text(isEditing ? "Mode lecture" : "Modifier"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Colors.orange : theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tableau style CustomExpandedTable
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // En-tête du tableau
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: _buildTableHeader("ID", theme)),
                          Container(width: 1, height: 50, color: theme.colorScheme.outline.withOpacity(0.3)),
                          Expanded(flex: 2, child: _buildTableHeader("Type", theme)),
                          Container(width: 1, height: 50, color: theme.colorScheme.outline.withOpacity(0.3)),
                          Expanded(flex: 3, child: _buildTableHeader("Description", theme)),
                          Container(width: 1, height: 50, color: theme.colorScheme.outline.withOpacity(0.3)),
                          Expanded(flex: 2, child: _buildTableHeader("Bénéficiaire", theme)),
                          Container(width: 1, height: 50, color: theme.colorScheme.outline.withOpacity(0.3)),
                          Expanded(flex: 2, child: _buildTableHeader("Date", theme)),
                        ],
                      ),
                    ),
                    
                    // Corps du tableau
                    Expanded(
                      child: ListView.builder(
                        itemCount: editableDocs.length,
                        itemBuilder: (context, index) {
                          final entity = editableDocs[index]['entities'] ?? {};
                          final isEven = index % 2 == 0;
                          
                          return Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: isEven ? Colors.transparent : theme.colorScheme.surface.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: _buildTableCell(entity['identifier'] ?? '', index, 'identifier', theme)),
                                Container(width: 1, height: 60, color: theme.colorScheme.outline.withOpacity(0.2)),
                                Expanded(flex: 2, child: _buildTableCell(entity['type_document'] ?? '', index, 'type_document', theme)),
                                Container(width: 1, height: 60, color: theme.colorScheme.outline.withOpacity(0.2)),
                                Expanded(flex: 3, child: _buildTableCell(entity['description'] ?? '', index, 'description', theme)),
                                Container(width: 1, height: 60, color: theme.colorScheme.outline.withOpacity(0.2)),
                                Expanded(flex: 2, child: _buildTableCell(entity['beneficiaire'] ?? '', index, 'beneficiaire', theme)),
                                Container(width: 1, height: 60, color: theme.colorScheme.outline.withOpacity(0.2)),
                                Expanded(flex: 2, child: _buildTableCell(entity['date_information'] ?? '', index, 'date_information', theme)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
