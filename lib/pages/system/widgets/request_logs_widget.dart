import 'package:flutter/material.dart';

class RequestLogsWidget extends StatelessWidget {
  const RequestLogsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return DataTable(
      columnSpacing: 18,
      headingRowColor: MaterialStateProperty.all(isLight ? const Color(0xFFF5F7FA) : null),
      dividerThickness: 0,
      columns: const [
        DataColumn(label: SizedBox(width: 24)),
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('URL')),
        DataColumn(label: Text('STATUS CODE')),
        DataColumn(label: Text('COUNT')),
        DataColumn(label: Text('OPERATIONS')),
      ],
      rows: List.generate(10, (i) {
        final id = 26 - i;
        return DataRow(cells: [
          const DataCell(Icon(Icons.radio_button_unchecked, size: 18)),
          DataCell(Text('$id')),
          DataCell(Row(children: const [
            Flexible(child: Text('https://shofy.botble.com/...', overflow: TextOverflow.ellipsis)),
            SizedBox(width: 6),
            Icon(Icons.open_in_new, size: 16, color: Colors.blue),
          ])),
          const DataCell(Text('404')),
          const DataCell(Text('1')),
          DataCell(_opBtn(context, Icons.delete, Colors.red)),
        ]);
      }),
    );
  }

  Widget _opBtn(BuildContext context, IconData icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}


