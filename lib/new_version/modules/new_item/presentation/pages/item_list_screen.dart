import 'package:NextApp/core/constants.dart';
import 'package:NextApp/widgets/nothing_here.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../widgets/custom_loading.dart';
import '../../../../../widgets/dismiss_keyboard.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../data/models/item_filter.dart';
import '../cubit/cubit/items_cubit.dart';
import '../widgets/item_card_widget.dart';
import '../widgets/new_search_widget.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen(
      {super.key,
      this.itemGroup,
      this.allowSales,
      required this.priceList,
      this.warehouse});
  final String priceList;
  final String? itemGroup;
  final int? allowSales;
  final String? warehouse;

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
      itemFilter: ItemsFilter(
        priceList: widget.priceList,
        startKey: 0,
        allowSales: widget.allowSales,
        warehouse: widget.warehouse,
      ),
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
        allowSales: widget.allowSales,
        warehouse: widget.warehouse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ItemsCubit>(context);
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Select Item'.tr(),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                ),
          ),
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              StringsManager.finish.tr(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: BlocConsumer<ItemsCubit, ItemsState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GettingAllItemsFailedState) {
              Fluttertoast.showToast(
                msg: StringsManager.noItemAvailable.tr(),
              );
            }
          },
          builder: (context, state) {
            if (state is GettingAllItemsFailedState && bloc.items.isEmpty) {
              return const NothingHere();
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: NewSearchWidget(
                          searchFunction: (value) {
                            bloc.getAllItems(
                              itemFilter: ItemsFilter(
                                priceList: widget.priceList,
                                searchText: value,
                                allowSales: widget.allowSales,
                                warehouse: widget.warehouse,
                              ),
                            );
                          },
                        ),
                      ),
                      const Gutter.small(),
                      InkWell(
                        onTap: () {
                          scanBarcodeNormal();
                        },
                        child: const Icon(
                          Icons.qr_code_outlined,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: state is GettingItemsLoadingState
                      ? const CustomLoadingWithImage()
                      : NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is ScrollEndNotification) {
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
                                    allowSales: widget.allowSales,
                                    warehouse: widget.warehouse,
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
                                        taxPercent:
                                            bloc.items[index].taxPercent,
                                        itemCode: bloc.items[index].itemCode,
                                        itemName: bloc.items[index].itemName,
                                        itemGroup: bloc.items[index].itemGroup,
                                        rate: bloc.items[index].netRate,
                                        uom: bloc.items[index].stockUom,
                                        imageUrl: bloc.items[index].imageUrl,
                                        priceListRate:
                                            bloc.items[index].priceListRate,
                                        qty: bloc.items[index].qty,
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
      ),
    );
  }
}
