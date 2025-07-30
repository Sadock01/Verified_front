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

import '../../../../utils/shared_preferences_utils.dart';

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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _checkAuthentication();
  // }
  //
  // void _checkAuthentication() async {
  //   final token = SharedPreferencesUtils.getString('auth_token');
  //   if (token == null || token.isEmpty) {
  //     // Rediriger vers la page de login
  //     context.go('/login'); // ou Navigator.of(context).pushReplacementNamed('/login');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
            const DrawerDashboard(),
            Expanded(
              child: Column(
                children: [
                  const AppbarDashboard(),
                  // Titre
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: Const.screenWidth(context),
                    height: Const.screenHeight(context) * 0.1,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
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
                            borderRadius: BorderRadius.circular(10),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 10,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: "Prénom",
                                    labelStyle: Theme.of(context).textTheme.labelMedium,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez entrer le prénom.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Champ Nom
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: "Nom",
                                    labelStyle: Theme.of(context).textTheme.labelMedium,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez entrer le nom.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: Theme.of(context).textTheme.labelMedium,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Veuillez entrer le nom.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // Expanded(
                              //   flex: 2,
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButtonFormField<TypeDocModel>(
                              //       value: _selectedType,
                              //       hint: Text(
                              //         "Choisir un type",
                              //         style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
                              //       ),
                              //       items: state.listType.map((type) {
                              //         return DropdownMenuItem<TypeDocModel>(
                              //           value: type,
                              //           child: Text(
                              //             type.name,
                              //             style: theme.textTheme.labelMedium,
                              //           ),
                              //         );
                              //       }).toList(),
                              //       decoration: const InputDecoration.collapsed(hintText: ""),
                              //       borderRadius: BorderRadius.circular(12),
                              //       onChanged: (value) => setState(() => _selectedType = value),
                              //       validator: (value) => value == null ? "Veuillez sélectionner un type." : null,
                              //       isExpanded: false,
                              //       icon: const Icon(Icons.keyboard_arrow_down),
                              //       dropdownColor: Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          // Champ Email
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: Theme.of(context).textTheme.labelMedium,
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
                          const SizedBox(height: 20),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
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
                            child: Text(
                              "Enregistrer",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
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
