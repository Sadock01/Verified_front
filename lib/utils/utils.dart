import 'package:doc_authentificator/services/authentification_service.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../cubits/types/type_doc_cubit.dart';
import '../models/type_doc_model.dart';

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
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
                    style: Theme.of(context).textTheme.labelSmall,
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
                            "${_capitalize(entry.key)} : ${entry.value}",
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
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: document.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                children: [
                                  TextSpan(
                                    text: "${_capitalize(entry.key)} : ",
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: "${entry.value}", style: Theme.of(context).textTheme.labelMedium),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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

  static Future<void> showVerificationModelNew({
    required BuildContext context,
    required bool isSuccess,
    required String title,
    required String message,
    Map<String, dynamic>? enteredData,
    Map<String, dynamic>? misMatch,
    String? description,
  }) {
    final color = isSuccess ? Colors.green : Colors.red;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: EdgeInsets.all(24),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  elevation: 6,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ),
              ),
              Container(
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
                      // ✅ Animation
                      CircleAvatar(
                        backgroundColor: color.withOpacity(0.1),
                        radius: 40,
                        child: Lottie.asset(
                          isSuccess ? 'images/success.json' : 'images/failure.json',
                          width: 252,
                          height: 252,
                          repeat: true,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ✅ Titre
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // ✅ Message principal
                      Text(
                        message,
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),


                      // ✅ Données saisies
                      if (enteredData != null && enteredData.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Données saisies :",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: enteredData.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                    children: [
                                      TextSpan(
                                        text: "${_capitalize(entry.key)} : ",
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: "${entry.value ?? 'N/A'}"),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ✅ Données saisies
                      if (misMatch != null  && misMatch.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Données incorrectes :",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: misMatch.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${_capitalize(entry.key)} : ",
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: "${entry.value ?? 'N/A'}"),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ✅ Description du document si succès
                      if (isSuccess && description != null && description.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Description du document :",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            description,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ✅ Bouton de fermeture
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text("Fermer", style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showAddTypeDialog(BuildContext context, TextEditingController controller) async {
    controller.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "Ajouter un type",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: controller,
                        style: Theme.of(context).textTheme.labelSmall,
                        decoration: InputDecoration(
                          hintText: "Nom du type",
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              context.read<TypeDocCubit>().addType(
                                    TypeDocModel(name: controller.text.trim()),
                                  );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            "Ajouter",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton fermer dans le coin supérieur droit
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 6,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
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



  static Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          title: Text(
            'Déconnexion',
            style: Theme.of(dialogContext).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Voulez-vous vraiment vous déconnecter ?',
            style: Theme.of(dialogContext).textTheme.labelSmall,
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Annuler',
                    style: Theme.of(dialogContext).textTheme.labelSmall!.copyWith(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop(); // Ferme le dialog

                    final response = await AuthentificationService.logout();

                    // Exemple : response = {"status_code": 200, "message": "Déconnexion réussie."}
                    final int status = response['status_code'];
                    final String message = response['message'] ?? 'Erreur inconnue.';

                    await Future.delayed(Duration(milliseconds: 200)); // Délai optionnel pour fluidité

                    if (status == 200) {
                      ElegantNotification.success(
                        width: MediaQuery.of(context).size.width * 0.5,
                        notificationMargin: 10,
                        description: Text(
                          "Déconnexion réussie.",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        position: Alignment.topRight,
                        animation: AnimationType.fromRight,
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                      ).show(context);
                    } else {
                      ElegantNotification.error(
                        width: MediaQuery.of(context).size.width * 0.5,
                        notificationMargin: 10,
                        description: Text(
                          "Échec de la déconnexion. $message",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        position: Alignment.topRight,
                        animation: AnimationType.fromRight,
                        icon: const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                      ).show(context);
                    }

                    // Redirection après la notification
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  ),
                  child: Text(
                    'Se déconnecter',
                    style: Theme.of(dialogContext).textTheme.labelSmall!.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  static String toUpperCaseInput(String input) {
    return input.toUpperCase();
  }

  static String? formatManualDateInput(String rawInput) {
    final regex = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');

    if (!regex.hasMatch(rawInput)) {
      return null; // Format incorrect
    }

    try {
      final match = regex.firstMatch(rawInput);
      final day = int.parse(match!.group(1)!);
      final month = int.parse(match.group(2)!);
      final year = int.parse(match.group(3)!);

      // Vérifie que la date est valide
      final date = DateTime(year, month, day);

      // Si date invalide, Dart ajuste automatiquement la date => on vérifie manuellement
      if (date.day != day || date.month != month || date.year != year) {
        return null;
      }

      // Retourne la date formatée proprement (ex. : 22-07-2023)
      final formatted = "${day.toString().padLeft(2, '0')}-"
          "${month.toString().padLeft(2, '0')}-"
          "${year.toString()}";

      return formatted;
    } catch (e) {
      return null;
    }
  }
}
