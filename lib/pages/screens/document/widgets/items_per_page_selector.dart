import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doc_authentificator/cubits/documents/document_cubit.dart';

class ItemsPerPageSelector extends StatelessWidget {
  final int currentItemsPerPage;
  
  const ItemsPerPageSelector({
    Key? key,
    required this.currentItemsPerPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: currentItemsPerPage,
          isDense: true,
          style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
          items: [5, 10, 15, 20, 25].map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              context.read<DocumentCubit>().setItemsPerPage(newValue);
            }
          },
        ),
      ),
    );
  }
}
