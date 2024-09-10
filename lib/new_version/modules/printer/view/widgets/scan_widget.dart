import 'dart:async';
import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  // List<ScanResult> devices = [];
  // bool isScanning = false;
  // StreamSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PrinterCubit>().loadDevice();
      // _startScan();
    });
  }

  // void _startScan() {
  //   setState(() {
  //     isScanning = true;
  //   });

  //   // Start scanning
  //   flutterBlue.startScan(timeout: const Duration(seconds: 15)).then((_) {
  //     if (mounted) {
  //       setState(() {
  //         isScanning = false;
  //       });
  //     }
  //   });

  //   // Listen to scan results
  //   scanSubscription = flutterBlue.scanResults.listen((results) {
  //     if (results.isNotEmpty) {
  //       setState(() {
  //         devices = results;
  //       });
  //       for (var result in results) {
  //         print('Device found: ${result.device.name} (${result.device.id})');
  //       }
  //     } else {
  //       print("No devices found during scan.");
  //     }
  //   }, onError: (error) {
  //     print("Error while scanning: $error");
  //   });
  // }

  // @override
  // void dispose() {
  //   flutterBlue.stopScan();
  //   scanSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final printerCubit = context.watch<PrinterCubit>();

    return printerCubit.state is PrinterLoading
        ? const Center(child: CircularProgressIndicator())
        : printerCubit.connectedDevices.isEmpty
            ? Center(
                child: Text(
                  StringsManager.noData.tr(),
                ),
              )
            : ListView.builder(
                itemCount: printerCubit.connectedDevices.length,
                itemBuilder: (context, index) {
                  final device = printerCubit.connectedDevices[index];
                  final isConnectedDevice =
                      printerCubit.defaultDevice != null &&
                          device.id == printerCubit.defaultDevice!.id;

                  return Card(
                    child: ListTile(
                      title: Text(
                        '${isConnectedDevice ? StringsManager.connectedPrinter.tr() : ''} ${device.name.isEmpty ? "Unknown" : device.name}',
                      ),
                      subtitle: Text(device.id.toString()),
                      trailing: Icon(
                        Icons.check_circle,
                        color: isConnectedDevice ? Colors.green : Colors.grey,
                      ),
                      onTap: () async {
                        // Save the selected device
                        await printerCubit.saveDevice(device);
                        await printerCubit.loadDevice();
                        setState(() {});
                      },
                    ),
                  );
                },
              );
  }
}
