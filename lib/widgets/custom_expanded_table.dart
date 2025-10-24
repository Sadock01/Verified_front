import 'package:doc_authentificator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:doc_authentificator/pages/screens/document/widgets/document_actions_button.dart';

class CustomExpandedTable extends StatelessWidget {
  final DocumentState state;
  final double headingRowHeight;
  final Color? headingColor;
  final Color? alternateRowColor;
  final double rowHeight;

  const CustomExpandedTable({
    Key? key,
    required this.state,
    this.headingRowHeight = 50,
    this.headingColor,
    this.alternateRowColor = const Color(0xFFF5F5F5), // Couleur grise pour les lignes impaires
    this.rowHeight = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final documents = state.listDocuments;
    
    // Construction des colonnes
    final columns = _buildColumns(context);
    
    // Construction des lignes
    final rows = _buildRows(context, documents);
    
    // Largeur fixe pour éviter les problèmes de contraintes
    final screenWidth = MediaQuery.of(context).size.width;
    final columnWidth = (screenWidth - 2) / columns.length; // -2 pour la bordure
    
    // Calculer la hauteur totale nécessaire
    final totalHeight = headingRowHeight + (documents.length * rowHeight);
    
    return Container(
      width: screenWidth,
      height: totalHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // En-tête du tableau
          Container(
            height: headingRowHeight,
            decoration: BoxDecoration(
              color: headingColor ?? (isLight ? Colors.grey[300] : AppColors.PRIMARY_BLUE_COLOR.withValues(alpha: 0.5)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: columns.asMap().entries.map((entry) {
                final index = entry.key;
                final column = entry.value;
                return Container(
                  width: columnWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(),
                  child: Text(
                    column,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Corps du tableau avec lignes alternées
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final isOddRow = (index + 1) % 2 == 1; // Ligne impaire (1, 3, 5...)
            
            return Container(
              height: rowHeight,
              decoration: BoxDecoration(
                color: isOddRow && isLight? alternateRowColor : Colors.transparent,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
                ),
              ),
              child: Row(
                children: row.asMap().entries.map((cellEntry) {
                  final cellIndex = cellEntry.key;
                  final cell = cellEntry.value;
                  return Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(),
                    child: cell,
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  List<String> _buildColumns(BuildContext context) {
    return [
      "Identifiant",
      "Type", 
      "Bénéficiaire",
      "Action",
    ];
  }

  List<List<Widget>> _buildRows(BuildContext context, List<DocumentsModel> documents) {
    return documents.map((doc) {
      return [
        // Cellule 1: Identifiant
        Text(
          doc.identifier, 
          style: Theme.of(context).textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Cellule 2: Type
        Text(
          doc.typeName.toString(), 
          style: Theme.of(context).textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Cellule 3: Bénéficiaire
        Text(
          doc.beneficiaire ?? "John Doe", 
          style: Theme.of(context).textTheme.labelSmall,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Cellule 4: Actions
        DocumentActionButtons(document: doc),
      ];
    }).toList();
  }
}
