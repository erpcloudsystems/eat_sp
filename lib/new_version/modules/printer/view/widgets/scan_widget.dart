import 'dart:async';
import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  @override
  void initState() {
    final cubit = context.read<PrinterCubit>();
    super.initState();
    Future.delayed(Duration.zero, () async {
      await cubit.requestBluetoothPermissions();
      if (mounted) {
        cubit.loadDevice();
      }
      // _startScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final printerCubit = context.watch<PrinterCubit>();

    return printerCubit.state is PrinterLoading
        ? const Center(child: CircularProgressIndicator())
        : printerCubit.state is PrinterError
            ? Center(
                child: Text(
                  StringsManager.noData.tr(),
                ),
              )
            : ListView.builder(
                itemCount: printerCubit.allDevices.length,
                itemBuilder: (context, index) {
                  final device = printerCubit.allDevices[index];
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
                      onLongPress: () async {
                        // Connect to the selected device
                        if ((printerCubit.defaultDevice != null)) {
                          await printerCubit.clearDevice();
                        }
                      },
                      onTap: () async {
                        // Check if Bluetooth is turned on
                        FlutterBluePlus.adapterState
                            .listen((BluetoothAdapterState state) async {
                          print(state);
                          if (state == BluetoothAdapterState.on) {
                            await printerCubit.saveDevice(device);
                            await printerCubit.loadDevice();
                            setState(() {});
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  'Please enable Bluetooth to connect to the device.',
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        });
                      },
                    ),
                  );
                },
              );
  }
}
