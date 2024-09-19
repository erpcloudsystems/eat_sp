import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/constants.dart';
import '../../../../../service/service.dart';
import '../../../../../service/service_constants.dart';
import '../../../../../widgets/dialog/loading_dialog.dart';
import '../../../../core/network/api_constance.dart';
import '../../../../core/resources/strings_manager.dart';
part 'printer_state.dart';

class PrinterCubit extends Cubit<PrinterState> {
  PrinterCubit() : super(PrinterInitial());

  BluetoothDevice? defaultDevice;
  String? deviceId;

  // Save connected device ID
  Future<void> saveDevice(BluetoothDevice device) async {
    emit(PrinterLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

    emit(PrinterLoading());

    // Load saved device ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceId = prefs.getString(connectedPrinterKey);

    print('Cached printer found with ID: $deviceId');

    // Check if the device is already connected
    List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
    bool deviceFound = false;

    for (var device in connectedDevices) {
      allDevices.add(device);
      if (device.remoteId.toString() == deviceId) {
        defaultDevice = device;
        emit(PrinterConnected(defaultDevice!));
        deviceFound = true;
        break;
      }
    }

    if (!deviceFound) {
      // If device not found in connected devices, start scanning for new devices
       FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // Listen to scan results and populate the allDevices list
      FlutterBluePlus.scanResults.listen((results) {
        for (var result in results) {
          if (!allDevices.any((d) => d.remoteId == result.device.remoteId)) {
            allDevices.add(result.device); // Add only unique devices
          }

          if (result.device.remoteId.toString() == deviceId) {
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
      // Check if the device is already connected
      if (defaultDevice == null ||
          device.remoteId.toString() != defaultDevice!.remoteId.toString()) {
        await device.connect();
        defaultDevice = device;
      }

      // Discover services after ensuring the device is connected
      List<BluetoothService> services = await device.discoverServices();
      bool invoicePrinted = false; // Track if the invoice has been printed

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.write && !invoicePrinted) {
            List<List<int>> chunks = splitDataIntoChunks(invoiceData);
            for (List<int> chunk in chunks) {
              await characteristic.write(chunk);
            }
            Fluttertoast.showToast(msg: 'Invoice sent to printer');
            invoicePrinted = true;
            break;
          }
        }
        if (invoicePrinted) break; // Exit the service loop if printed
      }

      // Ensure the state is updated after successful printing
      emit(PrinterPrintingSuccess());
    } catch (e) {
      debugPrint('Error while printing to Bluetooth: $e');
      Fluttertoast.showToast(msg: 'Failed to print: $e');
      emit(PrinterError());
    }
  }

  // Connect with backend
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
            queryParameters: {
              'doctype': docType == DocTypesName.returnD
                  ? DocTypesName.salesInvoice
                  : docType,
              'name': id,
              'format': selectPrintFormat(docType),
            },
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

      await printInvoice(
        context: context,
        invoiceData: response.data,
      );
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      debugPrint('Error while printing: $e');
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    }
  }

  String selectPrintFormat(String docType) {
    switch (docType) {
      case DocTypesName.salesInvoice:
        return 'فاتورة ضريبية';
      case DocTypesName.returnD:
        return 'فاتورة مرتجع';
      default:
        return 'POS Arabic';
    }
  }

  Future<void> requestBluetoothPermissions() async {
    // Request Bluetooth scan permission
    PermissionStatus bluetoothScanStatus =
        await Permission.bluetoothScan.request();
    PermissionStatus bluetoothConnectStatus =
        await Permission.bluetoothConnect.request();
    PermissionStatus locationStatus = await Permission.location.request();
    await Permission.storage.request();

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

  List<List<int>> splitDataIntoChunks(List<int> data) {
    List<List<int>> chunks = [];
    int chunkSize = 245;
    int offset = 0;

    while (offset < data.length) {
      int end =
          (offset + chunkSize < data.length) ? offset + chunkSize : data.length;
      chunks.add(data.sublist(offset, end));
      offset = end;
    }
    return chunks;
  }
}
