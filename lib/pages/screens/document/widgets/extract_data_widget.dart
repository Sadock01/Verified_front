import 'package:doc_authentificator/pages/screens/document/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';

class ExtractedDataReviewForm extends StatefulWidget {
  final Map<String, dynamic> extractedData;
  final TextEditingController? documentIdentifier;
  final void Function({
    required String identifier,
    required String description,
    required String typeCertificat,
    required String beneficiaire,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
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
              Text(
                "Vérification des données extraites",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 25),

              // Champs dans un scrollable
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 2, child: LabeledTextField(label: "Identifiant du document", controller: identifierController)),
                        SizedBox(width: 10),
                        Expanded(flex: 2, child: LabeledTextField(label: "Bénéficiaire", controller: beneficiaireController)),
                      ],
                    ),
                    LabeledTextField(label: "Type de certificat", controller: typeController),
                    LabeledTextField(label: "Description", controller: descriptionController, maxLines: 4),
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
