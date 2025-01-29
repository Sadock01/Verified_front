import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/login/login_cubit.dart';
import 'package:doc_authentificator/cubits/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.error) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  state.errorMessage,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Valider",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state.loginStatus == LoginStatus.loaded) {
          context.go('/dashboard');
        }
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: Const.screenWidth(context) / 2,
                  height: Const.screenHeight(context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/image_auth2.jpg"),
                    ),
                  ),
                ),
                SizedBox(width: Const.screenWidth(context) * 0.1),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        width: Const.screenWidth(context) * 0.15,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    "assets/images/Verified_original.png"))),
                      ),
                      Text(
                        "Bienvenue sur le Dashboard de Verified!",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        width: Const.screenWidth(context) * 0.3,
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                          style: Theme.of(context).textTheme.displaySmall,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary), // Couleur du bord quand le champ est désactivé
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary), // Couleur du bord quand le champ est sélectionné
                              borderRadius: BorderRadius.circular(
                                  10), // Arrondi des bords
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .red), // Couleur du bord en cas d'erreur
                              borderRadius: BorderRadius.circular(
                                  10), // Arrondi des bords
                            ),
                            hintText: "email",
                            hintStyle: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: Const.screenWidth(context) * 0.3,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: Theme.of(context).textTheme.displaySmall,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary), // Couleur du bord quand le champ est désactivé
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary), // Couleur du bord quand le champ est sélectionné
                              borderRadius: BorderRadius.circular(
                                  10), // Arrondi des bords
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .red), // Couleur du bord en cas d'erreur
                              borderRadius: BorderRadius.circular(
                                  10), // Arrondi des bords
                            ),
                            hintText: "mot de Passe",
                            hintStyle: Theme.of(context).textTheme.displaySmall,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          if (state.loginStatus == LoginStatus.loading) {
                            return CircularProgressIndicator();
                          }
                          return SizedBox(
                            width: Const.screenWidth(context) * 0.2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(10),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final email = _emailController.text;
                                  final password = _passwordController.text;
                                  context
                                      .read<LoginCubit>()
                                      .login(email, password);
                                }
                              },
                              child: Text(
                                'Se connecter',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
