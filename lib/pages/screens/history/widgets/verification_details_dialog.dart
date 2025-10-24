import 'package:flutter/material.dart';
import '../../../../models/verification_model.dart';


class VerificationDetailsDialog extends StatelessWidget {
  final VerificationModel verification;

  const VerificationDetailsDialog({
    Key? key,
    required this.verification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: isLight
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[800]!,
                  ],
                ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête avec icône
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(verification.status).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(verification.status),
                size: 32,
                color: _getStatusColor(verification.status),
              ),
            ),
            const SizedBox(height: 20),
            
            // Titre
            Text(
              "Détails de la vérification",
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isLight ? Colors.grey[800] : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            
            // Sous-titre
            Text(
              "Informations techniques et erreurs",
              style: theme.textTheme.labelMedium?.copyWith(
                color: isLight ? Colors.grey[600] : Colors.grey[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Contenu scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Informations de base
                    _buildInfoSection(
                      context,
                      "Informations de base",
                      Icons.info_outline,
                      Colors.blue,
                      [
                        _buildInfoRow("Identifiant", verification.identifier ?? "N/A",context),
                        _buildInfoRow("Statut", verification.status,context),
                        _buildInfoRow("Date", _formatDate(verification.createdAt),context),
                        _buildInfoRow("Document trouvé", verification.documentFound ? "Oui" : "Non",context),
                        _buildInfoRow("Correspondance", verification.isMatching ? "Oui" : "Non",context),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Informations techniques
                    _buildInfoSection(
                      context,
                      "Informations techniques",
                      Icons.computer,
                      Colors.orange,
                      [
                        _buildInfoRow("Adresse IP", verification.ipAddress ?? "N/A",context),
                        _buildInfoRow("Navigateur", verification.browser ?? "N/A",context),
                        _buildInfoRow("Type d'appareil", verification.deviceType ?? "N/A",context),
                        _buildInfoRow("Plateforme", verification.platform ?? "N/A",context),
                        _buildInfoRow("Via fichier", verification.viaFile ? "Oui" : "Non",context),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Erreurs et incohérences
                    if (verification.mismatches != null && verification.mismatches!.isNotEmpty)
                      _buildInfoSection(
                        context,
                        "Erreurs détectées",
                        Icons.error_outline,
                        Colors.red,
                        verification.mismatches!.entries.map((entry) {
                          return _buildInfoRow(
                            entry.key,
                            entry.value.toString(),context
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Bouton de fermeture
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  "Fermer",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey[50] : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Colors.grey[600],
              ),
            ),
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'information correspondante':
        return Icons.check_circle;
      case 'information erronée':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
