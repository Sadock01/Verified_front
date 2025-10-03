import 'package:flutter/material.dart';

class SearchFieldWidget extends StatefulWidget {
  @override
  _SearchFieldWidgetState createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose(); // Libérer les ressources quand le widget est détruit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _searchController,
      onChanged: (query) {
        // Ajouter la logique de recherche ici (par exemple filtrer une liste)
        print("Recherche pour : $query");
      },
      style: Theme.of(context).textTheme.labelSmall,
      decoration: InputDecoration(
        hintText: "Rechercher par identifiant", // Texte d'exemple
        hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey),

        prefixIcon: Icon(Icons.search, color: Colors.grey), // Icône de recherche
      ),
    );
  }
}
