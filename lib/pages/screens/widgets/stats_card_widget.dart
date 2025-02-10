import 'package:doc_authentificator/const/const.dart';
import 'package:flutter/material.dart';

class StatsCardWidget extends StatelessWidget {
  const StatsCardWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.color});
  final String value;
  final Color color;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: Const.screenWidth(context) * 0.33,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2), // Couleur de l'ombre
            spreadRadius: 10, // Étalement de l'ombre
            blurRadius: 10, // Flou de l'ombre
            offset: Offset(0, 3), // Décalage horizontal et vertical de l'ombre
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(value,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.white,
                      )),
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          )
        ],
      ),
    );
  }
}
