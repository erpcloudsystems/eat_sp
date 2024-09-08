import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  BluetoothManager._internal();
  factory BluetoothManager() => _instance;

  final Set<BluetoothDevice> _connectedDevices = {};

  Set<BluetoothDevice> get connectedDevices => _connectedDevices;

  void addDevice(BluetoothDevice device) {
    _connectedDevices.add(device);
  }

  void removeDevice(BluetoothDevice device) {
    _connectedDevices.remove(device);
  }

  bool isDeviceConnected(BluetoothDevice device) {
    return _connectedDevices.contains(device);
  }
}
