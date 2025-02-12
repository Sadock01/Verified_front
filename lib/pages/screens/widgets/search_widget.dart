import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/pages/screens/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: Const.screenWidth(context),
      height: Const.screenHeight(context) * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 10,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              context.go('/document/nouveau_document');
            },
            child: Text(
              "Nouveau Document +",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            
          ),Row(children: [SearchBarWidget()],)
        ],
      ),
    );
  }
}
