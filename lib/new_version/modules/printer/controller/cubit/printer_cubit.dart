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
  Future<void> loadDevice() async {
    requestBluetoothPermissions();
    emit(PrinterLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString(connectedPrinterKey);
    print('--------------------------------');
    print(deviceId);
    print(deviceId != null);

    // if (deviceId != null) {
    //   print(deviceId);
    //   FlutterBlue flutterBlue = FlutterBlue.instance;
    //   List<BluetoothDevice> connectedDevices =
    //       await flutterBlue.connectedDevices;
    //   print(connectedDevices);

    //   for (var device in connectedDevices) {
    //     print(device.name);
    //     if (device.id.toString() == deviceId) {
    //       print(device.name);
    //       defaultDevice = device;
    //       emit(PrinterConnected(defaultDevice!));
    //       return;
    //     }
    //   }
    // }
    // emit(PrinterError());
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
      await loadDevice();

      if (defaultDevice != null) {
        // Connect and print using the saved device
        await connectAndPrintToBluetoothPrinter(defaultDevice!, invoiceData);
        emit(PrinterPrintingSuccess());
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
      if (defaultDevice == null || device.id != defaultDevice?.id) {
        await device.connect();
        await saveDevice(device); // Save device when connected
      }

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
      Fluttertoast.showToast(msg: 'Failed to print');
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
      await Printing.layoutPdf(
          onLayout: (format) async => response.data, format: PdfPageFormat.a4);
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
