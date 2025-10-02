import 'dart:developer';

import 'package:doc_authentificator/widgets/collaborator_drawer_widget.dart';
import 'package:doc_authentificator/widgets/document_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../const/const.dart';
import '../cubits/collaborateurs/collaborateurs_cubit.dart';
import '../cubits/switch_page/switch_page_cubit.dart';
import '../cubits/switch_page/switch_page_state.dart';
import '../utils/app_colors.dart';
import '../utils/shared_preferences_utils.dart';

class NewDrawerDashboard extends StatefulWidget {
  const NewDrawerDashboard({super.key});

  @override
  State<NewDrawerDashboard> createState() => _NewDrawerDashboardState();
}

class _NewDrawerDashboardState extends State<NewDrawerDashboard> {
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
    final isLargeScreen = MediaQuery.of(context).size.width > 1150;
    return BlocBuilder<SwitchPageCubit, SwitchPageState>(
      builder: (context, state) => Container(
        width: isLargeScreen ? Const.screenWidth(context) * 0.2 : 300,
        height: Const.screenHeight(context),
        color: AppColors.PRIMARY_BLACK3_COLOR,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12),
                child: Row(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      // margin: EdgeInsets.only(bottom: 8, top: 5),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: Const.screenWidth(context) * 0.12,
                      height: 45,
                      decoration:
                          BoxDecoration(image: DecorationImage(fit: BoxFit.contain, image: AssetImage('assets/images/Verified_original.png'))),
                    ),
                    // const SizedBox(width: 12),
                    // const Text(
                    //   "Shofy.",
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 13),
              Divider(
                height: 5,
                thickness: 1,
                color: Colors.grey[700],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context),
                height: 35,
                decoration: BoxDecoration(
                  color: context.read<SwitchPageCubit>().state.selectedPage == 0 ? Theme.of(context).colorScheme.primary : Colors.transparent,
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
                        color: context.read<SwitchPageCubit>().state.selectedPage == 0 ? Colors.white : Colors.grey[500],
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Acceuil',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.read<SwitchPageCubit>().state.selectedPage == 0 ? Colors.white : Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              DocumentDrawerWidget(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context),
                height: 35,
                decoration: BoxDecoration(
                  color: context.read<SwitchPageCubit>().state.selectedPage == 3 ? Theme.of(context).colorScheme.primary : Colors.transparent,
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
                        color: context.read<SwitchPageCubit>().state.selectedPage == 3 ? Colors.white : Colors.grey[500],
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Historiques',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: context.read<SwitchPageCubit>().state.selectedPage == 3 ? Colors.white : Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              roleId == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: Const.screenWidth(context),
                          height: 35,
                          decoration: BoxDecoration(
                            color:
                                context.read<SwitchPageCubit>().state.selectedPage == 4 ? Theme.of(context).colorScheme.primary : Colors.transparent,
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
                                  color: context.read<SwitchPageCubit>().state.selectedPage == 4 ? Colors.white : Colors.grey[500],
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Rapports',
                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                        color: context.read<SwitchPageCubit>().state.selectedPage == 4 ? Colors.white : Colors.grey[500],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CollaboratorDrawerWidget(),
                        Container(
                          // margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          padding: EdgeInsets.symmetric(vertical: 10),

                          width: Const.screenWidth(context),
                          height: 35,
                          decoration: BoxDecoration(
                            color: context.read<SwitchPageCubit>().state.selectedPage == 9.9
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                          ),
                          child: TextButton(
                            onPressed: () {
                              context.read<SwitchPageCubit>().switchPage(9.9);
                              context.go('/system');
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
                                  "assets/images/administrator.png",
                                  width: 20,
                                  height: 20,
                                  color: context.read<SwitchPageCubit>().state.selectedPage == 9.9 ? Colors.white : Colors.grey[500],
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Plateform Administration',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: context.read<SwitchPageCubit>().state.selectedPage == 9.9 ? Colors.white : Colors.grey[500],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
