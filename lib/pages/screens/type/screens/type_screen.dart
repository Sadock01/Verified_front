import 'dart:developer';

import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:doc_authentificator/services/type_service.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../cubits/types/type_doc_cubit.dart';
import '../../../../cubits/types/type_doc_state.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../../../../widgets/new_drawer_dashboard.dart';
import '../widgets/type_widget.dart';


class TypeManagerScreen extends StatefulWidget {
  @override
  State<TypeManagerScreen> createState() => _TypeManagerScreenState();
}

class _TypeManagerScreenState extends State<TypeManagerScreen> {
  final TextEditingController _typeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();

    context.read<TypeDocCubit>().getAllType(1);
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      // Rediriger vers la page de login
      context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.displaySmall,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(3),bottomLeft: Radius.circular(3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(3),bottomLeft: Radius.circular(3)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(3),bottomLeft: Radius.circular(3)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1150;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return BlocListener<TypeDocCubit, TypeDocState>(
      listener: (context, state) {
        // Ne pas afficher de notifications pour les suppressions (gérées dans le dialogue)
        final isDeletion = state.errorMessage.toLowerCase().contains('supprim') || 
                          state.errorMessage.toLowerCase().contains('suppression') ||
                          state.errorMessage.toLowerCase().contains('rattaché');
        
        if (state.typeStatus == TypeStatus.sucess && state.errorMessage.isNotEmpty && !isDeletion) {
          ElegantNotification.success(
            title: const Text("Succès"),
            background: theme.cardColor,
            description: Text(
              state.errorMessage,
              style: theme.textTheme.labelSmall,
            ),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          ).show(context);
          
          // Rafraîchir la liste après succès (sauf pour les suppressions qui sont gérées dans le dialogue)
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.read<TypeDocCubit>().getAllType(1);
            }
          });
        } else if (state.typeStatus == TypeStatus.error && state.errorMessage.isNotEmpty && !isDeletion) {
          ElegantNotification.error(
            title: const Text("Erreur"),
            background: theme.cardColor,
            description: Text(
              state.errorMessage,
              style: theme.textTheme.labelSmall,
            ),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(Icons.error_outline, color: Colors.red),
          ).show(context);
        }
      },
      child: BlocBuilder<TypeDocCubit, TypeDocState>(
        builder: (context, state) { // Fournir le Cubit
          return Scaffold(
              drawer: isLargeScreen ? null : const NewDrawerDashboard(),
              body: Row(
                  children: [
                  if (isLargeScreen) const NewDrawerDashboard(),

                Expanded(
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          if (isLargeScreen) {
                            return SizedBox(height: 60, child: AppBarDrawerWidget());
                          } else {
                            return AppBarVendorWidget();
                          }
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            width: 500,

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child:   SizedBox(
                                        height: 45,
                                        child: TextFormField(
                                          controller: _typeNameController,
                                          validator: (value) => (value == null || value.isEmpty) ? "Veuillez entrer le libelle du Type" : null,
                                          style: Theme.of(context).textTheme.labelSmall,
                                          decoration: _inputDecoration("Nouveau type"),
                                        ),
                                      ),
                        
                                    ),
                                    SizedBox(
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final typeName = _typeNameController.text;
                                          if (typeName.isNotEmpty) {
                                            final newType = TypeDocModel(
                                              id: null, // L'id sera généré côté backend
                                              name: typeName,
                                              createdAt: DateTime.now(),
                                            );
                        
                                            context.read<TypeDocCubit>().addType(newType);
                                            _typeNameController.clear();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Ajouter',
                                          style: theme
                                              .textTheme
                                              .labelSmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
SizedBox(height: 2),
                                Expanded(
                                  child: BlocBuilder<TypeDocCubit, TypeDocState>(
                                    builder: (context, state) {
                                      log("state.typeStatus: ${state.typeStatus}");
                                      // Vérifier si l'état est mis à jour
                                      if (state.typeStatus == TypeStatus.loaded) {
                                        final types = state.listType;
                        
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: theme.cardColor,
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 20,
                                                offset: Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ListView.builder(
                                            itemCount: types.length,
                                            itemBuilder: (context, index) {
                                              final type = types[index];
                                              return TypeWidget(
                                                type: type,
                                                onDelete: () {
                                                  if (type.id != null) {
                                                    showDeleteConfirmation(context, type);
                                                  }
                                                },
                                                onEdit: () {
                                                  log("Le bouton Éditer a été cliqué");
                                                  showEditDialog(context, index, type);
                                                }
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      else if (state.typeStatus == TypeStatus.loading) {
                                        return Center(child: CircularProgressIndicator(strokeWidth: 1,));
                                      } else{
                                        return Center(child: Text('Erreur lors du chargement.'));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showEditDialog(BuildContext context, int index, TypeDocModel type) {
    final _editController = TextEditingController(text: type.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: Text('Modifier le Type',style: Theme.of(context).textTheme.labelMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Libelle du Type",style: Theme.of(context).textTheme.labelSmall,),
            TextField(
              controller: _editController,

              style: Theme.of(context).textTheme.labelSmall,
              decoration: InputDecoration(

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newName = _editController.text.trim();
              if (newName.isNotEmpty && type.id != null) {
                // Appeler le Cubit pour mettre à jour le type
                final updatedType = TypeDocModel(
                  id: type.id, // Conserver l'ID existant
                  name: newName,
                  createdAt: type.createdAt, // Conserver la date de création
                );

                // Mettre à jour le type via le Cubit
                await context.read<TypeDocCubit>().updateType(type.id!, updatedType);
                
                Navigator.of(context).pop(); // Fermer le dialogue
                
                // Rafraîchir la liste après la mise à jour
                context.read<TypeDocCubit>().getAllType(1);
              }
            },
            child: Text('Enregistrer',style: Theme.of(context).textTheme.labelSmall),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer le dialogue sans enregistrer
            },
            child: Text('Annuler',style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[300])),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmation(BuildContext context, TypeDocModel type) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Supprimer le type",
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Êtes-vous sûr de vouloir supprimer le type \"${type.name}\" ?",
              style: theme.textTheme.labelSmall,
            ),
            SizedBox(height: 8),
            Text(
              "Cette action est irréversible.",
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              "Annuler",
              style: theme.textTheme.labelSmall,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Fermer le dialogue de confirmation
              
              if (type.id == null) {
                ElegantNotification.error(
                  background: theme.cardColor,
                  description: Text(
                    "Impossible de supprimer : ID du type manquant.",
                    style: theme.textTheme.labelSmall,
                  ),
                  position: Alignment.topRight,
                  animation: AnimationType.fromRight,
                ).show(context);
                return;
              }

              try {
                final result = await context.read<TypeDocCubit>().deleteType(type.id!);
                
                log("Résultat de la suppression: $result");

                // Vérifier que le contexte est toujours valide avant d'afficher les notifications
                if (!context.mounted) return;

                if (result['success'] == true && result['status_code'] == 200) {
                  // ✅ Notification de succès
                  ElegantNotification.success(
                    title: const Text("Succès"),
                    background: theme.cardColor,
                    description: Text(
                      result['message'] ?? "Type supprimé avec succès",
                      style: theme.textTheme.labelSmall,
                    ),
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                  ).show(context);
                  
                  // Rafraîchir la liste après succès pour éviter les erreurs
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      context.read<TypeDocCubit>().getAllType(1);
                    }
                  });
                } else {
                  // Gérer les différents codes d'erreur
                  final statusCode = result['status_code'] ?? 500;
                  String errorMessage = result['message'] ?? "Erreur lors de la suppression du type.";
                  
                  // Pour le cas 409, le message du backend contient déjà toutes les informations
                  // Pas besoin de modifier le message, il est déjà complet
                  if (statusCode == 404) {
                    // Type introuvable
                    errorMessage = "Ce type n'existe plus.";
                  } else if (statusCode == 500) {
                    // Erreur serveur
                    errorMessage = "Erreur serveur : $errorMessage";
                  }

                  // ❌ Notification d'erreur
                  ElegantNotification.error(
                    title: const Text("Erreur"),
                    background: theme.cardColor,
                    description: Text(
                      errorMessage,
                      style: theme.textTheme.labelSmall,
                    ),
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                    icon: const Icon(Icons.error_outline, color: Colors.red),
                  ).show(context);
                }
              } catch (e) {
                log("Erreur lors de la suppression: $e");
                
                // Vérifier que le contexte est toujours valide
                if (!context.mounted) return;
                
                // ❌ Notification d'erreur système
                ElegantNotification.error(
                  title: const Text("Erreur"),
                  background: theme.cardColor,
                  description: Text(
                    "Une erreur est survenue lors de la suppression du type: $e",
                    style: theme.textTheme.labelSmall,
                  ),
                  position: Alignment.topRight,
                  animation: AnimationType.fromRight,
                  icon: const Icon(Icons.error_outline, color: Colors.red),
                ).show(context);
              }
            },
            child: Text(
              "Supprimer",
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


