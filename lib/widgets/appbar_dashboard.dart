import 'package:doc_authentificator/const/const.dart';
import 'package:flutter/material.dart';

class AppbarDashboard extends StatelessWidget {
  const AppbarDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        width: Const.screenWidth(context),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2), // Couleur de l'ombre
              spreadRadius: 10, // Étalement de l'ombre
              blurRadius: 10, // Flou de l'ombre
              offset:
                  Offset(0, 3), // Décalage horizontal et vertical de l'ombre
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                // decoration:
                //     BoxDecoration(image: DecorationImage(image: AssetImage(''))),
                ),
            Spacer(),
            InkWell(
              onTap: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 50, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                      value: 'Déconnexion',
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width: 8),
                          Text('Déconnexion'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Configuration',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text('Configuration'),
                        ],
                      ),
                    ),
                  ],
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: Const.screenWidth(context) * 0.1,
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withAlpha(15)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Container(
                    //   width: 50,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       image: DecorationImage(
                    //           fit: BoxFit.cover,
                    //           image: AssetImage(
                    //               'assets/images/profile_admin.jpg'))),
                    // ),
                    SizedBox(width: 2),
                    Text(
                      "John Doe",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
