import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
final String path;

  const PDFScreen({super.key, required this.path});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int? _totalPages = 0;
  int? _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: widget.path, // Replace with actual file path
        onPageChanged: (int? page, int? total) {
          setState(() {
            _currentPage = page;
            _totalPages = total;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Page $_currentPage of $_totalPages'),
        ),
      ),
    );
  }
}
