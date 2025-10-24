import 'package:flutter/material.dart';
import '../cubits/collaborateurs/collaborateurs_state.dart';
import '../cubits/collaborateurs/collaborateurs_cubit.dart';
import '../widgets/status_toggle_widget.dart';
import '../widgets/change_status_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomExpandedTableCollaborateurs extends StatelessWidget {
  final CollaborateursState state;

  const CustomExpandedTableCollaborateurs({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // Colonnes pour les collaborateurs
    final columns = [
      "Nom",
      "Email",
      "Rôle",
      "Statut",
      // "Informations",
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
          ...state.listCollaborateurs.asMap().entries.map((entry) {
            final index = entry.key;
            final collaborateur = entry.value;
            final isOdd = index % 2 == 0; // Lignes impaires (1, 3, 5, etc.)

            return Container(
              height: 70,
              decoration: BoxDecoration(
                color: isOdd 
                    ? (isLight ? Colors.grey[50] : Colors.grey[900])
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  // Nom
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${collaborateur.firstName} ${collaborateur.lastName}",
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "ID: ${collaborateur.id}",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  
                  // Email
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          collaborateur.email,
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Email vérifié",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.blue[700],
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Rôle
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRoleColor(collaborateur.roleName),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            collaborateur.roleName ?? "N/A",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // const SizedBox(height: 4),
                        // Text(
                        //   "Niveau: ${_getRoleLevel(collaborateur.roleName)}",
                        //   style: theme.textTheme.labelSmall?.copyWith(
                        //     color: Colors.grey[600],
                        //     fontSize: 9,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  
                  // Statut avec toggle interactif
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(),
                    child: Center(
                      child: AnimatedStatusToggleWidget(
                        isActive: collaborateur.status ?? false,
                        onChanged: (newStatus) {
                          showChangeStatusDialog(
                            context: context,
                            collaborateurName: "${collaborateur.firstName} ${collaborateur.lastName}",
                            currentStatus: collaborateur.status ?? false,
                            onStatusChanged: (status) {
                              // TODO: Appeler le cubit pour changer le statut
                              context.read<CollaborateursCubit>().updateCollaborateurStatus(
                                collaborateur.id!, 
                                status
                              );
                            },
                          );
                        },
                        activeText: "Actif",
                        inactiveText: "Inactif",
                      ),
                    ),
                  ),
                  
                  // Date d'ajout
                  // Container(
                  //   width: columnWidth,
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  //   decoration: BoxDecoration(),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "Rôle ID: ${collaborateur.roleId ?? 'N/A'}",
                  //         style: theme.textTheme.labelSmall,
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       const SizedBox(height: 2),
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  //         decoration: BoxDecoration(
                  //           color: Colors.blue[100],
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Text(
                  //           "ID: ${collaborateur.id}",
                  //           style: theme.textTheme.labelSmall?.copyWith(
                  //             color: Colors.blue[700],
                  //             fontSize: 9,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  
                  // Actions
                  Container(
                    width: columnWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Bouton Voir profil
                        InkWell(
                          onTap: () {
                            // TODO: Naviguer vers le profil du collaborateur
                            print('Voir profil de ${collaborateur.firstName} ${collaborateur.lastName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Bouton Modifier
                        InkWell(
                          onTap: () {
                            // TODO: Modifier le collaborateur
                            print('Modifier ${collaborateur.firstName} ${collaborateur.lastName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.orange[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Bouton Supprimer
                        InkWell(
                          onTap: () {
                            // TODO: Supprimer le collaborateur
                            print('Supprimer ${collaborateur.firstName} ${collaborateur.lastName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.delete,
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

  Color _getRoleColor(String? roleName) {
    switch (roleName?.toLowerCase()) {
      case 'admin':
      case 'administrateur':
        return Colors.purple;
      case 'modérateur':
        return Colors.blue;
      case 'utilisateur':
        return Colors.green;
      case 'invité':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // String _getRoleLevel(String? roleName) {
  //   switch (roleName?.toLowerCase()) {
  //     case 'admin':
  //     case 'administrateur':
  //       return '5';
  //     case 'modérateur':
  //       return '4';
  //     case 'utilisateur':
  //       return '3';
  //     case 'invité':
  //       return '1';
  //     default:
  //       return '0';
  //   }
  // }

}