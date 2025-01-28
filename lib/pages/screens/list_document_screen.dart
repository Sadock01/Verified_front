import 'package:doc_authentificator/const/const.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';
import 'package:doc_authentificator/cubits/documents/document_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ListDocumentScreen extends StatefulWidget {
  const ListDocumentScreen({super.key});

  @override
  State<ListDocumentScreen> createState() => _ListDocumentScreenState();
}

class _ListDocumentScreenState extends State<ListDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(builder: (context, state) {
      return Column(children: [
        SingleChildScrollView(
          child: Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: Const.screenWidth(context),
              height: Const.screenHeight(context) * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withValues(alpha: 0.2), // Couleur de l'ombre
                    spreadRadius: 10, // Étalement de l'ombre
                    blurRadius: 10, // Flou de l'ombre
                    offset: Offset(
                        0, 3), // Décalage horizontal et vertical de l'ombre
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      context.go('/document/nouveau_document');
                    },
                    child: Text(
                      "Nouveau Document +",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        if (state.documentStatus == DocumentStatus.loading)
          const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
            ),
          )
        else if (state.documentStatus == DocumentStatus.error)
          Center(
            child: Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        else if (state.documentStatus == DocumentStatus.loaded)
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: Const.screenWidth(context),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                child: DataTable(
                  headingRowHeight: 30,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Identifiant",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Description",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Type",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Action",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ],
                  rows: state.listDocuments
                      .map((document) => DataRow(
                            cells: [
                              DataCell(
                                Text(document.identifier.toString()),
                              ),
                              DataCell(
                                Text(document.descriptionDocument),
                              ),
                              DataCell(
                                Text(document.typeId.toString()),
                              ),
                              DataCell(ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Modifier",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              )),
                            ],
                          ))
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: state.currentPage > 1
                        ? () => context.read<DocumentCubit>().goToPreviousPage()
                        : null,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3)),
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  Text(
                    '${state.currentPage} sur ${state.lastPage}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  InkWell(
                    onTap: state.currentPage < state.lastPage
                        ? () => context.read<DocumentCubit>().goToNextPage()
                        : null,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3)),
                        child: Icon(Icons.arrow_forward_ios)),
                  ),
                ],
              )
            ],
          )
        else
          Center(
            child: Text(
              "Erreur inattendue",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          )
      ]);
    });
  }
}
