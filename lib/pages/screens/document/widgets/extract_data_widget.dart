import 'package:doc_authentificator/pages/screens/document/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/utilitaire.dart';
import '../../../../utils/utils.dart';

class ExtractedDataReviewForm extends StatefulWidget {
  final Map<String, dynamic> extractedData;
  final TextEditingController? documentIdentifier;
  final void Function({
    required String identifier,
    required String description,
    required String typeCertificat,
    required String beneficiaire,
   String? date,
  }) onSubmit;

  const ExtractedDataReviewForm({
    Key? key,
    required this.extractedData,
    this.documentIdentifier,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _ExtractedDataReviewFormState createState() => _ExtractedDataReviewFormState();
}

class _ExtractedDataReviewFormState extends State<ExtractedDataReviewForm> {
  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController beneficiaireController;
  late TextEditingController identifierController;
   TextEditingController dateInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    identifierController = widget.documentIdentifier!;

    typeController = TextEditingController(
      text: (widget.extractedData['type_certificat'] as List?)?.join(', ') ?? '',
    );
    descriptionController = TextEditingController(
      text: (widget.extractedData['description'] as List?)?.join(', ') ?? '',
    );
    beneficiaireController = TextEditingController(
      text: (widget.extractedData['beneficiaire'] as List?)?.join(', ') ?? '',
    );
  }

  @override
  void dispose() {
    identifierController.dispose();
    typeController.dispose();
    descriptionController.dispose();
    beneficiaireController.dispose();
    dateInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                ),
                child: Text(
                    "Vérifiez les informations extraites avant de finaliser l'enregistrement du document.",
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              Text(
                "Vérification des données extraites",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 25),

              // Champs dans un scrollable
              SizedBox(
                height: 500,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex:2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Identifiant",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: identifierController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Veuillez entrer l'identifiant unique du document";
                                  }
                                  return null;
                                },
                                style: Theme.of(context).textTheme.labelSmall,
                                decoration: InputDecoration(


                                  hintText: "Identifiant unique du document",
                                  hintStyle: Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nom du Beneficiaire",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: beneficiaireController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Veuillez entrer l'identifiant unique du document";
                                //   }
                                //   return null;
                                // },
                                style: Theme.of(context).textTheme.labelSmall,


                                decoration: InputDecoration(


                                  hintText: "Nom & Prenoms du bénéficiaire",
                                  hintStyle: Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Expanded(flex: 2, child: LabeledTextField(label: "Identifiant du document", controller: identifierController)),
                        //
                        // Expanded(flex: 2, child: LabeledTextField(label: "Bénéficiaire", controller: beneficiaireController)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type du document",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w100),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: typeController,
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Veuillez entrer l'identifiant unique du document";
                                //   }
                                //   return null;
                                // },
                                style: Theme.of(context).textTheme.labelSmall,


                                decoration: InputDecoration(


                                  hintText: "Type du document",
                                  hintStyle: Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Expanded(flex: 2,child: LabeledTextField(label: "Type de certificat", controller: typeController)),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date de delivrance",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: dateInfoController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                  DateInputFormatter(), // ton formatter custom
                                ],
                                style: theme.textTheme.labelSmall,
                                decoration: InputDecoration(
                                  hintStyle: theme.textTheme.labelSmall,
                                  hintText: "jj-mm-aaaa (ex. : 22-07-2023)",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                                validator: (value) => value == null || value.isEmpty ? "Veuillez entrer la date de delivrance" : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 4,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Veuillez entrer l'identifiant unique du document";
                          //   }
                          //   return null;
                          // },
                          style: Theme.of(context).textTheme.labelSmall,


                          decoration: InputDecoration(


                            hintText: "Description: Delivrée par la FRIARE à John Doe pour sa participa....",
                            hintStyle: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                    // LabeledTextField(label: "Description", controller: descriptionController, maxLines: 4),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  onPressed: () {
                    widget.onSubmit(
                      identifier: identifierController.text,
                      description: descriptionController.text,
                      typeCertificat: typeController.text,
                      date: dateInfoController.text,
                      beneficiaire: beneficiaireController.text,
                    );
                  },
                  label: Text(
                    "Valider et enregistrer",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
