import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_cubit.dart';
import 'package:doc_authentificator/cubits/collaborateurs/collaborateurs_state.dart';
import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:doc_authentificator/widgets/appbar_dashboard.dart';
import 'package:doc_authentificator/widgets/drawer_dashboard.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/shared_preferences_utils.dart';
import '../../../../widgets/app_bar_drawer_widget.dart';
import '../../../../widgets/new_drawer_dashboard.dart';

class NewCollaborateurScreen extends StatefulWidget {
  const NewCollaborateurScreen({super.key});

  @override
  State<NewCollaborateurScreen> createState() => _NewCollaborateurScreenState();
}

class _NewCollaborateurScreenState extends State<NewCollaborateurScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int? _selectedRoleId = 2;

  final List<Map<String, dynamic>> roles = [
    {'id': 1, 'name': 'Administrateur'},
    {'id': 2, 'name': 'Vérificateur'},
    {'id': 3, 'name': 'Rédacteur'},
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    final token = SharedPreferencesUtils.getString('auth_token');
    if (token == null || token.isEmpty) {
      // Rediriger vers la page de login
      context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return BlocListener<CollaborateursCubit, CollaborateursState>(
      listener: (context, state) {
        if (state.collaborateurStatus == CollaborateurStatus.success) {
          ElegantNotification.success(
            notificationMargin: 10,
            description: Text(state.errorMessage, style: Theme.of(context).textTheme.labelSmall),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ).show(context);

          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              context.go('/collaborateur/List_collaborateurs');
            }
          });
        }
        if (state.collaborateurStatus == CollaborateurStatus.error) {
          ElegantNotification.error(
            notificationMargin: 10,
            description: Text(state.errorMessage, style: Theme.of(context).textTheme.labelSmall),
            position: Alignment.topRight,
            animation: AnimationType.fromRight,
            icon: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          ).show(context);
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            NewDrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  AppBarDrawerWidget(),
                  // Titre
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    width: Const.screenWidth(context),
                    height: Const.screenHeight(context) * 0.1,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_BLUE_COLOR,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Nouveau Collaborateur",
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Formulaire
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    width: Const.screenWidth(context),
                    height: Const.screenHeight(context) * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: theme.cardColor,
                      boxShadow: [
                        isLight
                            ? BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 10,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              )
                            : BoxShadow()
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _firstNameController,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  decoration: InputDecoration(
                                    hintStyle: Theme.of(context).textTheme.labelSmall,
                                    hintText: "Ex: John",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? "Veuillez entrer nom." : null,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _lastNameController,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  decoration: InputDecoration(
                                    hintStyle: Theme.of(context).textTheme.labelSmall,
                                    hintText: "Ex: Doe",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? "Veuillez entrer Prenom." : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  decoration: InputDecoration(
                                    hintStyle: Theme.of(context).textTheme.labelSmall,
                                    hintText: "Ex: exemple@mail.test",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez entrer l'email.";
                                    }
                                    if (!value.contains('@')) {
                                      return "Veuillez entrer un email valide.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedRoleId,
                                  decoration: InputDecoration(
                                    hintText: "Rôle du collaborateur",
                                    hintStyle: Theme.of(context).textTheme.labelSmall,
                                    border: OutlineInputBorder(),
                                  ),
                                  items: roles.map<DropdownMenuItem<int>>((role) {
                                    return DropdownMenuItem<int>(
                                      value: role['id'] as int,
                                      child: Text(
                                        role['name'] as String,
                                        style: Theme.of(context).textTheme.labelSmall,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(() => _selectedRoleId = value),
                                  validator: (value) => value == null ? "Veuillez sélectionner un rôle." : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(height: 10),
                          SizedBox(
                            width: Const.screenWidth(context) * 0.4,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save, color: Colors.white),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Créer un nouveau collaborateur
                                  final collaborateur = CollaborateursModel(
                                    firstName: _firstNameController.text,
                                    lastName: _lastNameController.text,
                                    email: _emailController.text,
                                    roleId: 2, // Par défaut, roleId = 2
                                  );

                                  // Appeler le Cubit pour ajouter le collaborateur
                                  context.read<CollaborateursCubit>().addCollaborateur(collaborateur);
                                }
                              },
                              label: Text(
                                "Enregistrer",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
