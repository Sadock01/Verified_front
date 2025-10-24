import 'package:flutter/material.dart';
import '../cubits/rapports/report_state.dart';

class CustomExpandedTableReports extends StatelessWidget {
  final ReportState state;

  const CustomExpandedTableReports({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // Colonnes pour les rapports
    final columns = [
      "Utilisateur",
      "Date de modification",
      "Changements",
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
          ...state.listReports.asMap().entries.map((entry) {
            final index = entry.key;
            final report = entry.value;
            final isOdd = index % 2 == 0; // Lignes impaires (1, 3, 5, etc.)

            return Container(
              height: 80,
              decoration: BoxDecoration(
                color: isOdd 
                    ? (isLight ? Colors.grey[50] : Colors.grey[900])
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  // Utilisateur
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[300]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${report.firstName} ${report.lastName}",
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "ID: ${report.userId}",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  
                  // Date de modification
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[300]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          report.formattedDate,
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Modifié",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.blue[700],
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Changements
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[300]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (report.changes.isNotEmpty) ...[
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${report.changes.length}",
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "changement(s)",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report.changes.take(2).map((change) => change.field).join(", "),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (report.changes.length > 2)
                            Text(
                              "...",
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                            ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Aucun changement",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.grey[500],
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
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
                        // Bouton Voir les détails
                        InkWell(
                          onTap: () {
                            // TODO: Naviguer vers les détails du rapport
                            print('Voir détails du rapport pour ${report.firstName} ${report.lastName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.visibility,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Bouton Voir les changements
                        InkWell(
                          onTap: () {
                            // TODO: Afficher les changements détaillés
                            print('Voir changements pour ${report.firstName} ${report.lastName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.history,
                              size: 16,
                              color: Colors.orange[700],
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
}