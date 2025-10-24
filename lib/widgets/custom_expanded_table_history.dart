import 'package:flutter/material.dart';
import 'package:doc_authentificator/cubits/verification/verification_state.dart';
import 'package:doc_authentificator/models/verification_model.dart';
import 'package:intl/intl.dart';
import '../pages/screens/history/widgets/verification_details_dialog.dart';

class CustomExpandedTableHistory extends StatelessWidget {
  final VerificationState state;

  const CustomExpandedTableHistory({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // Colonnes simplifiées pour les historiques
    final columns = [
      "Identifiant",
      "Statut",
      "Date",
      "Actions",
    ];

    // Calcul de la largeur des colonnes
    final columnWidth = (screenWidth - 2) / columns.length;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // En-tête
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isLight ? Colors.grey[100] : Colors.grey[800],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: columns.map((column) {
                return Container(
                  width: columnWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(),
                  child: Text(
                    column,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLight ? Colors.grey[800] : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Lignes de données
          ...state.listVerifications.asMap().entries.map((entry) {
            final index = entry.key;
            final verification = entry.value;
            final isOdd = index % 2 == 0; // Lignes impaires (1, 3, 5, etc.)

            return Container(
              height: 60,
              decoration: BoxDecoration(
                color: isOdd 
                    ? (isLight ? Colors.grey[50] : Colors.grey[900])
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Identifiant
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          verification.identifier ?? "N/A",
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "ID: ${verification.id ?? 'N/A'}",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  
                  // Statut
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getStatusColor(verification.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getShortStatus(verification.status),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              verification.documentFound ? Icons.check_circle : Icons.cancel,
                              size: 10,
                              color: verification.documentFound ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              verification.documentFound ? "Oui" : "Non",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: verification.documentFound ? Colors.green : Colors.red,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Date
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(verification.createdAt),
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('HH:mm').format(verification.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Actions
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Bouton Afficher plus
                        InkWell(
                          onTap: () {
                            _showDetailsDialog(context, verification);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.blue[300]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 14,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Plus",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Bouton Voir les erreurs (si il y en a)
                        if (verification.mismatches != null && verification.mismatches!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              _showErrorsDialog(context, verification);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 16,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, VerificationModel verification) {
    showDialog(
      context: context,
      builder: (context) => VerificationDetailsDialog(verification: verification),
    );
  }

  void _showErrorsDialog(BuildContext context, VerificationModel verification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Erreurs détectées"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: verification.mismatches!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${entry.key}:",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(entry.value.toString(),style:  Theme.of(context).textTheme.labelSmall,),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Fermer"),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'information correspondante':
        return Colors.green;
      case 'information erronée':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getShortStatus(String status) {
    switch (status.toLowerCase()) {
      case 'information correspondante':
        return 'OK';
      case 'information erronée':
        return 'Erreur';
      default:
        return 'N/A';
    }
  }
}