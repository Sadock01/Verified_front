import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DrawerDashboard extends StatelessWidget {
  const DrawerDashboard({super.key});

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
                  color: context.read<SwitchPageCubit>().state.selectedPage == 0
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(0);
                    context.go('/dashboard');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        color: context
                                    .read<SwitchPageCubit>()
                                    .state
                                    .selectedPage ==
                                0
                            ? Colors.white
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Dashboard',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: context
                                              .read<SwitchPageCubit>()
                                              .state
                                              .selectedPage ==
                                          0
                                      ? Colors.white
                                      : Colors.black,
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
                      : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(1);
                    context.go('/document/List_document');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder,
                        color: context
                                    .read<SwitchPageCubit>()
                                    .state
                                    .selectedPage ==
                                1
                            ? Colors.white
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Documents',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: context
                                              .read<SwitchPageCubit>()
                                              .state
                                              .selectedPage ==
                                          1
                                      ? Colors.white
                                      : Colors.black,
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
                  color: context.read<SwitchPageCubit>().state.selectedPage == 2
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(2);
                    context.go('/document/nouveau_document');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: context
                                    .read<SwitchPageCubit>()
                                    .state
                                    .selectedPage ==
                                2
                            ? Colors.white
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Nouveau Document',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  color: context
                                              .read<SwitchPageCubit>()
                                              .state
                                              .selectedPage ==
                                          2
                                      ? Colors.white
                                      : Colors.black,
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
                  color: context.read<SwitchPageCubit>().state.selectedPage == 3
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    context.read<SwitchPageCubit>().switchPage(3);
                    context.go('/historiques');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: context
                                    .read<SwitchPageCubit>()
                                    .state
                                    .selectedPage ==
                                3
                            ? Colors.white
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Historiques',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: context
                                              .read<SwitchPageCubit>()
                                              .state
                                              .selectedPage ==
                                          3
                                      ? Colors.white
                                      : Colors.black,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
