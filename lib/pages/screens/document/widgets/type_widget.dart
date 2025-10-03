import 'package:flutter/material.dart';

import '../../../../cubits/types/type_doc_state.dart';
import '../../../../models/type_doc_model.dart';

class TypeDropdownWidget extends StatelessWidget {
  final TypeDocState state;
  final TypeDocModel? selectedType;
  final ValueChanged<TypeDocModel?> onChanged;
  final TextEditingController? manualTypeController;

  const TypeDropdownWidget({
    Key? key,
    required this.state,
    required this.selectedType,
    required this.onChanged,
    this.manualTypeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.typeStatus == TypeStatus.loading) {
      return const LinearProgressIndicator(minHeight: 1);
    }

    if (state.typeStatus == TypeStatus.error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Type du Document",
            style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: manualTypeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Veuillez entrer le Type du document unique.";
              }
              return null;
            },
            style: theme.textTheme.labelSmall,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(5),
              ),
              hintText: "Type du document",
              hintStyle: theme.textTheme.displaySmall,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField<TypeDocModel>(
        style: theme.textTheme.labelSmall,
        value: selectedType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          hintText: "Choisir un type de document",
          hintStyle: theme.textTheme.displaySmall?.copyWith(color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: state.listType.map((type) {
          return DropdownMenuItem<TypeDocModel>(
            value: type,
            child: Text(
              type.name,
              style: theme.textTheme.labelSmall,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
