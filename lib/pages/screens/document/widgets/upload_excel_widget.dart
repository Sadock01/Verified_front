import 'dart:developer';
import 'dart:typed_data';
import 'package:doc_authentificator/pages/screens/document/widgets/excel_drop_zone.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

import '../../../../services/document_service.dart';

class UploadExcelWidget extends StatefulWidget {
  // final DocumentState state;
  final void Function(List<Map<String, dynamic>>) onExtracted;

  const UploadExcelWidget({
    super.key,
    required this.onExtracted, // ✅ obligatoire
  });

  @override
  State<UploadExcelWidget> createState() => _UploadExcelWidgetState();
}

class _UploadExcelWidgetState extends State<UploadExcelWidget> {
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  PlatformFile? _selectedFile;

  Map<String, dynamic>? extractedEntities;
  bool _isUploading = false;

  Future<void> _downloadExampleExcel() async {
    try {
      // Charger le fichier depuis les assets
      final ByteData data = await rootBundle.load('assets/fichiers/exemple_import.xlsx');
      final Uint8List bytes = data.buffer.asUint8List();
      
      if (kIsWeb) {
        // Pour le web, utiliser le téléchargement via le navigateur
        await _downloadFileWeb(bytes, 'exemple_import.xlsx');
      } else {
        // Pour mobile/desktop, utiliser path_provider
        await _downloadFileMobile(bytes, 'exemple_import.xlsx');
      }
      
    } catch (e) {
      log("Erreur lors du téléchargement : ${e.toString()}");
      ElegantNotification.error(
        description: Text(
          "Erreur lors du téléchargement : ${e.toString()}",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ).show(context);
    }
  }

  Future<void> _downloadFileWeb(Uint8List bytes, String fileName) async {
    try {
      // Créer un blob et déclencher le téléchargement
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
      
      ElegantNotification.success(
        title: Text("Téléchargement réussi"),
        description: Text(
          "Le fichier d'exemple a été téléchargé",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ).show(context);
    } catch (e) {
      throw Exception("Erreur lors du téléchargement web: $e");
    }
  }

  Future<void> _downloadFileMobile(Uint8List bytes, String fileName) async {
    try {
      // Obtenir le répertoire de téléchargement
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("Impossible d'accéder au répertoire de téléchargement");
      }
      
      // Créer le fichier
      final String uniqueFileName = 'exemple_import_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final File file = File('${downloadsDir.path}/$uniqueFileName');
      await file.writeAsBytes(bytes);
      
      ElegantNotification.success(
        title: Text("Téléchargement réussi"),
        description: Text(
          "Le fichier d'exemple a été téléchargé dans votre dossier Téléchargements",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ).show(context);
    } catch (e) {
      throw Exception("Erreur lors du téléchargement mobile: $e");
    }
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
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                ),
                child: Text("Merci de téléverser uniquement des fichiers Excel (.xls, .xlsx) dans cette zone.",
                    style: Theme.of(context).textTheme.displaySmall),
              ),
              const SizedBox(height: 16),
              // _buildTypeDropdown(state),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Téléversez votre fichier EXCEL",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Besoin d’un exemple ? ",
                    style: theme.textTheme.labelSmall,
                  ),
                  TextButton(
                    onPressed: _downloadExampleExcel,
                    child: Text(
                      "Cliquez ici",
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              SizedBox(height: 8),
              _selectedFileBytes == null
                  ? ExcelDropZone(
                      selectedFileBytes: _selectedFileBytes,
                      selectedFileName: _selectedFileName,
                      onFilePicked: (bytes, name) {
                        setState(() {
                          _selectedFileBytes = bytes;
                          _selectedFileName = name;
                        });
                      },
                    )
                  : Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade700),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _selectedFileName ?? 'Fichier sélectionné',
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.green.shade700),
                            onPressed: () {
                              setState(() {
                                _selectedFileBytes = null;
                                _selectedFileName = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedFileBytes == null) {
                      ElegantNotification.error(
                        description: Text(
                          "Veuillez selectionner un fichier excel",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ).show(context);
                      return;
                    }

                    setState(() => _isUploading = true); // ⏳ Démarre le chargement

                    try {
                      final response = await DocumentService.uploadExcelFile(
                        _selectedFileBytes!,
                        filename: _selectedFileName ?? 'document.pdf',
                      );

                      final data = response['data'];

                      // final firstItem = response['data']?[0]['entities'];

                      if (data is List) {
                        final List<Map<String, dynamic>> extractedList = List<Map<String, dynamic>>.from(data);

                        setState(() => _isUploading = false);

                        widget.onExtracted(extractedList);
                      } else if (data is Map<String, dynamic>) {
                        setState(() => _isUploading = false);

                        widget.onExtracted([data]); // met dans une liste
                      } else {
                        setState(() => _isUploading = false);

                        ElegantNotification.error(
                          description: Text(
                            "Les données extraites sont dans un format inattendu.",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ).show(context);
                      }
                      // else {
                      //   // Cas où data n'est pas une liste ou est vide
                      //   setState(() {
                      //     extractedEntities = null;
                      //     _isUploading = false;
                      //   });
                      // }
                    } catch (e) {
                      setState(() => _isUploading = false);
                      ElegantNotification.error(
                        description: Text(
                          "Erreur lors de l'envoi : ${e.toString()}",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ).show(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: _isUploading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.save_alt, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Uploader et enregistrer",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
