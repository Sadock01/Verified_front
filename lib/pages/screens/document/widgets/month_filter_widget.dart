import 'package:flutter/material.dart';

// Modèle Period pour représenter un mois
class Period {
  final String label;
  final String value;

  Period({required this.label, required this.value});
}

// Widget réutilisable pour le Dropdown des mois
class MonthFilterDropdown extends StatelessWidget {
  final ValueChanged<String> onMonthSelected;  // Callback pour renvoyer la valeur sélectionnée

  // Constructor
   MonthFilterDropdown({Key? key, required this.onMonthSelected}) : super(key: key);

  // Liste des mois
  final List<Period> monthOptions = [
    Period(label: "Janvier", value: "01"),
    Period(label: "Février", value: "02"),
    Period(label: "Mars", value: "03"),
    Period(label: "Avril", value: "04"),
    Period(label: "Mai", value: "05"),
    Period(label: "Juin", value: "06"),
    Period(label: "Juillet", value: "07"),
    Period(label: "Août", value: "08"),
    Period(label: "Septembre", value: "09"),
    Period(label: "Octobre", value: "10"),
    Period(label: "Novembre", value: "11"),
    Period(label: "Décembre", value: "12"),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Period>(
      style: theme.textTheme.labelSmall,
      decoration: InputDecoration(
        labelText: "Sélectionner un mois",
        labelStyle: theme.textTheme.labelSmall,

      ),
      // Pas de valeur par défaut, le premier élément sera nul
      value: null,
      onChanged: (Period? newValue) {
        if (newValue != null) {
          // Appeler le callback pour transmettre la valeur du mois sélectionné
          onMonthSelected(newValue.value);
        }
      },
      items: monthOptions.map((month) {
        return DropdownMenuItem<Period>(
          value: month,
          child: Text(month.label,style: theme.textTheme.labelSmall, ),
        );
      }).toList(),
    );
  }
}
