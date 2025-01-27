import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  },
                  child: Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: context
                                      .read<SwitchPageCubit>()
                                      .state
                                      .selectedPage ==
                                  0
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    // ListView.builder(itemBuilder: (context, index) {
                    //   return Container(
                    //     margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    //     width: Const.screenWidth(context),
                    //     height: Const.screenHeight(context) * 0.2,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(25),
                    //       color: Colors.white,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey
                    //               .withValues(alpha: 0.2), // Couleur de l'ombre
                    //           spreadRadius: 10, // Étalement de l'ombre
                    //           blurRadius: 10, // Flou de l'ombre
                    //           offset: Offset(
                    //               0, 3), // Décalage horizontal et vertical de l'ombre
                    //         ),
                    //       ],
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         InkWell(
                    //           onTap: () {
                    //             context.read<SwitchPageCubit>().switchPage(1);
                    //           },
                    //           child: Container(
                    //             padding: EdgeInsets.all(10),
                    //             decoration: BoxDecoration(
                    //                 color: Theme.of(context).colorScheme.primary,
                    //                 borderRadius: BorderRadius.circular(5)),
                    //             child: Text(
                    //               'Ajouter un document',
                    //               style: Theme.of(context).textTheme.displayMedium,
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 10,
                    //         ),
                    //         Text(
                    //           'Liste des documents',
                    //           style: Theme.of(context).textTheme.displayMedium,
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // });
                  },
                  child: Text(
                    'Documents',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: context
                                      .read<SwitchPageCubit>()
                                      .state
                                      .selectedPage ==
                                  1
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  },
                  child: Text(
                    'Nouveau Document',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: context
                                      .read<SwitchPageCubit>()
                                      .state
                                      .selectedPage ==
                                  2
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  },
                  child: Text(
                    'Collaborateurs',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: context
                                      .read<SwitchPageCubit>()
                                      .state
                                      .selectedPage ==
                                  3
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
