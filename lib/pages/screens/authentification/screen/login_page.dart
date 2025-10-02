import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../const/const.dart';
import '../../../../cubits/login/login_cubit.dart';
import '../../../../cubits/login/login_state.dart';
import '../../../../utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.displaySmall,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(5),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.loginStatus == LoginStatus.error) {
            ElegantNotification.error(
              width: Const.screenWidth(context) * 0.5,
              notificationMargin: 10,
              description: Text(state.errorMessage, style: Theme.of(context).textTheme.labelSmall),
              position: Alignment.topRight,
              animation: AnimationType.fromRight,
              icon: const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
            ).show(context);
          } else if (state.loginStatus == LoginStatus.loaded) {
            ElegantNotification.success(
              width: Const.screenWidth(context) * 0.5,
              notificationMargin: 10,
              description: Text(state.errorMessage, style: Theme.of(context).textTheme.labelSmall),
              position: Alignment.topRight,
              animation: AnimationType.fromRight,
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            ).show(context);

            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted) {
                context.go('/dashboard');
              }
            });
          }
        },
        child:  Builder(
          builder: (context) {
            return Scaffold(
              body: LayoutBuilder(builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 1150;

                final formWidget = Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Bienvenue!",
                        style: GoogleFonts.albertSans(
                          fontSize: isDesktop ? 40 : 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Entrer vos identifiants administrateur pour accéder au Dashboard de Verified.",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                        style: Theme.of(context).textTheme.labelSmall,
                        decoration: _inputDecoration("Email"),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Mot de passe",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: Theme.of(context).textTheme.labelSmall,
                        decoration: InputDecoration(
                          hintText: "Mot de passe",
                          hintStyle: Theme.of(context).textTheme.displaySmall,
                          prefixIcon: Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey[500],
                            ),
                            onPressed: () {
                              setState(() => _isPasswordVisible = !_isPasswordVisible);
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Mot de passe oublié?",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: AppColors.PRIMARY_BLUE_COLOR,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text.trim();
                                  context.read<LoginCubit>().login(email, password);
                                }
                              },
                              child: state.loginStatus == LoginStatus.loading
                                  ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                                  : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text("Se connecter", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );

                if (isDesktop) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Const.screenWidth(context) * 0.08),
                          child: formWidget,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.PRIMARY_BLUE_COLOR),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset("assets/images/verified_imag.png", fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        margin: const EdgeInsets.only(top: 100),
                        padding: const EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                        ),
                        child: formWidget,
                      ),
                    ),
                  );
                }
              }),
            );
          }
        ));}
  }

