import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/switch_page/switch_page_cubit.dart';

import '../const/const.dart';
import '../cubits/switch_page/switch_page_state.dart';
import '../cubits/theme/theme_cubit.dart';
import '../utils/utils.dart';

class AppBarVendorWidget extends StatelessWidget {
  const AppBarVendorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final foregroundColor = theme.appBarTheme.foregroundColor ?? theme.textTheme.titleMedium?.color ?? Colors.black87;
    final iconColor = theme.iconTheme.color;

    return BlocBuilder<SwitchPageCubit, SwitchPageState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                  builder: (context) => InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer(); // Ouvre le Drawer
                      },
                      child: Image.asset(
                        "assets/images/drawer.png",
                        width: 32,
                        height: 32,
                        color: iconColor,
                      ))),
              const SizedBox(width: 8),
              // Container(
              //   // margin: EdgeInsets.only(bottom: 8, top: 5),
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   width: Const.screenWidth(context) * 0.12,
              //   height: 45,
              //   decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.contain, image: AssetImage('assets/images/Verified_original.png'))),
              // ),
              Row(
                children: [

                  CircleAvatar(
                    // backgroundColor: Colors.white,
                      radius: 18,
                      child: Image.asset(
                        "assets/images/user.png",
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      )),   const SizedBox(width: 20),
                  InkWell(
                    onTap: () => context.read<ThemeCubit>().toggleTheme(),
                    child: _themeIcon(context),
                  ),
                  const SizedBox(width: 20),
                  InkWell(onTap: (){
                    Utils.showLogoutConfirmationDialog(context);
        },
        child: const Icon(Icons.logout_outlined, size: 28, color: Colors.red)),

                  // Menu hamburger
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _iconCircle(String imageUrl, context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Container(
      height: 36,
      width: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.white,
      ),
      padding: const EdgeInsets.all(8), // espace autour de l'image
      child: Image.asset(
        imageUrl,
        width: 25,
        height: 25,
        color: isLight ? Colors.black : Colors.white,
        fit: BoxFit.contain, // ajuste l'image à la taille disponible
      ),
    );
  }

  Widget _themeIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _iconCircle(isDark ? "assets/images/night-mode (1).png" : "assets/images/day-mode.png", context);
  }
}
