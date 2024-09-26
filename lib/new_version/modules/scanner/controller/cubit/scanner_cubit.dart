import 'package:NextApp/models/list_models/selling_list_model/customer_list_model.dart';
import 'package:NextApp/new_version/core/network/api_constance.dart';
import 'package:NextApp/new_version/core/network/dio_helper.dart';
import 'package:NextApp/new_version/core/network/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../core/global/dependency_container.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(ScannerInitial());

  CustomerItemModel? customerItemModel;
  Future<void> scanCustomerBarCode() async {
    {
      try {
        emit(BarcodeScannerLoadingState());
        String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.BARCODE,
        );
        print(barcodeScanResult);

        customerItemModel = await getCustomerByBarCode(barcodeScanResult);
        emit(BarcodeScannerSuccessState(customerItemModel!));
      } on PrimaryServerException catch (error) {
        emit(BarcodeScannerErrorState(error.message));
      } catch (error) {
        emit(BarcodeScannerErrorState(error.toString()));
      }
    }
  }

  // Get Customer by BarCode

  Future<CustomerItemModel> getCustomerByBarCode(String result) async {
    final dio = sl<BaseDioHelper>();
    final response = await dio.get(
      endPoint: ApiConstance.customerBarcodeEdPoint,
      query: {'name': result},
    ) as Response;
    return CustomerItemModel.fromJson(response.data['message']);
  }
}
