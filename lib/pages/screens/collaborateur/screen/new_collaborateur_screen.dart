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
import '../../../../widgets/status_toggle_widget.dart';

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
  bool _isActive = true; // Par défaut, le collaborateur est actif

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
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 1150;
    
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
        drawer: isLargeScreen ? null : const NewDrawerDashboard(),
        body: Row(
          children: [
            if (isLargeScreen) const NewDrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (isLargeScreen) {
                        return SizedBox(height: 60, child: AppBarDrawerWidget());
                      } else {
                        return AppBarVendorWidget();
                      }
                    },
                  ),
                  // Contenu principal
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Column(
                            children: [
                              // En-tête avec icône
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.PRIMARY_BLUE_COLOR,
                                      AppColors.PRIMARY_BLUE_COLOR.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.PRIMARY_BLUE_COLOR.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.person_add_rounded,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Nouveau Collaborateur",
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Ajoutez un nouveau membre à votre équipe",
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Formulaire avec design moderne
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Titre du formulaire
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColors.PRIMARY_BLUE_COLOR.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.edit_rounded,
                                              color: AppColors.PRIMARY_BLUE_COLOR,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "Informations du collaborateur",
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 30),
                                      
                                      // Champs du formulaire
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildFormField(
                                              controller: _firstNameController,
                                              label: "Prénom",
                                              hint: "Ex: John",
                                              icon: Icons.person_outline,
                                              validator: (value) => value == null || value.isEmpty ? "Veuillez entrer le prénom." : null,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildFormField(
                                              controller: _lastNameController,
                                              label: "Nom",
                                              hint: "Ex: Doe",
                                              icon: Icons.person_outline,
                                              validator: (value) => value == null || value.isEmpty ? "Veuillez entrer le nom." : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      _buildFormField(
                                        controller: _emailController,
                                        label: "Adresse email",
                                        hint: "Ex: exemple@mail.test",
                                        icon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
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
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Sélecteur de rôle avec design moderne
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.work_outline,
                                                color: AppColors.PRIMARY_BLUE_COLOR,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Rôle du collaborateur",
                                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey[300]!),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: DropdownButtonFormField<int>(
                                              value: _selectedRoleId,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                border: InputBorder.none,
                                              ),
                                              items: roles.map<DropdownMenuItem<int>>((role) {
                                                return DropdownMenuItem<int>(
                                                  value: role['id'] as int,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          color: _getRoleColor(role['id'] as int).withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                        child: Icon(
                                                          _getRoleIcon(role['id'] as int),
                                                          color: _getRoleColor(role['id'] as int),
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        role['name'] as String,
                                                        style: Theme.of(context).textTheme.labelSmall,
                                                      ),
                                                    ],
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
                                      
                                      // Sélecteur de statut
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.toggle_on,
                                                color: AppColors.PRIMARY_BLUE_COLOR,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Statut du collaborateur",
                                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey[300]!),
                                              borderRadius: BorderRadius.circular(5),
                                              color: _isActive 
                                                ? Colors.green.withOpacity(0.05)
                                                : Colors.grey.withOpacity(0.05),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _isActive ? "Actif" : "Inactif",
                                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: _isActive ? Colors.green : Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _isActive 
                                                        ? "Le collaborateur pourra se connecter et utiliser l'application"
                                                        : "Le collaborateur ne pourra pas se connecter",
                                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                AnimatedStatusToggleWidget(
                                                  isActive: _isActive,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isActive = value;
                                                    });
                                                  },
                                                  activeText: "Actif",
                                                  inactiveText: "Inactif",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 40),
                                      
                                      // Bouton d'enregistrement
                                      Center(
                                        child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.PRIMARY_BLUE_COLOR,
                                                AppColors.PRIMARY_BLUE_COLOR.withOpacity(0.8),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.PRIMARY_BLUE_COLOR.withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                final collaborateur = CollaborateursModel(
                                                  firstName: _firstNameController.text,
                                                  lastName: _lastNameController.text,
                                                  email: _emailController.text,
                                                  status: _isActive,
                                                  roleId: _selectedRoleId ?? 2,
                                                );
                                                context.read<CollaborateursCubit>().addCollaborateur(collaborateur);
                                              }
                                            },
                                            icon: const Icon(Icons.save_rounded, color: Colors.white, size: 24),
                                            label: Text(
                                              "Enregistrer le collaborateur",
                                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
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

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.PRIMARY_BLUE_COLOR,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[500],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(int roleId) {
    switch (roleId) {
      case 1:
        return Colors.red; // Administrateur
      case 2:
        return Colors.blue; // Vérificateur
      case 3:
        return Colors.green; // Rédacteur
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(int roleId) {
    switch (roleId) {
      case 1:
        return Icons.admin_panel_settings; // Administrateur
      case 2:
        return Icons.verified_user; // Vérificateur
      case 3:
        return Icons.edit; // Rédacteur
      default:
        return Icons.person;
    }
  }
}
