import 'package:flutter/material.dart';

class CustomDateRangePickerDialog extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeSelected;

  const CustomDateRangePickerDialog({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  State<CustomDateRangePickerDialog> createState() => _CustomDateRangePickerDialogState();
}

class _CustomDateRangePickerDialogState extends State<CustomDateRangePickerDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isLight
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[900]!,
                    Colors.grey[800]!,
                  ],
                ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête avec icône
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                size: 32,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 20),
            
            // Titre
            Text(
              "Sélectionner la période",
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isLight ? Colors.grey[800] : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            
            // Sous-titre
            Text(
              "Choisissez la période pour filtrer les historiques",
              style: theme.textTheme.labelSmall?.copyWith(
                color: isLight ? Colors.grey[600] : Colors.grey[300],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Sélection des dates
            Row(
              children: [
                // Date de début
                Expanded(
                  child: _buildDateSelector(
                    context,
                    "Date de début",
                    _startDate,
                    (date) => setState(() => _startDate = date),
                    Icons.play_arrow,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Date de fin
                Expanded(
                  child: _buildDateSelector(
                    context,
                    "Date de fin",
                    _endDate,
                    (date) => setState(() => _endDate = date),
                    Icons.stop,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Actions
            Row(
              children: [
                // Bouton Annuler
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isLight ? Colors.grey[300]! : Colors.grey[600]!,
                      ),
                    ),
                    child: Text(
                      "Annuler",
                      style: TextStyle(
                        color: isLight ? Colors.grey[600] : Colors.grey[300],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Bouton Appliquer
                Expanded(
                  child: ElevatedButton(
                    onPressed: _startDate != null && _endDate != null
                        ? () {
                            widget.onDateRangeSelected(_startDate, _endDate);
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Appliquer",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    DateTime? date,
    Function(DateTime?) onDateSelected,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isLight ? Colors.grey[700] : Colors.grey[200],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: theme.copyWith(
                    colorScheme: theme.colorScheme.copyWith(
                      primary: color,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isLight ? Colors.grey[50] : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLight ? Colors.grey[300]! : Colors.grey[600]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    date != null
                        ? "${date.day}/${date.month}/${date.year}"
                        : "Sélectionner",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: date != null
                          ? (isLight ? Colors.grey[800] : Colors.white)
                          : (isLight ? Colors.grey[500] : Colors.grey[400]),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: isLight ? Colors.grey[400] : Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
