import 'dart:developer';

import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_state.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/collaborateurs_model.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/appbar_dashboard.dart';
import '../../../../widgets/new_drawer_dashboard.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _statusController;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _showEditDialog(CollaborateursModel user) {
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _emailController = TextEditingController(text: user.email);
    _roleController = TextEditingController(text: user.roleName.toString());
    // _statusController = TextEditingController(text: user.status.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: Text('Modifier les informations',style: Theme.of(context).textTheme.labelMedium,),
        content: SingleChildScrollView(
          child: Container(
            width:  600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Prénom', _firstNameController),
                _buildTextField('Nom', _lastNameController),
                _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                // _buildTextField('Rôle (ID)', _roleController, keyboardType: TextInputType.number),
                // _buildTextField('Statut', _statusController, keyboardType: TextInputType.number),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Annuler',style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey[300]),)),
          ElevatedButton(
            onPressed: () {
              // Appelle ici ton Cubit pour mettre à jour les infos avec les nouvelles valeurs
              // Ex: context.read<CustomerCubit>().updateUser(...);
              final collaborateurModel = CollaborateursModel(

                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                email: _emailController.text,
                roleId: int.tryParse(_roleController.text) ?? user.roleId, // attention parsing int
                status: user.status, // ou dropdown bool ici si tu veux gérer le statut modifiable

              );
log("user.id: ${user.id}");
              context.read<CollaborateursCubit>().updateCollaborateur(user.id!, collaborateurModel);
              Navigator.pop(context);
           
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,style: Theme.of(context).textTheme.labelSmall,),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: Theme.of(context).textTheme.labelSmall,
            decoration: InputDecoration(

              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    // context.read<ReportCubit>().getAllDocReport(1, widget.documentId);
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      // Rediriger vers la page de login
      context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  String _getInitials(CollaborateursModel user) {
    String first = user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : "";
    String last = user.lastName.isNotEmpty ? user.lastName[0].toUpperCase() : "";
    return "$first$last";
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1150;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return    BlocListener<CollaborateursCubit, CollaborateursState>(
        listener: (context, state) {
          if (state.collaborateurStatus == CollaborateurStatus.update) {
            ElegantNotification.success(
              background: theme.cardColor,
              description: Text(
                state.errorMessage,
                style: theme.textTheme.labelSmall,
              ),
              position: Alignment.topRight,
              animation: AnimationType.fromRight,
            ).show(context);

            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) context.go('/profile');
            });
          } else if (state.collaborateurStatus == CollaborateurStatus.error) {
            ElegantNotification.error(
              background: theme.cardColor,
              description: Text(
                state.errorMessage,
                style: theme.textTheme.labelSmall,
              ),
              position: Alignment.topRight,
              animation: AnimationType.fromRight,
            ).show(context);
          }
        },
        child:  Scaffold(
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
              child: BlocBuilder<CollaborateursCubit, CollaborateursState>(
                builder: (context, state) {
                  if (state.collaborateurStatus == CollaborateurStatus.loading) {
                    return CircularProgressIndicator();
                  } else if (state.collaborateurStatus == CollaborateurStatus.error) {
                    return Text('Erreur : ${state.errorMessage}');
                  } else if (state.selectedCollaborateur == null) {
                    return Text('Aucun utilisateur trouvé');
                  } else {
                    final user = state.selectedCollaborateur!;
                    return Column(

                      children: [
                        SizedBox(height: 40),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            _getInitials(user),
                            style: theme.textTheme.labelMedium?.copyWith(fontSize: 60,color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),SizedBox(height: 20),
                        Container(
                          constraints: BoxConstraints(maxWidth: 450),
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [



                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex: 2,child: _buildInfoRow('Nom', user.lastName)),
                                  Expanded(flex: 2,child: _buildInfoRow('Prénom', user.firstName)),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(flex:2,child: _buildInfoRow('Email', user.email)),
                                  Expanded(flex: 2,child: _buildInfoRow('Rôle', user.roleName.toString())),
                                ],
                              ),
                              SizedBox(height: 12),
                              _buildInfoRow(
                                'Statut',
                                Row(
                                  children: [
                                    Text(
                                      user.status == true ? 'Actif' : 'Inactif',
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    if (user.status == true) ...[
                                      SizedBox(width: 8),
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),


                              SizedBox(height: 24),

                              ElevatedButton.icon(
                                onPressed: () => _showEditDialog(user),
                                icon: Icon(Icons.edit,color: Colors.white,),
                                label: Text('Modifier'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
            ],
          ),

        )])));
      }



  Widget _buildInfoRow(String label, dynamic value) {
    final theme = Theme.of(context);

    Widget valueWidget;

    if (value is String) {
      valueWidget = Text(
        value,
        style: theme.textTheme.labelSmall,
        overflow: TextOverflow.ellipsis,
      );
    } else if (value is Widget) {
      valueWidget = value;
    } else {
      valueWidget = SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }


}

