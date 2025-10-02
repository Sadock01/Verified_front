import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/login/login_cubit.dart';
import 'package:doc_authentificator/cubits/login/login_state.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
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
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: Const.screenHeight(context),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_BLUE_COLOR,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/verified_imag.png"),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Opacity(
                            opacity: 0.2, // transparence
                            child: Image.asset(
                              'assets/images/quality-assurance.png', // Remplace par ton image
                              width: 165,
                              height: 165,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Opacity(
                            opacity: 0.2, // transparence
                            child: Image.asset(
                              'assets/images/verified.png', // Remplace par ton image
                              width: 165,
                              height: 165,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        width: Const.screenWidth(context) * 0.3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Bienvenue sur ",
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  width: Const.screenWidth(context) * 0.1,
                                  height: 80,
                                  decoration:
                                      BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/images/logo_mix.png"))),
                                ),
                              ],
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
                            SizedBox(
                              width: Const.screenWidth(context) * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (val) {
                                          setState(() => _rememberMe = val ?? false);
                                        },
                                      ),
                                      Text(
                                        "Remember Me",
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forgot Your Password?",
                                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: AppColors.PRIMARY_BLUE_COLOR),
                                    ),
                                  ),
                                ],
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
                                      backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
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
