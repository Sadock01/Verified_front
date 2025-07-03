import 'package:flutter/material.dart';

class Utils {
  static Future<void> showVerificationModal({
    required BuildContext context,
    required bool isSuccess,
    required String title,
    required String message,
    Map<String, dynamic>? reasons, // Optionnel : détails erreurs
    Map<String, dynamic>? document, // Optionnel : infos document
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        final theme = Theme.of(context);

        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              SizedBox(width: 8),
              Flexible(child: Text(title)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: theme.textTheme.bodyMedium),
                SizedBox(height: 16),
                if (reasons != null && reasons.isNotEmpty) ...[
                  Text("Raisons :", style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ...reasons.entries.map((entry) => Text("- ${entry.key}: ${entry.value}")),
                  SizedBox(height: 16),
                ],
                if (document != null && document.isNotEmpty) ...[
                  Text("Détails du document :", style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ...document.entries.map((entry) => Text("${_capitalize(entry.key)} : ${entry.value}")),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
