import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../../widgets/snack_bar.dart';

class PdfVeiwerDownloadScreen extends StatelessWidget {
  const PdfVeiwerDownloadScreen({super.key, required this.file});
  final File? file;

  Future<void> savePdfToDownloads(BuildContext context, File file) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        showSnackBar('Storage permission denied', context, color: Colors.red);
        return;
      }
      // Save the file to the downloads folder
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      final fileName = path.basename(file.path);
      final newPath = path.join(downloadsDirectory.path, fileName);
      await file.copy(newPath);
      showSnackBar('PDF saved to downloads', context, color: Colors.green);
    } catch (e) {
      showSnackBar('Error saving PDF: $e', context, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await savePdfToDownloads(context, file!);
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(file!),
    );
  }
}
