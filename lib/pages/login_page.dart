import 'package:doc_authentificator/const/const.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Const.screenWidth(context) / 2,
          height: Const.screenHeight(context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/images/image_auth2.jpg"))),
        ),Column(children: [
          Image.asset("assets/images/Verified original.png")
          
        ],)
      ],
    );
  }
}
