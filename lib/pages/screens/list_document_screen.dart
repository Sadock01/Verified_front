import 'package:doc_authentificator/const/const.dart';
import 'package:flutter/material.dart';

class ListDocumentScreen extends StatefulWidget {
  const ListDocumentScreen({super.key});

  @override
  State<ListDocumentScreen> createState() => _ListDocumentScreenState();
}

class _ListDocumentScreenState extends State<ListDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: Const.screenWidth(context),
        height: Const.screenHeight(context) * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
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
      ),
      SizedBox(width: 10),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: Const.screenWidth(context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white),
        child: DataTable(
          headingRowHeight: 30,
          columns: [
            DataColumn(label: Text("Id")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Code")),
            DataColumn(label: Text("Quantity")),
            DataColumn(label: Text("Amount")),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(
                  Text('1'),
                ),
                DataCell(
                  Text('Janelle'),
                ),
                DataCell(
                  Text('234567'),
                ),
                DataCell(
                  Text('3'),
                ),
                DataCell(
                  Text('1547'),
                ),
              ],
            )
          ],
        ),
      )
    ]);
  }
}
