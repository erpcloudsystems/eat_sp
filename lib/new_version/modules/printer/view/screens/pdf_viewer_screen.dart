import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final List<int> invoiceData;

  const PdfViewerScreen({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    Uint8List pdfBytes = Uint8List.fromList(invoiceData);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice PDF'),
      ),
      body: SfPdfViewer.memory(
        pdfBytes,
      ),
    );
  }
}
