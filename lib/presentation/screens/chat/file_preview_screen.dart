import 'package:flutter/material.dart';

class FilePreviewScreen extends StatelessWidget {
  final String fileUrl;
  final String fileName;

  const FilePreviewScreen({
    Key? key,
    required this.fileUrl,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: Center(
        child: fileUrl.endsWith('.pdf')
            ? // Logique pour afficher un PDF (nécessite un package comme `flutter_pdfview`)
        Placeholder() // Remplacer par un widget de prévisualisation PDF
            : Image.network(fileUrl),
      ),
    );
  }
}
