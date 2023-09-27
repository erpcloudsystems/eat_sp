import 'package:NextApp/core/constants.dart';
import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_bloc.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_state.dart';
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
import '../../../../../widgets/nothing_here.dart';
import '../../../../core/resources/strings_manager.dart';
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
    final bloc = BlocProvider.of<NewItemBloc>(context);
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

    bloc.add(
      GetItemEvent(
        itemFilter: ItemsFilter(
          itemGroup: widget.itemGroup,
          priceList: widget.priceList,
          searchText: barcodeScanRes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewItemBloc>(context);
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
                        bloc.add(
                          GetItemEvent(
                            itemFilter: ItemsFilter(
                              itemGroup: widget.itemGroup,
                              priceList: widget.priceList,
                              searchText: value,
                            ),
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
        body: BlocConsumer<NewItemBloc, ItemState>(
          // listenWhen: (previous, current) =>
          //     previous.getItemsState != current.getItemsState,
          listener: (context, state) {
            if (state.getItemsState == RequestState.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  errorMessage: StringsManager.noItemAvailable.tr(),
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.getItemData != current.getItemData,
          builder: (context, state) {
            return state.getItemsState == RequestState.loading
                ? const CustomLoadingWithImage()
                : Column(
                    children: [
                      Flexible(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is ScrollEndNotification) {
                              // Detect when the user has reached the end of the list.

                              if (scrollNotification.metrics.pixels ==
                                  scrollNotification.metrics.maxScrollExtent) {
                                // Load more data here by dispatching a new GetItemEvent with pagination information.

                                bloc.add(
                                  GetItemEvent(
                                    itemFilter: ItemsFilter(
                                      itemGroup: widget.itemGroup,
                                      priceList: widget.priceList,
                                      startKey: state.getItemData.length + 1,
                                    ),
                                  ),
                                );
                              }
                            }

                            return false;
                          },
                          child: AnimationLimiter(
                            child: state.getItemData.isEmpty
                                ? const NothingHere()
                                : GridView.count(
                                    controller: scrollController,
                                    crossAxisCount: 2,
                                    childAspectRatio: .513,
                                    children: List.generate(
                                      state.getItemData.length,
                                      (int index) {
                                        return AnimationConfiguration
                                            .staggeredGrid(
                                          position: index,
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          columnCount: 3,
                                          child: SlideAnimation(
                                            verticalOffset: 100.0,
                                            child: FadeInAnimation(
                                              child: ItemCardWidget(
                                                itemCode: state
                                                    .getItemData[index]
                                                    .itemCode,
                                                itemName: state
                                                    .getItemData[index]
                                                    .itemName,
                                                itemGroup: state
                                                    .getItemData[index]
                                                    .itemGroup,
                                                rate: state
                                                    .getItemData[index].netRate,
                                                uom: state
                                                    .getItemData[index].uom,
                                                imageUrl: state
                                                    .getItemData[index]
                                                    .imageUrl,
                                                uomList: state
                                                    .getItemData[index].uomList,
                                                priceListRate: state
                                                    .getItemData[index]
                                                    .priceListRate,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      if (!state.hasReachedMax && isLoading)
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