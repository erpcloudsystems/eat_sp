import 'package:NextApp/core/constants.dart';
import 'package:NextApp/widgets/nothing_here.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../../widgets/custom_loading.dart';
import '../../../../../widgets/dismiss_keyboard.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/utils/error_dialog.dart';
import '../../data/models/item_filter.dart';
import '../cubit/cubit/items_cubit.dart';
import '../widgets/item_card_widget.dart';
import '../widgets/new_search_widget.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({
    super.key,
    this.itemGroup,
    required this.priceList,
  });
  final String priceList;
  final String? itemGroup;

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void loadData() {
    final bloc = BlocProvider.of<ItemsCubit>(context);
    bloc.resetItem();
    bloc.getAllItems(
      itemFilter: ItemsFilter(priceList: widget.priceList, startKey: 1),
    );
  }

  Future<void> scanBarcodeNormal() async {
    final bloc = BlocProvider.of<ItemsCubit>(context);
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
    bloc.getAllItems(
      itemFilter: ItemsFilter(
        priceList: widget.priceList,
        searchText: barcodeScanRes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ItemsCubit>(context);
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
                        bloc.getAllItems(
                          itemFilter: ItemsFilter(
                            priceList: widget.priceList,
                            searchText: value,
                          ),
                        );
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
        body: BlocConsumer<ItemsCubit, ItemsState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GettingAllItemsFailedState) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  errorMessage: StringsManager.noItemAvailable.tr(),
                ),
              );
            }
          },
          // buildWhen: (previous, current) =>
          //     previous.getItemData != current.getItemData,
          builder: (context, state) {
            if (state is GettingItemsLoadingState) {
              return const CustomLoadingWithImage();
            }
            if (state is GettingAllItemsFailedState) {
              return const NothingHere();
            }
            return Column(
              children: [
                Flexible(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification) {
                        // Detect when the user has reached the end of the list.
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        if (scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                          // Load more data here by dispatching a new GetItemEvent with pagination information.
                          bloc.getAllItems(
                            itemFilter: ItemsFilter(
                              priceList: widget.priceList,
                              startKey: bloc.items.length + 1,
                            ),
                          );
                        }
                      }

                      return false;
                    },
                    child: AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bloc.items.length,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 1500),
                            child: SlideAnimation(
                              verticalOffset: 100.0,
                              child: FadeInAnimation(
                                child: ItemCardWidget(
                                  itemTaxTemplate:
                                      bloc.items[index].itemTaxTemplate,
                                  taxPercent: bloc.items[index].taxPercent,
                                  itemCode: bloc.items[index].itemCode,
                                  itemName: bloc.items[index].itemName,
                                  itemGroup: bloc.items[index].itemGroup,
                                  rate: bloc.items[index].netRate,
                                  uom: bloc.items[index].uom,
                                  imageUrl: bloc.items[index].imageUrl,
                                  uomList: bloc.items[index].uomList,
                                  priceListRate:
                                      bloc.items[index].priceListRate,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (!bloc.hasReachedMax && isLoading)
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 5,
                      child: LinearProgressIndicator(
                        color: LOADING_PROGRESS_COLOR,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 90.w,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: APPBAR_COLOR,
            ),
            child: Center(
              child: Text(
                'Finish'.tr(),
                style: const TextStyle(
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
