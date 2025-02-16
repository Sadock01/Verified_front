import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:doc_authentificator/const/api_const.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfUploaderWidget extends StatefulWidget {
  final String
      documentId; // Identifiant du document passé depuis la page parente

  const PdfUploaderWidget({super.key, required this.documentId});

  @override
  _PdfUploaderWidgetState createState() => _PdfUploaderWidgetState();
}

class _PdfUploaderWidgetState extends State<PdfUploaderWidget> {
  // File? _file;
  String _uploadStatus = '';
  final Dio _dio =
      ApiConfig.api(); // Initialisation de Dio avec la configuration
  Uint8List? _fileBytes; // Pour stocker les données du fichier
  String? _fileName; // Pour stocker le nom du fichier

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        PlatformFile file = result.files.single;

        // Stocker les données et le nom du fichier
        setState(() {
          _fileBytes = file.bytes; // Utilisez file.bytes pour le web
          _fileName = file.name; // Stockez le nom du fichier
        });

        log('Fichier sélectionné : $_fileName');
      } else {
        log('Aucun fichier sélectionné.');
      }
    } catch (e) {
      log('Erreur lors de la sélection du fichier : $e');
    }
  }

  Future<void> _uploadFile() async {
    if (_fileBytes == null) {
      setState(() {
        _uploadStatus = 'Veuillez sélectionner un fichier PDF.';
      });
      return;
    }

    try {
      // Créer un FormData pour l'upload
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(_fileBytes!,
            filename: _fileName ?? 'document.pdf'),
        'document_id': widget.documentId,
      });

      // Envoyer la requête POST
      var response = await _dio.post('uploadDocument', data: formData);

      if (response.statusCode == 200) {
        setState(() {
          _uploadStatus = 'Fichier uploadé avec succès !';
        });
      } else {
        setState(() {
          _uploadStatus =
              'Erreur lors de l\'upload : ${response.statusMessage}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Erreur lors de l\'upload : $e';
      });
    }
  }

  Future<void> _downloadFile() async {
    try {
      // Télécharger le fichier avec Dio
      var response = await _dio.get(
        'downloadDocumentWithQr/${widget.documentId}',
        options: Options(
            responseType:
                ResponseType.bytes), // Important pour les fichiers binaires
      );

      if (response.statusCode == 200) {
        // Sauvegarder le fichier téléchargé
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/document_with_qr.pdf';
        File file = File(filePath);
        await file.writeAsBytes(response.data);

        // Ouvrir le fichier téléchargé
        OpenFile.open(filePath);

        setState(() {
          _uploadStatus = 'Fichier téléchargé avec succès !';
        });
      } else {
        setState(() {
          _uploadStatus =
              'Erreur lors du téléchargement : ${response.statusMessage}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Erreur lors du téléchargement : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: Text('Sélectionner un fichier PDF'),
        ),
        if (_fileName != null)
          Text(
              'Fichier sélectionné : $_fileName'), // Affichez le nom du fichier
        ElevatedButton(
          onPressed: _uploadFile,
          child: Text('Uploader le PDF'),
        ),
        ElevatedButton(
          onPressed: _downloadFile,
          child: Text('Télécharger le PDF avec QR Code'),
        ),
        if (_uploadStatus.isNotEmpty) Text(_uploadStatus),
      ],
    );
  }
}
