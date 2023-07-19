import 'package:NextApp/core/constants.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_bloc.dart';
import 'package:NextApp/new_version/modules/new_item/presentation/bloc/new_item_state.dart';
import 'package:NextApp/widgets/nothing_here.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../widgets/custom_loading.dart';
import '../../../../../widgets/dismiss_keyboard.dart';
import '../../../../core/utils/request_state.dart';
import '../../data/models/item_filter.dart';
import '../widgets/new_search_widget.dart';
import 'item_list_screen.dart';

class ItemGroupScreen extends StatefulWidget {
  const ItemGroupScreen({super.key, required this.priceList});
  final String priceList;

  @override
  State<ItemGroupScreen> createState() => _ItemGroupScreenState();
}

class _ItemGroupScreenState extends State<ItemGroupScreen> {
  String searchText = '';
  @override
  void didChangeDependencies() {
    final bloc = BlocProvider.of<NewItemBloc>(context);
    bloc.add(
      GetItemGroupEvent(
        itemFilter: ItemsFilter(
          itemGroup: '',
        ),
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String? parentGroup;
    String? previousParentGroup;
    final bloc = BlocProvider.of<NewItemBloc>(context);
    return BlocConsumer<NewItemBloc, ItemState>(
      // listenWhen: (previous, current) {

      //   return current.getItemGroupData != current.getItemGroupData;
      // },
      listener: (context, state) {
        previousParentGroup = state.getItemGroupData[0].previousParent;
        if (state.getItemGroupState == RequestState.error) {}
      },
      // buildWhen: (previous, current) =>
      //     previous.getItemGroupData != current.getItemGroupData,
      builder: (context, state) {
        return DismissKeyboard(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Select Item Group',
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: NewSearchWidget(
                  searchFunction: (value) {
                    if (value.isNotEmpty) {
                      bloc.add(
                        GetItemGroupEvent(
                          itemFilter: ItemsFilter(
                            itemGroup: '',
                            searchText: value,
                          ),
                        ),
                      );
                      print(state.getItemGroupState);
                    } else {
                      bloc.add(
                        GetItemGroupEvent(
                          itemFilter: ItemsFilter(
                            itemGroup: '',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            body: state.getItemGroupState == RequestState.loading
                ? const CustomLoadingWithImage()
                : Column(
                    children: [
                      if (previousParentGroup != null &&
                          previousParentGroup != 'none')
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                bloc.add(
                                  GetItemGroupEvent(
                                    itemFilter: ItemsFilter(
                                      itemGroup: previousParentGroup ?? '',
                                    ),
                                  ),
                                );

                                parentGroup = previousParentGroup;
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    previousParentGroup == ''
                                        ? "Back"
                                        : previousParentGroup!,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // To show parent of this list add Reset The list
                      if (parentGroup != null && parentGroup != '')
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  parentGroup!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: APPBAR_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 30,
                                  color: APPBAR_COLOR,
                                )
                              ],
                            ),
                          ),
                        ),

                      /// Show List of group
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: parentGroup != null
                              ? const EdgeInsets.only(left: 10)
                              : EdgeInsets.zero,
                          child: state.getItemGroupState == RequestState.error
                              ? const NothingHere()
                              : AnimationLimiter(
                                  child: ListView.builder(
                                    itemCount: state.getItemGroupData.length,
                                    itemBuilder: (context, index) {
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        columnCount: 3,
                                        child: SlideAnimation(
                                          verticalOffset: 100.0,
                                          child: FadeInAnimation(
                                            child: InkWell(
                                              onTap: () {
                                                if (state
                                                        .getItemGroupData[index]
                                                        .isGroup ==
                                                    1) {
                                                  //Reset Group List filtered by item group name ig item group have child
                                                  parentGroup = state
                                                      .getItemGroupData[index]
                                                      .name;
                                                  previousParentGroup = state
                                                      .getItemGroupData[index]
                                                      .parentItemGroup;
                                                  bloc.add(
                                                    GetItemGroupEvent(
                                                      itemFilter: ItemsFilter(
                                                        itemGroup: state
                                                            .getItemGroupData[
                                                                index]
                                                            .name,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  // Go to item screen filtered by Item Group name

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ItemListScreen(
                                                          itemGroup: state
                                                              .getItemGroupData[
                                                                  index]
                                                              .name,
                                                          priceList:
                                                              widget.priceList,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      state
                                                          .getItemGroupData[
                                                              index]
                                                          .name,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    // if item group have child show icon or not show go text
                                                    state.getItemGroupData[index]
                                                                .isGroup ==
                                                            1
                                                        ? const Icon(
                                                            Icons.arrow_right,
                                                            size: 30,
                                                          )
                                                        : const Text(
                                                            'Go',
                                                            style: TextStyle(
                                                              color:
                                                                  APPBAR_COLOR,
                                                              fontSize: 20,
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}