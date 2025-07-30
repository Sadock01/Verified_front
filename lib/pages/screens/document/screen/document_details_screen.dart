import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatefulWidget {
  final String identifier;

  const DocumentDetailScreen({super.key, required this.identifier});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<DocumentCubit>().getDocumentDetail(widget.identifier);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Row(
        //   children: [
        //     const DrawerDashboard(),
        //     Expanded(
        //       child: Column(
        //         children: [
        //           const AppbarDashboard(),
        //           Expanded(
        //             child: BlocBuilder<DocumentCubit, DocumentState>(
        //               builder: (context, state) {
        //                 if (state.documentStatus == DocumentStatus.loading) {
        //                   return const Center(child: CircularProgressIndicator());
        //                 }
        //
        //                 if (state.documentStatus == DocumentStatus.error || state.selectedDocument == null) {
        //                   return const Center(child: Text("Erreur lors du chargement du document."));
        //                 }
        //
        //                 final doc = state.selectedDocument!;
        //
        //                 return SingleChildScrollView(
        //                   padding: const EdgeInsets.all(16),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text("Détail du document", style: Theme.of(context).textTheme.headlineMedium),
        //                       const SizedBox(height: 20),
        //                       Card(
        //                         elevation: 3,
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(16),
        //                           child: Column(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             children: [
        //                               Text("Identifiant : ${doc.identifier}"),
        //                               Text("Description : ${doc.descriptionDocument}"),
        //                               Text("Type : ${doc.typeName}"),
        //                               Text("Auteur : ${doc.author}"),
        //                               Text("Créé le : ${doc.createdAt}"),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                       const SizedBox(height: 20),
        //                       Text("Historique des modifications", style: Theme.of(context).textTheme.titleLarge),
        //                       const SizedBox(height: 10),
        //                       ...(doc.modifications ?? []).map((modif) => ListTile(
        //                         leading: const Icon(Icons.history),
        //                         title: Text(modif.action),
        //                         subtitle: Text("Par ${modif.by} le ${modif.date}"),
        //                       )),
        //                     ],
        //                   ),
        //                 );
        //               },
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
