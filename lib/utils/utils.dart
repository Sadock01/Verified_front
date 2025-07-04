import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Utils {
  static Future<void> showVerificationModal({
    required BuildContext context,
    required bool isSuccess,
    required String title,
    required String message,
    Map<String, dynamic>? reasons,
    Map<String, dynamic>? document,
  }) {
    final color = isSuccess ? Colors.green : Colors.red;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icone centrée
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    radius: 40,
                    child: isSuccess
                        ? Lottie.asset(
                            'images/success.json',
                            width: 252,
                            height: 252,
                            repeat: true,
                          )
                        : Lottie.asset(
                            'images/failure.json',
                            width: 252,
                            height: 252,
                            repeat: true,
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Titre
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Message principal
                  Text(
                    message,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Raisons si échec
                  if (reasons != null && reasons.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Raisons :",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...reasons.entries.map((entry) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "- ${_capitalize(entry.key)} : ${entry.value}",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],
                  // Détails document si succès
                  if (document != null && document.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Détails du document :",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...document.entries.map((entry) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text("${_capitalize(entry.key)} : ${entry.value}"),
                        )),
                    const SizedBox(height: 16),
                  ],
                  // Bouton
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Fermer", style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
