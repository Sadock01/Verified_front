import 'dart:developer';

import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
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
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context) * 0.19,
                height: 35,
                decoration: BoxDecoration(
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
                      Icon(
                        Icons.bar_chart,
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
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context) * 0.19,
                height: 35,
                decoration: BoxDecoration(
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
                      Icon(
                        Icons.folder,
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
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
              roleId == 1
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: Const.screenWidth(context) * 0.19,
                      height: 35,
                      decoration: BoxDecoration(
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
                            Icon(
                              Icons.history,
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
                    )
                  : SizedBox(),
              roleId == 1
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: Const.screenWidth(context) * 0.19,
                      height: 35,
                      decoration: BoxDecoration(
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
                            Icon(
                              Icons.history,
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
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: Const.screenWidth(context) * 0.19,
                      height: 35,
                      decoration: BoxDecoration(
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
                            Icon(
                              Icons.group,
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: Const.screenWidth(context) * 0.19,
                            height: 35,
                            decoration: BoxDecoration(
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
            ],
          )),
    );
  }
}
