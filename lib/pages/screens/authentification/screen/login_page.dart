import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/login/login_cubit.dart';
import 'package:doc_authentificator/cubits/login/login_state.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
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
        } else if (state.loginStatus == LoginStatus.loaded) {
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

          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              context.go('/dashboard');
            }
          });
        }
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: Const.screenWidth(context) / 2,
                    height: Const.screenHeight(context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/verified_imag.png"),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Container(
                          //   margin: EdgeInsets.only(bottom: 15),
                          //   width: Const.screenWidth(context) * 0.15,
                          //   height: 50,
                          //   decoration:
                          //       BoxDecoration(image: DecorationImage(fit: BoxFit.contain, image: AssetImage("assets/images/Verified_original.png"))),
                          // ),
                          Text(
                            "Bienvenue!",
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Accédez à vos documents en toute sécurité.",
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 35),
                          SizedBox(
                            width: Const.screenWidth(context) * 0.3,
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Veuillez entrer un email valide';
                                }
                                return null;
                              },
                              style: Theme.of(context).textTheme.displaySmall,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
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
                                hintText: "Email",
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
                                prefixIcon: Icon(Icons.key),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red), // Couleur du bord en cas d'erreur
                                  borderRadius: BorderRadius.circular(5), // Arrondi des bords
                                ),
                                hintText: "Mot de Passe",
                                hintStyle: Theme.of(context).textTheme.displaySmall,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: Colors.grey[500],
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
                              return SizedBox(
                                width: Const.screenWidth(context) * 0.3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;
                                      context.read<LoginCubit>().login(email, password);
                                    }
                                  },
                                  child: state.loginStatus == LoginStatus.loading
                                      ? SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 1,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.login, color: Colors.white),
                                            SizedBox(width: 10),
                                            Text(
                                              'Se connecter',
                                              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
