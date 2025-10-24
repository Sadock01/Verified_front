import 'package:flutter/material.dart';
import 'package:doc_authentificator/utils/app_colors.dart';
import 'date_range_picker_dialog.dart';

class HistoryFiltersWidget extends StatelessWidget {
  const HistoryFiltersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 10,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildDateRangeFilter(context),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildStatusFilter(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildDeviceTypeFilter(context),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.PRIMARY_BLUE_COLOR,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/filtre.png',
                            width: 22,
                            height: 22,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Filtrer",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton de rechargement
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey[200]!),
              //     borderRadius: BorderRadius.circular(5),
              //   ),
              //   child: Row(
              //     children: [
              //       Image.asset(
              //         'assets/images/reload.png',
              //         width: 18,
              //         height: 18,
              //         color: Colors.grey[300],
              //       ),
              //       const SizedBox(width: 8),
              //       Text(
              //         "Recharger",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Période",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // TODO: Implémenter la sélection de date
            _showDatePicker(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  "Sélectionner la période",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDateRangePickerDialog(
        onDateRangeSelected: (startDate, endDate) {
          if (startDate != null && endDate != null) {
            // TODO: Appliquer le filtre de date
            print('Période sélectionnée: $startDate - $endDate');
          }
        },
      ),
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Statut",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: "Tous les statuts",
              isDense: true,
              style: Theme.of(context).textTheme.labelSmall,
              items: [
                "Tous les statuts",
                "Document trouvé",
                "Document non trouvé",
                "Correspondance",
                "Non correspondance",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // TODO: Appliquer le filtre de statut
                print('Statut sélectionné: $newValue');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceTypeFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type d'appareil",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: "Tous les appareils",
              isDense: true,
              style: Theme.of(context).textTheme.labelSmall,
              items: [
                "Tous les appareils",
                "Mobile",
                "Desktop",
                "Tablet",
                "Autre",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // TODO: Appliquer le filtre de type d'appareil
                print('Type d\'appareil sélectionné: $newValue');
              },
            ),
          ),
        ),
      ],
    );
  }
}
