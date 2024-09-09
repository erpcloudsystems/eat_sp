import 'dart:async';
import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

import '../../controller/cubit/printer_cubit.dart';

class ScanBluetoothDevicesWidget extends StatefulWidget {
  const ScanBluetoothDevicesWidget({super.key});

  @override
  State<ScanBluetoothDevicesWidget> createState() =>
      _ScanBluetoothDevicesWidgetState();
}

class _ScanBluetoothDevicesWidgetState
    extends State<ScanBluetoothDevicesWidget> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> devices = [];
  bool isScanning = true;
  late StreamSubscription<List<ScanResult>> scanSubscription;
  late final PrinterCubit printerCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    printerCubit = context.watch<PrinterCubit>();

    flutterBlue.startScan(timeout: const Duration(seconds: 5)).then((_) {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    });

    scanSubscription = flutterBlue.scanResults.listen((results) {
      if (mounted) {
        for (var device in results) {
          print(device.device.id.toString() == printerCubit.deviceId);
          print('device.device.id.toString() == printerCubit.deviceId');
          if (device.device.id.toString() == printerCubit.deviceId) {
            printerCubit.setDefaultDevice(device.device);

            break;
          }
        }
        setState(() {
          devices = results;
        });
      }
    });
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    scanSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isScanning
        ? const Center(child: CircularProgressIndicator())
        : devices.isEmpty
            ? Center(
                child: Text(
                  StringsManager.noData.tr(),
                ),
              )
            : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  print(devices[index].device.id ==
                      printerCubit.defaultDevice!.id);
                  return ListTile(
                    title: Text(
                        '${printerCubit.defaultDevice != null && devices[index].device.id == printerCubit.defaultDevice!.id ? StringsManager.connectedPrinter.tr() : ''} ${devices[index].device.name.isEmpty ? "Unknown" : devices[index].device.name}'),
                    subtitle: Text(devices[index].device.id.toString()),
                    trailing: Icon(
                      Icons.check_circle,
                      color: printerCubit.defaultDevice != null &&
                              devices[index].device.id ==
                                  printerCubit.defaultDevice!.id
                          ? Colors.green
                          : Colors.grey,
                    ),
                    onTap: () async {
                      // Save the selected device
                      await printerCubit.saveDevice(devices[index].device);
                      setState(() {});
                    },
                  );
                },
              );
  }
}
