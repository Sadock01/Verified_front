import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class ExcelDropZone extends StatefulWidget {
  final Uint8List? selectedFileBytes;
  final String? selectedFileName;
  final void Function(Uint8List?, String?) onFilePicked;

  const ExcelDropZone({
    required this.selectedFileBytes,
    required this.selectedFileName,
    required this.onFilePicked,
    Key? key,
  }) : super(key: key);

  @override
  State<ExcelDropZone> createState() => _ExcelDropZoneState();
}

class _ExcelDropZoneState extends State<ExcelDropZone> {
  bool _dragging = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
      withData: true, // Important pour avoir les bytes
    );
    if (result != null && result.files.single.bytes != null) {
      widget.onFilePicked(result.files.single.bytes, result.files.single.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Uint8List>(
      onWillAccept: (data) {
        setState(() => _dragging = true);
        return true;
      },
      onLeave: (data) => setState(() => _dragging = false),
      onAccept: (data) {
        setState(() => _dragging = false);
        // Pour drag & drop, on ne récupère pas le nom facilement,
        // tu peux adapter selon ta logique
        widget.onFilePicked(data, widget.selectedFileName);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: _pickFile,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _dragging ? Colors.deepPurple.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _dragging ? Colors.deepPurple : Colors.transparent,
                width: 3,
              ),
            ),
            height: 150,
            width: double.infinity,
            child: Center(
              child: widget.selectedFileBytes == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/telecharger.png",
                          width: 50,
                          height: 50,
                        ),
                        // Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[400]),
                        SizedBox(height: 12),
                        Text(
                          "Cliquez pour sélectionner votre fichier EXCEL",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: Colors.grey[400],
                              ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.picture_as_pdf, size: 48, color: Colors.redAccent),
                        SizedBox(height: 12),
                        Text(
                          "Fichier sélectionné :\n${widget.selectedFileName ?? 'Inconnu'}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextButton(
                          onPressed: () => widget.onFilePicked(null, null), // Reset
                          child: Text(
                            "Supprimer",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
