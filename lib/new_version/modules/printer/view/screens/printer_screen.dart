import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import '../../controller/cubit/printer_cubit.dart';
import '../widgets/scan_widget.dart';

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsManager.printerSettings.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringsManager.printers.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    // Reload the device state when the user presses refresh
                    setState(() {
                      context.read<PrinterCubit>().loadDevice();
                    });
                  },
                  icon: const Icon(Icons.refresh_outlined),
                ),
              ],
            ),
            const Gutter(),
            const Flexible(
              child: ScanBluetoothDevicesWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
