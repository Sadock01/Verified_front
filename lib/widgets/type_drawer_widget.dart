// import 'dart:developer';

import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../const/const.dart';
import '../cubits/switch_page/switch_page_cubit.dart';

class TypeDrawerWidget extends StatefulWidget {
  const TypeDrawerWidget({super.key});

  @override
  State<TypeDrawerWidget> createState() => _TypeDrawerWidgetState();
}

class _TypeDrawerWidgetState extends State<TypeDrawerWidget> {
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
                    if (state.isCollabExpanded == true) {
                      context.read<SwitchPageCubit>().setCollabExpanded(false);
                    } else {
                      context.read<SwitchPageCubit>().setCollabExpanded(true);
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
                        "assets/images/people.png",
                        color: state.isCollabExpanded == true ? Colors.white : Colors.grey[500],
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Types',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: state.isCollabExpanded == true ? Colors.white : Colors.grey[500],
                        ),
                      ),
                      Spacer(),
                      state.isCollabExpanded == true
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
            state.isCollabExpanded
                ? Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  width: Const.screenWidth(context),
                  height: 35,
                  decoration: BoxDecoration(
                    color:
                    context.read<SwitchPageCubit>().state.selectedPage == 5.1 ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {
                      context.read<SwitchPageCubit>().switchPage(5.1);
                      context.go('');
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
                          color: context.read<SwitchPageCubit>().state.selectedPage == 5.1 ? Colors.white : Colors.grey[500],
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Liste',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.read<SwitchPageCubit>().state.selectedPage == 5.1 ? Colors.white : Colors.grey[500],
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
                    context.read<SwitchPageCubit>().state.selectedPage == 5.2 ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  ),
                  child: TextButton(
                    onPressed: () {
                      context.read<SwitchPageCubit>().switchPage(5.2);
                      context.go('');
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
                          color: context.read<SwitchPageCubit>().state.selectedPage == 5.2 ? Colors.white : Colors.grey[500],
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Création de type',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.read<SwitchPageCubit>().state.selectedPage == 5.2 ? Colors.white : Colors.grey[500],
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
