import 'package:NextApp/core/constants.dart';
import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_bloc.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_state.dart';
import 'package:NextApp/widgets/nothing_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../widgets/custom_loading.dart';
import '../../../../../widgets/dismiss_keyboard.dart';
import '../../../../core/resources/routes.dart';
import '../../../../core/utils/error_dialog.dart';
import '../../../../core/utils/request_state.dart';
import '../../data/models/item_filter.dart';
import '../widgets/item_card_widget.dart';
import '../widgets/new_search_widget.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({
    super.key,
    required this.itemGroup,
    required this.priceList,
  });
  final String itemGroup, priceList;

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  String searchText = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  void loadData() {
    final bloc = BlocProvider.of<NewItemBloc>(context);
    bloc.add(const ResetItemEvent());

    bloc.add(
      GetItemEvent(
        itemFilter: ItemsFilter(
          itemGroup: widget.itemGroup,
          priceList: widget.priceList,
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      searchText = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select Item',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  Flexible(
                    child: NewSearchWidget(
                      searchFunction: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      scanBarcodeNormal();
                    },
                    child: const Icon(
                      Icons.qr_code_outlined,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<NewItemBloc, ItemState>(
          listenWhen: (previous, current) =>
              previous.getItemsState != current.getItemsState,
          listener: (context, state) {
            if (state.getItemsState == RequestState.error) {
              Navigator.of(context).pushReplacementNamed(Routes.noDataScreen);
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  errorMessage: state.getItemMessage,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.getItemData != current.getItemData,
          builder: (context, state) {
            List<ItemEntity> filteredData = state.getItemData
                .where(
                  (item) =>
                      item.itemName
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) ||
                      item.itemCode
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) ||
                      item.barCode
                          .toLowerCase()
                          .contains(searchText.toLowerCase()),
                )
                .toList();

            return state.getItemsState == RequestState.loading
                ? const CustomLoadingWithImage()
                : AnimationLimiter(
                    child: filteredData.isEmpty
                        ? const NothingHere()
                        : GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: .513,
                            children: List.generate(
                              filteredData.length,
                              (int index) {
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 1500),
                                  columnCount: 3,
                                  child: SlideAnimation(
                                    verticalOffset: 100.0,
                                    child: FadeInAnimation(
                                      child: ItemCardWidget(
                                        itemCode: filteredData[index].itemCode,
                                        itemName: filteredData[index].itemName,
                                        itemGroup: filteredData[index].itemGroup,
                                        rate: filteredData[index].netRate,
                                        uom: filteredData[index].uom,
                                        imageUrl: filteredData[index].imageUrl,
                                        uomList: filteredData[index].uomList,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  );
          },
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Container(
            width: 90.w,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: APPBAR_COLOR,
            ),
            child: const Center(
              child: Text(
                'Finish',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}