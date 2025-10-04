import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:doc_authentificator/models/documents_model.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

import '../../../../const/const.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/new_drawer_dashboard.dart';

class DetailsDocumentScreen extends StatefulWidget {
  final int documentId;

  const DetailsDocumentScreen({super.key, required this.documentId});

  @override
  State<DetailsDocumentScreen> createState() => _DetailsDocumentScreenState();
}

class _DetailsDocumentScreenState extends State<DetailsDocumentScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les détails du document
    context.read<DocumentCubit>().getDocumentById(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, docState) {
        // Si le document n'est pas encore chargé
        if (docState.selectedDocument == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final document = docState.selectedDocument!;

        return Scaffold(
          body: Row(
            children: [
              NewDrawerDashboard(),
              Expanded(
                child: Column(
                  children: [
                    AppBarDrawerWidget(),
                    Container(

                      width: Const.screenWidth(context),
                      height: Const.screenHeight(context) * 0.1,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        //borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Détails Document",
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          _buildDocumentInfoCard(theme, document),
                          const SizedBox(height: 20),
                          _buildActionsCard(theme, document),
                          const SizedBox(height: 20),
                          //_buildEditAndDeleteButtons(theme, document),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocumentInfoCard(ThemeData theme, DocumentsModel document) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 5,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Identifiant", document.identifier),
            _buildInfoRow("Description", document.descriptionDocument),
            _buildInfoRow("Bénéficiaire", document.beneficiaire ?? "Non précisé"),
            _buildInfoRow("Date de Délivrance", document.dateInfo ?? "Pas renseignée"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label:", style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildActionsCard(ThemeData theme, DocumentsModel document) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 5,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Actions disponibles:", style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de modification du document
                Navigator.pushNamed(context, '/document/update/${document.id}');
              },
              child: Text("Modifier le Document", style: theme.textTheme.labelSmall!.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'impression ou d'autres actions
                _showActionNotImplemented(theme);
              },
              child: Text("Supprimer le Document", style: theme.textTheme.labelSmall!.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditAndDeleteButtons(ThemeData theme, DocumentsModel document) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(

          onPressed: () {
            // Naviguer vers la page de mise à jour
            Navigator.pushNamed(context, '/document/update/${document.id}');
          },
          child: Text("Modifier", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        ElevatedButton(

          onPressed: () => _showDeleteConfirmation(context, document),
          child: Text("Supprimer", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }

  void _showActionNotImplemented(ThemeData theme) {
    ElegantNotification.info(
      background: theme.cardColor,
      width: MediaQuery.of(context).size.width * 0.5,
      description: Text("Cette action n'est pas encore implémentée.", style: theme.textTheme.labelSmall),
      position: Alignment.topRight,
      animation: AnimationType.fromRight,
      icon: const Icon(Icons.info_outline, color: Colors.blue),
    ).show(context);
  }

  // Affiche la confirmation de suppression
  void _showDeleteConfirmation(BuildContext context, DocumentsModel document) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text("Supprimer le document", style: theme.textTheme.labelSmall),
        content: Text("Êtes-vous sûr de vouloir supprimer ce document ?", style: theme.textTheme.labelMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler", style: theme.textTheme.labelSmall),
          ),
          TextButton(
            onPressed: () {
              // Supprimer le document
              //context.read<DocumentCubit>().deleteDocument(document.id);
              Navigator.of(context).pop();
            },
            child: Text("Supprimer", style: theme.textTheme.labelSmall!.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
