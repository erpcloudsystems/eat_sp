// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class CustomDropdown extends StatefulWidget {
//   const CustomDropdown({super.key});

//   @override
//   State<CustomDropdown> createState() => _CustomDropdownState();
// }

// class _CustomDropdownState extends State<CustomDropdown> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AddressBloc, AddressState>(
//       listenWhen: (previous, current) =>
//           previous.setPrimaryAddressState != current.setPrimaryAddressState,
//       listener: setPrimaryAddressStateHandler,
//       buildWhen: (previous, current) =>
//           previous.getAllAddressesState != current.getAllAddressesState,
//       builder: getAllAddressBuilderHandler,
//     );
//   }

//   Widget getAllAddressBuilderHandler(BuildContext context, AddressState state) {
//     switch (state.getAllAddressesState) {
//       case RequestState.loading:
//         return const Center(child: CircularProgressIndicator());

//       case RequestState.error:
//         ErrorDialogUtils.displayErrorDialog(
//             context: context, errorMessage: state.getAllAddressesMessage);
//         break;

//       case RequestState.success:
//         final List<AddressEntity> addressesList = state.getAllAddressesData;
//         final primaryAddress = addressesList
//             .firstWhereOrNull((element) => element.isDefaultAddress == true);

//         return addressesList.isEmpty
//             ? const SizedBox()
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     StringsManager.primaryAddress(context),
//                     style: Theme.of(context)
//                         .textTheme
//                         .headlineMedium!
//                         .copyWith(color: ColorsManager.mainColor),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: DoubleManager.d_10),
//                     child: DropdownButtonFormField<AddressEntity>(
//                       value: primaryAddress,
//                       items: addressesList
//                           .map((value) => DropdownMenuItem<AddressEntity>(
//                                 value: value,
//                                 child: Text(
//                                   value.addressTitle!,
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         context
//                             .read<AddressBloc>()
//                             .add(SetPrimaryAddressEvent(addressId: value!.id!));
//                       },
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsetsDirectional.only(
//                             start: DoubleManager.d_45),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//       default:
//         return const SizedBox();
//     }
//     return const SizedBox();
//   }

//   void setPrimaryAddressStateHandler(BuildContext context, AddressState state) {
//     switch (state.setPrimaryAddressState) {
//       case RequestState.loading:
//         LoadingUtils.showLoadingDialog(context, LoadingType.linear,
//             StringsManager.changingAddress(context));
//         break;
//       case RequestState.success:
//         SnackBarUtil().getSnackBar(
//           context: context,
//           message: StringsManager.primaryAddressChanged(context),
//           color: ColorsManager.gGreen,
//         );
//         Navigator.of(context).pop();
//         break;
//       case RequestState.error:
//         Navigator.of(context).pop();
//         ErrorDialogUtils.displayErrorDialog(
//             context: context, errorMessage: state.setPrimaryAddressMessage);
//         break;
//       default:
//     }
//   }
// }