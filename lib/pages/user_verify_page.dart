import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserVerifyPage extends StatefulWidget {
  const UserVerifyPage({super.key});

  @override
  State<UserVerifyPage> createState() => _UserVerifyPageState();
}

class _UserVerifyPageState extends State<UserVerifyPage> {
  final TextEditingController _identifierController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            // margin: EdgeInsets.only(top: 10),
            width: Const.screenWidth(context),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.grey.withValues(alpha: 0.2), // Couleur de l'ombre
                  spreadRadius: 10, // Étalement de l'ombre
                  blurRadius: 10, // Flou de l'ombre
                  offset: Offset(
                      0, 3), // Décalage horizontal et vertical de l'ombre
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Const.screenWidth(context) * 0.1,
                  height: 30,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/Verified_original.png'))),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Contactez-nous",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.white),
                    ))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Const.screenWidth(context),
                    height: Const.screenHeight(context) * 0.2,
                    decoration: BoxDecoration(color: Colors.black54),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Verifier l'authenticité d'un document à partir de l'identifiant",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Const.screenHeight(context) * 0.1,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: Const.screenWidth(context) * 0.25,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: TextField(
                                controller: _identifierController,
                                focusNode: _focusNode,
                                style: Theme.of(context).textTheme.labelSmall,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      EdgeInsets.only(bottom: 12, left: 5),
                                  hintText: "N d'identification du document",
                                  hintStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  final identifier = _identifierController.text;

                                  context
                                      .read<DocumentCubit>()
                                      .verifyDocument(identifier);
                                },
                                child: Text(
                                  "Rechercher",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Const.screenHeight(context) * 0.1),
                  BlocBuilder<DocumentCubit, DocumentState>(
                    builder: (context, state) {
                      if (state.documentStatus == DocumentStatus.loading) {
                        return const SizedBox();
                      } else if (state.documentStatus ==
                          DocumentStatus.loaded) {
                        return SizedBox();
                      } else if (state.documentStatus ==
                          DocumentStatus.sucess) {
                        return Container(
                          width: Const.screenWidth(context) * 0.5,
                          height: Const.screenHeight(context) * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(
                                    alpha: 0.2), // Couleur de l'ombre
                                spreadRadius: 10, // Étalement de l'ombre
                                blurRadius: 10, // Flou de l'ombre
                                offset: Offset(0,
                                    3), // Décalage horizontal et vertical de l'ombre
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Text(state.apiResponse.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontSize: 15,
                                            )),
                                    SizedBox(height: 15),
                                    Container(
                                      width: Const.screenWidth(context) * 0.15,
                                      height:Const.screenHeight(context)*0.1,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                  'assets/images/Verified_Badge.svg.png'))),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state.documentStatus ==
                          DocumentStatus.failed) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset(
                                "images/9214777.jpg",
                                width: Const.screenWidth(context) * 0.3,
                                height: Const.screenHeight(context) * 0.3,
                              ),
                              const SizedBox(height: 15),
                              Text(state.errorMessage,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                  SizedBox(height: Const.screenHeight(context) * 0.35),
                  Container(
                    width: Const.screenWidth(context),
                    height: Const.screenHeight(context) * 0.3,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary),
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(onPressed: () {}, child: Text(""))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
