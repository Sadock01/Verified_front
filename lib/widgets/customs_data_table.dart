import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double headingRowHeight;
  final Color? headingColor;

  const CustomDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.headingRowHeight = 40,
    this.headingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      // headingRowColor: MaterialStateProperty.all(headingColor ?? Colors.grey[300]),
      headingRowHeight: headingRowHeight,
      columns: columns,
      rows: rows,
    );
  }
}
