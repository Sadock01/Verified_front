import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileOrUrlPicker extends StatefulWidget {
  @override
  _FileOrUrlPickerState createState() => _FileOrUrlPickerState();
}

class _FileOrUrlPickerState extends State<FileOrUrlPicker> {
  TextEditingController _controller = TextEditingController();
  PlatformFile? _selectedFile;
  void _pickLocalFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _controller.text = result.files.single.path!;
    }
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickLocalFile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], shape: RoundedRectangleBorder()),
              child: Text(
                "Choisir un fichier local...",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(
              width: 40,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder()),
              child: Text(
                "Enregistrer",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], shape: RoundedRectangleBorder()),
              child: Text(
                "Annuler",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
