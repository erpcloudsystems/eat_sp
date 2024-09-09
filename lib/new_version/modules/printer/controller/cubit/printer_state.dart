// printer_state.dart
part of 'printer_cubit.dart';

abstract class PrinterState extends Equatable {
  const PrinterState();

  @override
  List<Object> get props => [];
}

class PrinterInitial extends PrinterState {}

class PrinterLoading extends PrinterState {}

class PrinterConnected extends PrinterState {
  final BluetoothDevice device;

  const PrinterConnected(this.device);

  @override
  List<Object> get props => [device];
}

class PrinterPrintingSuccess extends PrinterState {}

class PrinterDisconnected extends PrinterState {}

class PrinterError extends PrinterState {}
