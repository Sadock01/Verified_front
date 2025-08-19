import 'dart:developer';

import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:doc_authentificator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/collaborateurs/collaborateurs_cubit.dart';
import '../utils/shared_preferences_utils.dart';

class DrawerDashboard extends StatefulWidget {
  const DrawerDashboard({super.key});

  @override
  State<DrawerDashboard> createState() => _DrawerDashboardState();
}

class _DrawerDashboardState extends State<DrawerDashboard> {
  int? roleId;

  @override
  void initState() {
    super.initState();
    context.read<CollaborateursCubit>().getCustomerDetails();
    _loadRoleId();
  }

  Future<void> _loadRoleId() async {
    final id = await SharedPreferencesUtils.getInt('role_id');
    log("Voici le roleId: $id");
    setState(() {
      roleId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchPageCubit, SwitchPageState>(
      builder: (context, state) => Container(
          width: Const.screenWidth(context) * 0.2,
          height: Const.screenHeight(context),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8, top: 5),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context) * 0.12,
                height: 45,
                decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/logo_mix.png'))),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context) * 0.19,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    context.read<SwitchPageCubit>().state.selectedPage == 0
                        ? BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                          )
                        : BoxShadow(

                            // Décalage horizontal et vertical de l'ombre
                            )
                  ],
                  color: context.read<SwitchPageCubit>().state.selectedPage == 0 ? Theme.of(context).colorScheme.primary : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(0);
                    context.go('/dashboard');
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.transparent; // Pas d'effet au survol
                        }
                        return null; // Laisser les autres états par défaut
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/dashboards.png",
                        color: context.read<SwitchPageCubit>().state.selectedPage == 0 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: context.read<SwitchPageCubit>().state.selectedPage == 0 ? Colors.white : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context) * 0.19,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    context.read<SwitchPageCubit>().state.selectedPage == 1
                        ? BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                          )
                        : context.read<SwitchPageCubit>().state.selectedPage == 2
                            ? BoxShadow()
                            : context.read<SwitchPageCubit>().state.selectedPage == 5
                                ? BoxShadow()
                                : context.read<SwitchPageCubit>().state.selectedPage == 5
                                    ? BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                      )
                                    : BoxShadow(),
                  ],
                  color: context.read<SwitchPageCubit>().state.selectedPage == 1
                      ? Theme.of(context).colorScheme.primary
                      : context.read<SwitchPageCubit>().state.selectedPage == 2
                          ? Colors.white
                          : context.read<SwitchPageCubit>().state.selectedPage == 5
                              ? Colors.white
                              : context.read<SwitchPageCubit>().state.selectedPage == 5
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(1);
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.transparent; // Pas d'effet au survol
                        }
                        return null; // Laisser les autres états par défaut
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/documentation.png",
                        color: context.read<SwitchPageCubit>().state.selectedPage == 1 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Documents',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: context.read<SwitchPageCubit>().state.selectedPage == 1 ? Colors.white : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              context.read<SwitchPageCubit>().state.selectedPage == 1 ||
                      context.read<SwitchPageCubit>().state.selectedPage == 5 ||
                      context.read<SwitchPageCubit>().state.selectedPage == 2
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                context.read<SwitchPageCubit>().state.selectedPage == 5
                                    ? BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                      )
                                    : BoxShadow(

                                        // Décalage horizontal et vertical de l'ombre
                                        )
                              ],
                              color: context.read<SwitchPageCubit>().state.selectedPage == 5 ? Theme.of(context).colorScheme.primary : Colors.white,
                            ),
                            child: TextButton(
                              onPressed: () {
                                context.read<SwitchPageCubit>().switchPage(5);
                                context.go('/document/List_document');
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return Colors.transparent; // Pas d'effet au survol
                                    }
                                    return null; // Laisser les autres états par défaut
                                  },
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.subdirectory_arrow_right,
                                    color:
                                        context.read<SwitchPageCubit>().state.selectedPage == 5 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: Const.screenWidth(context) * 0.1,
                                    child: Text(
                                      'Listes',
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            color: context.read<SwitchPageCubit>().state.selectedPage == 5 ? Colors.white : Colors.black,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                context.read<SwitchPageCubit>().state.selectedPage == 2
                                    ? BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                      )
                                    : BoxShadow(

                                        // Décalage horizontal et vertical de l'ombre
                                        )
                              ],
                              color: context.read<SwitchPageCubit>().state.selectedPage == 2 ? Theme.of(context).colorScheme.primary : Colors.white,
                            ),
                            child: TextButton(
                              onPressed: () {
                                context.read<SwitchPageCubit>().switchPage(2);
                                context.go('/document/nouveau-document');
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return Colors.transparent; // Pas d'effet au survol
                                    }
                                    return null; // Laisser les autres états par défaut
                                  },
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.subdirectory_arrow_right,
                                    color:
                                        context.read<SwitchPageCubit>().state.selectedPage == 2 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: Const.screenWidth(context) * 0.1,
                                    child: Text(
                                      'Ajouter',
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            color: context.read<SwitchPageCubit>().state.selectedPage == 2 ? Colors.white : Colors.black,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context) * 0.19,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    context.read<SwitchPageCubit>().state.selectedPage == 3
                        ? BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                          )
                        : BoxShadow(

                            // Décalage horizontal et vertical de l'ombre
                            )
                  ],
                  color: context.read<SwitchPageCubit>().state.selectedPage == 3 ? Theme.of(context).colorScheme.primary : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(3);
                    context.go('/historiques');
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.transparent; // Pas d'effet au survol
                        }
                        return null; // Laisser les autres états par défaut
                      },
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/history.png",
                        color: context.read<SwitchPageCubit>().state.selectedPage == 3 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Historiques',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              color: context.read<SwitchPageCubit>().state.selectedPage == 3 ? Colors.white : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(),
              roleId == 1
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: Const.screenWidth(context) * 0.19,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          context.read<SwitchPageCubit>().state.selectedPage == 4
                              ? BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                )
                              : BoxShadow(

                                  // Décalage horizontal et vertical de l'ombre
                                  )
                        ],
                        color: context.read<SwitchPageCubit>().state.selectedPage == 4 ? Theme.of(context).colorScheme.primary : Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.read<SwitchPageCubit>().switchPage(4);
                          context.go('/rapports');
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.transparent; // Pas d'effet au survol
                              }
                              return null; // Laisser les autres états par défaut
                            },
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/marketing.png",
                              color: context.read<SwitchPageCubit>().state.selectedPage == 4 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Rapports',
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    color: context.read<SwitchPageCubit>().state.selectedPage == 4 ? Colors.white : Colors.black,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              roleId == 1
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: Const.screenWidth(context) * 0.19,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          context.read<SwitchPageCubit>().state.selectedPage == 6
                              ? BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                )
                              : context.read<SwitchPageCubit>().state.selectedPage == 7
                                  ? BoxShadow()
                                  : context.read<SwitchPageCubit>().state.selectedPage == 8
                                      ? BoxShadow()
                                      : context.read<SwitchPageCubit>().state.selectedPage == 8
                                          ? BoxShadow(
                                              color: Colors.grey.withValues(alpha: 0.2),
                                              spreadRadius: 10,
                                              blurRadius: 10,
                                              offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                            )
                                          : BoxShadow(),
                        ],
                        color: context.read<SwitchPageCubit>().state.selectedPage == 6
                            ? Theme.of(context).colorScheme.primary
                            : context.read<SwitchPageCubit>().state.selectedPage == 7
                                ? Colors.white
                                : context.read<SwitchPageCubit>().state.selectedPage == 8
                                    ? Colors.white
                                    : context.read<SwitchPageCubit>().state.selectedPage == 8
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.read<SwitchPageCubit>().switchPage(6);
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.transparent; // Pas d'effet au survol
                              }
                              return null; // Laisser les autres états par défaut
                            },
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/people.png",
                              color: context.read<SwitchPageCubit>().state.selectedPage == 6 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: Const.screenWidth(context) * 0.1,
                              child: Text(
                                'Collaborateurs',
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: context.read<SwitchPageCubit>().state.selectedPage == 6 ? Colors.white : Colors.black,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
              context.read<SwitchPageCubit>().state.selectedPage == 6 ||
                      context.read<SwitchPageCubit>().state.selectedPage == 7 ||
                      context.read<SwitchPageCubit>().state.selectedPage == 8
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                context.read<SwitchPageCubit>().state.selectedPage == 7
                                    ? BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                      )
                                    : BoxShadow(

                                        // Décalage horizontal et vertical de l'ombre
                                        )
                              ],
                              color: context.read<SwitchPageCubit>().state.selectedPage == 7 ? Theme.of(context).colorScheme.primary : Colors.white,
                            ),
                            child: TextButton(
                              onPressed: () {
                                context.read<SwitchPageCubit>().switchPage(7);
                                context.go('/collaborateur/List_collaborateurs');
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return Colors.transparent; // Pas d'effet au survol
                                    }
                                    return null; // Laisser les autres états par défaut
                                  },
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.subdirectory_arrow_right,
                                    color:
                                        context.read<SwitchPageCubit>().state.selectedPage == 7 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: Const.screenWidth(context) * 0.1,
                                    child: Text(
                                      'Listes',
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            color: context.read<SwitchPageCubit>().state.selectedPage == 7 ? Colors.white : Colors.black,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                context.read<SwitchPageCubit>().state.selectedPage == 8
                                    ? BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
                                      )
                                    : BoxShadow(

                                        // Décalage horizontal et vertical de l'ombre
                                        )
                              ],
                              color: context.read<SwitchPageCubit>().state.selectedPage == 8 ? Theme.of(context).colorScheme.primary : Colors.white,
                            ),
                            child: TextButton(
                              onPressed: () {
                                context.read<SwitchPageCubit>().switchPage(8);
                                context.go('/collaborateur/nouveau_collaborateur');
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered)) {
                                      return Colors.transparent; // Pas d'effet au survol
                                    }
                                    return null; // Laisser les autres états par défaut
                                  },
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.subdirectory_arrow_right,
                                    color:
                                        context.read<SwitchPageCubit>().state.selectedPage == 8 ? Colors.white : Colors.grey.withValues(alpha: 0.2),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: Const.screenWidth(context) * 0.1,
                                    child: Text(
                                      'Ajouter',
                                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            color: context.read<SwitchPageCubit>().state.selectedPage == 8 ? Colors.white : Colors.black,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    Utils.showLogoutConfirmationDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Déconnexion",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
