import 'package:flutter/material.dart';

class PlatformUsersWidget extends StatelessWidget {
  const PlatformUsersWidget({super.key});

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
        DataColumn(label: Text('USERNAME')),
        DataColumn(label: Text('EMAIL')),
        DataColumn(label: Text('PHONE')),
        DataColumn(label: Text('ROLE')),
        DataColumn(label: Text('CREATED AT')),
        DataColumn(label: Text('STATUS')),
        DataColumn(label: Text('IS SUPER?')),
        DataColumn(label: Text('OPERATIONS')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Icon(Icons.radio_button_unchecked, size: 18)),
          const DataCell(Text('admin')),
          const DataCell(Text('otorphy@spinka.biz')),
          const DataCell(Text('')),
          const DataCell(Text('No role assigned')),
          DataCell(Text('2025-08-08', style: theme.textTheme.bodySmall)),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Activated', style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          )),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
            child: Text('Yes', style: theme.textTheme.labelSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
          DataCell(Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.orange.shade600, borderRadius: BorderRadius.circular(6)),
              child: const Text('Remove super', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(width: 8),
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


