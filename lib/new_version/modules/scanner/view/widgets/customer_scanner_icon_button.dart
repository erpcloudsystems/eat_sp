import 'package:NextApp/models/list_models/selling_list_model/customer_list_model.dart';
import 'package:NextApp/new_version/modules/scanner/controller/cubit/scanner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomerScannerIconButton extends StatefulWidget {
  const CustomerScannerIconButton({super.key, required this.onCustomerFetched});
  final Function(CustomerItemModel) onCustomerFetched;

  @override
  State<CustomerScannerIconButton> createState() =>
      _CustomerScannerIconButtonState();
}

class _CustomerScannerIconButtonState extends State<CustomerScannerIconButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerCubit, ScannerState>(
      listenWhen: (previous, current) => previous != previous,
      listener: (context, state) {
        if (state is BarcodeScannerSuccessState) {
          widget.onCustomerFetched(state.customerItemModel);
          Fluttertoast.showToast(msg: 'Customer fetched');
        } else if (state is BarcodeScannerErrorState) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Center(
          child: IconButton(
            onPressed: () async =>
                await context.read<ScannerCubit>().scanCustomerBarCode(),
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}
