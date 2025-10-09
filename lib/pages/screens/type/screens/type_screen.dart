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
    return  BlocBuilder<TypeDocCubit, TypeDocState>(
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
                                                  // context.read<TypeDocCubit>().deleteType(index);
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
        });
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
            onPressed: () {
              final newName = _editController.text;
              if (newName.isNotEmpty) {
                // Appeler le Cubit pour mettre à jour le type
                final updatedType = TypeDocModel(
                  id: type.id, // Conserver l'ID existant
                  name: newName,
                  createdAt: type.createdAt, // Conserver la date de création
                );

                // Mettre à jour le type via le Cubit

                Navigator.of(context).pop(); // Fermer le dialogue
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text("Modifier le Type", style: theme.textTheme.labelSmall),
        content: Text("Êtes-vous sûr de vouloir modifier le libelle du type ?", style: theme.textTheme.labelMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler", style: theme.textTheme.labelSmall),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Supprimer le document
                final result = await TypeService.updateType(type.id!, type);

                if (result["status_code"] == 200) {
                  // ✅ Notification de succès
                  ElegantNotification.success(
                    background: theme.cardColor,
                    width: MediaQuery.of(context).size.width * 0.5,
                    description: Text(
                      result['message'] ?? "Type modifié avec succès",
                      style: theme.textTheme.labelSmall,
                    ),
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                  ).show(context);

                  // ⏳ Attendre un peu avant de naviguer
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) context.go('/document/List_document');
                  });
                } else {
                  // ❌ Notification d'échec (code non 200)
                  ElegantNotification.error(
                    background: theme.cardColor,
                    width: MediaQuery.of(context).size.width * 0.5,
                    description: Text(
                      result['message'] ?? "Échec de la modification du type.",
                      style: theme.textTheme.labelSmall,
                    ),
                    position: Alignment.topRight,
                    animation: AnimationType.fromRight,
                    icon: const Icon(Icons.error_outline, color: Colors.red),
                  ).show(context);
                }
              } catch (e) {
                // ❌ Notification d'erreur système (exception, etc.)
                ElegantNotification.error(
                  background: theme.cardColor,
                  width: MediaQuery.of(context).size.width * 0.5,
                  description: Text(
                    "Une erreur est survenue lors de la modification du type.",
                    style: theme.textTheme.labelSmall,
                  ),
                  position: Alignment.topRight,
                  animation: AnimationType.fromRight,
                  icon: const Icon(Icons.error_outline, color: Colors.red),
                ).show(context);
              }
            },

            child: Text("Supprimer", style: theme.textTheme.labelSmall!.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}


