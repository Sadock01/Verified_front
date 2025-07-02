import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PdfDropZone extends StatefulWidget {
  final File? selectedFile;
  final void Function(File) onFilePicked;

  const PdfDropZone({required this.selectedFile, required this.onFilePicked, Key? key}) : super(key: key);

  @override
  State<PdfDropZone> createState() => _PdfDropZoneState();
}

class _PdfDropZoneState extends State<PdfDropZone> {
  bool _dragging = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      widget.onFilePicked(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<File>(
      onWillAccept: (data) {
        setState(() => _dragging = true);
        return true;
      },
      onLeave: (data) => setState(() => _dragging = false),
      onAccept: (file) {
        setState(() => _dragging = false);
        widget.onFilePicked(file);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: _pickFile,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _dragging ? Colors.deepPurple.withValues(alpha: 0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                style: BorderStyle.none,
                color: _dragging ? Colors.deepPurple : Colors.white,
                width: 3,
              ),
            ),
            height: 150,
            width: double.infinity,
            child: Center(
              child: widget.selectedFile == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_upload, size: 48, color: Colors.deepPurple),
                        SizedBox(height: 12),
                        Text(
                          "Glissez-déposez votre fichier PDF ici,\nou cliquez pour sélectionner",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 16, color: Colors.deepPurple),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 48, color: Colors.redAccent),
                        SizedBox(height: 12),
                        Text(
                          "Fichier sélectionné :\n${widget.selectedFile!.path.split('/').last}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => widget.onFilePicked(null as File), // Reset
                          child: Text(
                            "Supprimer",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        )
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
