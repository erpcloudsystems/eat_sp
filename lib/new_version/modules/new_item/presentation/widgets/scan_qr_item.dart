import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQrItemWidget extends StatefulWidget {
  const ScanQrItemWidget({super.key});

  @override
  State<ScanQrItemWidget> createState() => _ScanQrItemWidgetState();
}

class _ScanQrItemWidgetState extends State<ScanQrItemWidget> {
  String scanBarcode = '';
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
