import 'package:flutter/material.dart';
import 'package:doc_authentificator/utils/app_colors.dart';

class CollaborateurFiltersWidget extends StatelessWidget {
  const CollaborateurFiltersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre des filtres
          Row(
            children: [
              Image.asset(
                'assets/images/filtre.png',
                width: 20,
                height: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                "Filtres des collaborateurs",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Filtres en ligne
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    // Filtre par statut
                    Expanded(
                      flex:2,
                      child: _buildStatusFilter(context),
                    ),
                    const SizedBox(width: 10),


                    Expanded(
                      flex:2,
                      child: _buildRoleFilter(context),
                    ),





                  ],
                ),
               Row(children: [ Expanded(
                 flex: 2,
                 child: _buildDateFilter(context),
               ),
                 const SizedBox(width: 20),
                 Expanded(
                   flex: 2,
                   child: Column(
                     children: [
                       SizedBox(height: 20),
                       ElevatedButton(
                         onPressed: () {
                           // TODO: Appliquer les filtres
                           print('Filtres appliqués');
                         },
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
                 ),],)
              ],
            ),
          ),
        ],
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
        const SizedBox(height: 4),
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
                "Actif",
                "Inactif",
                "En attente",
                "Suspendu",
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

  Widget _buildRoleFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rôle",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: "Tous les rôles",
              isDense: true,
              style: Theme.of(context).textTheme.labelSmall,
              items: [
                "Tous les rôles",
                "Administrateur",
                "Modérateur",
                "Utilisateur",
                "Invité",
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // TODO: Appliquer le filtre de rôle
                print('Rôle sélectionné: $newValue');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date d'ajout",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
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
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((dateRange) {
      if (dateRange != null) {
        // TODO: Appliquer le filtre de date
        print('Période sélectionnée: ${dateRange.start} - ${dateRange.end}');
      }
    });
  }
}
