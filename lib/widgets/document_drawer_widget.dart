// import 'dart:developer';

import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../const/const.dart';
import '../cubits/switch_page/switch_page_cubit.dart';

class DocumentDrawerWidget extends StatefulWidget {
  const DocumentDrawerWidget({super.key});

  @override
  State<DocumentDrawerWidget> createState() => _DocumentDrawerWidgetState();
}

class _DocumentDrawerWidgetState extends State<DocumentDrawerWidget> {
  // bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchPageCubit, SwitchPageState>(
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                // margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: Const.screenWidth(context),
                height: 35,

                child: TextButton(
                  onPressed: () {
                    if (state.isDocumentExpanded == true) {
                      context.read<SwitchPageCubit>().setDocExpanded(false);
                    } else {
                      context.read<SwitchPageCubit>().setDocExpanded(true);
                    }
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
                        color: state.isDocumentExpanded == true ? Colors.white : Colors.grey[500],
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Documents',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: state.isDocumentExpanded == true ? Colors.white : Colors.grey[500],
                            ),
                      ),
                      Spacer(),
                      state.isDocumentExpanded == true
                          ? InkWell(onTap: () {}, child: Icon(Icons.arrow_drop_down, color: Colors.white))
                          : Icon(
                              Icons.arrow_right,
                              color: Colors.grey[500],
                            ),
                    ],
                  ),
                ),
              ),
            ),
            state.isDocumentExpanded
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        width: Const.screenWidth(context),
                        height: 35,
                        decoration: BoxDecoration(
                          color:
                              context.read<SwitchPageCubit>().state.selectedPage == 1.1 ? Theme.of(context).colorScheme.primary : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.read<SwitchPageCubit>().switchPage(1.1);
                            context.go('/document/List-document');
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
                                color: context.read<SwitchPageCubit>().state.selectedPage == 1.1 ? Colors.white : Colors.grey[500],
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Listes des Documents',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: context.read<SwitchPageCubit>().state.selectedPage == 1.1 ? Colors.white : Colors.grey[500],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        width: Const.screenWidth(context),
                        height: 35,
                        decoration: BoxDecoration(
                          color:
                              context.read<SwitchPageCubit>().state.selectedPage == 1.2 ? Theme.of(context).colorScheme.primary : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.read<SwitchPageCubit>().switchPage(1.2);
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
                                color: context.read<SwitchPageCubit>().state.selectedPage == 1.2 ? Colors.white : Colors.grey[500],
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Creation Documents Rapide',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: context.read<SwitchPageCubit>().state.selectedPage == 1.2 ? Colors.white : Colors.grey[500],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        width: Const.screenWidth(context),
                        height: 35,
                        decoration: BoxDecoration(
                          color:
                              context.read<SwitchPageCubit>().state.selectedPage == 1.3 ? Theme.of(context).colorScheme.primary : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: () {
                            context.read<SwitchPageCubit>().switchPage(1.3);
                            context.go('/document/create-document');
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
                                color: context.read<SwitchPageCubit>().state.selectedPage == 1.3 ? Colors.white : Colors.grey[500],
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Nouveau Document',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: context.read<SwitchPageCubit>().state.selectedPage == 1.3 ? Colors.white : Colors.grey[500],
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
        );
      },
    );
  }
}
