import 'package:flutter/material.dart';

class RolesPermissionsWidget extends StatelessWidget {
  const RolesPermissionsWidget({super.key});

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
        DataColumn(label: Text('NAME')),
        DataColumn(label: Text('DESCRIPTION')),
        DataColumn(label: Text('CREATED AT')),
        DataColumn(label: Text('CREATED BY')),
        DataColumn(label: Text('OPERATIONS')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Icon(Icons.radio_button_unchecked, size: 18)),
          const DataCell(Text('1')),
          DataCell(Row(children: const [
            Text('Admin', style: TextStyle(color: Colors.blue)),
            SizedBox(width: 6),
            Icon(Icons.open_in_new, size: 16, color: Colors.blue),
          ])),
          const DataCell(Text('Admin users role')),
          const DataCell(Text('2025-08-08')),
          DataCell(Row(children: const [
            Text('Darius Brakus', style: TextStyle(color: Colors.blue)),
            SizedBox(width: 6),
            Icon(Icons.open_in_new, size: 16, color: Colors.blue),
          ])),
          DataCell(Row(children: [
            _opBtn(context, Icons.edit, theme.colorScheme.primary),
            const SizedBox(width: 8),
            _opBtn(context, Icons.delete, Colors.red),
          ])),
        ]),
      ],
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


