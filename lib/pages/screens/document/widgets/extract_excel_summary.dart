import 'package:flutter/material.dart';

class ExtractedExcelDataSummary extends StatelessWidget {
  final List<Map<String, dynamic>> extractedDocuments;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ExtractedExcelDataSummary({
    super.key,
    required this.extractedDocuments,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
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
                color: Colors.amber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
              ),
              child: Text("Veuillez vérifier le résultat de l'extraction avant de procéder à l'enregistrement final.",
                  style: Theme.of(context).textTheme.displaySmall),
            ),
            SizedBox(height: 30),
            Text("Résumé des documents extraits", style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Affichage de la liste
            Expanded(
              child: ListView.separated(
                itemCount: extractedDocuments.length,
                separatorBuilder: (_, __) => Divider(
                  height: 30,
                  color: Colors.grey[300],
                ),
                itemBuilder: (context, index) {
                  final item = extractedDocuments[index];
                  final entities = item['entities'];

                  if (entities is! Map<String, dynamic>) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(
                        "⚠ Données invalides",
                        style: theme.textTheme.labelMedium,
                      ),
                      subtitle: Text("Format de données inattendu.", style: theme.textTheme.labelMedium),
                    );
                  }

                  final id = entities['identifier'] ?? 'Non spécifié';
                  final type = entities['type_document'] ?? 'Non spécifié';
                  final desc = entities['description'] ?? 'Non spécifiée';
                  final beneficiaire = entities['beneficiaire'] ?? 'Non spécifié';

                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text("🆔 $id", style: theme.textTheme.titleSmall),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📂 Type : $type', style: theme.textTheme.labelSmall),
                          Text('✏️ Description : $desc', style: theme.textTheme.labelSmall),
                          Text('👤 Bénéficiaire : $beneficiaire', style: theme.textTheme.labelSmall),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Boutons
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
                  onPressed: onCancel,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text("Valider et enregistrer (${extractedDocuments.length})"),
                  onPressed: onConfirm,
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
