import 'package:flutter/material.dart';

class Const {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Liste des éléments du menu
  static List<Map<String, dynamic>> get menuItems => [
        {"label": "Dashboard", "pageIndex": 0},
        {"label": "Documents", "pageIndex": 1},
        {"label": "Rapports", "pageIndex": 2},
        {"label": "Configurations", "pageIndex": 3},
        {"label": "Collaborateurs", "pageIndex": 4},
      ];
}
