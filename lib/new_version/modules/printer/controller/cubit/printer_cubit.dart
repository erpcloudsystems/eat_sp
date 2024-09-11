import 'dart:typed_data';

import 'package:NextApp/service/service.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import '../../../../../core/constants.dart';
import '../../../../../service/service_constants.dart';
import '../../../../../widgets/dialog/loading_dialog.dart';
import '../../../../core/network/api_constance.dart';

part 'printer_state.dart';

class PrinterCubit extends Cubit<PrinterState> {
  PrinterCubit() : super(PrinterInitial());

  BluetoothDevice? defaultDevice;
  String? deviceId;

  // Save connected device ID
  Future<void> saveDevice(BluetoothDevice device) async {
    emit(PrinterLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(device.id.toString());
    await prefs.setString(connectedPrinterKey, device.id.toString());
    defaultDevice = device;
    emit(PrinterConnected(defaultDevice!));
  }

  void setDefaultDevice(BluetoothDevice device) {
    emit(PrinterConnected(device));
  }

  // Load connected device ID
  List<BluetoothDevice> allDevices = [];

  Future<void> loadDevice() async {
    // Request Bluetooth permissions
    allDevices.clear();
    await requestBluetoothPermissions();
    emit(PrinterLoading());

    // Load saved device ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString(connectedPrinterKey);

    FlutterBlue flutterBlue = FlutterBlue.instance;

    print('Cached printer found with ID: $deviceId');

    // Check if the device is already connected
    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
    bool deviceFound = false;

    for (var device in connectedDevices) {
      allDevices.add(device); // Add connected devices to the list
      if (device.id.toString() == deviceId) {
        defaultDevice = device;
        emit(PrinterConnected(defaultDevice!));
        deviceFound = true;
        break;
      }
    }

    if (!deviceFound) {
      // If device not found in connected devices, start scanning for new devices
      flutterBlue.startScan(timeout: const Duration(seconds: 10));

      // Listen to scan results and populate the allDevices list
      flutterBlue.scanResults.listen((results) {
        for (var result in results) {
          if (!allDevices.any((d) => d.id == result.device.id)) {
            allDevices.add(result.device); // Add only unique devices
          }

          if (result.device.id.toString() == deviceId) {
            defaultDevice = result.device;
            result.device.connect().then((_) {
              emit(PrinterConnected(defaultDevice!));
            }).catchError((error) {
              emit(PrinterError());
              Fluttertoast.showToast(
                msg: 'Failed to connect to the printer.',
              );
            });
            return;
          }
        }

        // If no matching device found, emit PrinterDisconnected
        emit(PrinterDisconnected());
      });
    }
  }

  // Clear saved device
  Future<void> clearDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(connectedPrinterKey);
    defaultDevice = null;
    emit(PrinterDisconnected());
  }

  // External function to trigger the print action
  Future<void> printInvoice({
    required BuildContext context,
    required List<int> invoiceData,
  }) async {
    try {
      emit(PrinterLoading());

      if (defaultDevice != null) {
        // Connect and print using the saved device
        await connectAndPrintToBluetoothPrinter(defaultDevice!, invoiceData);
        emit(PrinterPrintingSuccess());
        await Printing.layoutPdf(
            onLayout: (format) async => Uint8List.fromList(invoiceData),
            format: PdfPageFormat.a4);
      } else {
        Fluttertoast.showToast(
          msg: 'No printer connected. Please set a printer in the settings.',
        );
        emit(PrinterError());
      }
    } catch (e) {
      debugPrint('Error while printing: $e');
      Fluttertoast.showToast(msg: 'Failed to print: $e');
      emit(PrinterError());
    }
  }

  Future<void> connectAndPrintToBluetoothPrinter(
      BluetoothDevice device, List<int> invoiceData) async {
    try {
      // Check if device is already connected
      if (device.id.toString() != defaultDevice!.id.toString()) {
        await device.connect();
        //  await saveDevice(device); // Save device when connected
      }

      // Discover services after ensuring the device is connected
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.write) {
            await characteristic.write(invoiceData);
            Fluttertoast.showToast(msg: 'Invoice sent to printer');
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('Error while printing to Bluetooth: $e');

      emit(PrinterError());
    }
  }

  //connect with backend
  void printInvoiceServices({
    required BuildContext context,
    required String docType,
    required String id,
    required String format,
  }) async {
    await showLoadingDialog(context, 'Fetching invoice data...');

    try {
      // Fetch the invoice data from the backend
      final response = await APIService().dio.get(
            PRINT_INVOICE,
            queryParameters: {'doctype': docType, 'name': id, 'format': format},
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: ApiConstance.receiveTimeOut,
              validateStatus: (status) {
                if (status == null) return false;
                return status < 500;
              },
            ),
          );

      Navigator.pop(context);

      await printInvoice(
        context: context,
        invoiceData: response.data,
      );
    } catch (e) {
      Navigator.pop(context);
      debugPrint('Error while printing: $e');
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    }
  }

  Future<void> requestBluetoothPermissions() async {
    // Request Bluetooth scan permission
    PermissionStatus bluetoothScanStatus =
        await Permission.bluetoothScan.request();
    PermissionStatus bluetoothConnectStatus =
        await Permission.bluetoothConnect.request();
    PermissionStatus locationStatus = await Permission.location.request();

    // Check if any permission is denied
    if (bluetoothScanStatus.isDenied ||
        bluetoothConnectStatus.isDenied ||
        locationStatus.isDenied) {
      Fluttertoast.showToast(
          msg:
              "Permissions denied. Please grant Bluetooth and Location permissions.");
      return;
    }

    // Handle permanently denied permissions
    if (bluetoothScanStatus.isPermanentlyDenied ||
        bluetoothConnectStatus.isPermanentlyDenied ||
        locationStatus.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg:
              "Permissions permanently denied. Please go to settings to enable them.");
      openAppSettings();
    }
  }
}
