part of 'scanner_cubit.dart';

sealed class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object> get props => [];
}

final class ScannerInitial extends ScannerState {}

final class BarcodeScannerLoadingState extends ScannerState {}

final class BarcodeScannerErrorState extends ScannerState {
  final String message;
  const BarcodeScannerErrorState(this.message);

  @override
  List<Object> get props => [message];
}

final class BarcodeScannerSuccessState extends ScannerState {
  final CustomerItemModel customerItemModel;
  const BarcodeScannerSuccessState(this.customerItemModel);
  @override
  List<Object> get props => [customerItemModel];
}
