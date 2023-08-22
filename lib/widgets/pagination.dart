import 'dart:async';

import 'package:NextApp/service/service.dart';
import 'package:easy_localization/easy_localization.dart';

import '../provider/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'custom_loading.dart';

import '../core/constants.dart';
import 'package:provider/provider.dart';
import '../models/list_models/list_model.dart';
import '../provider/module/module_provider.dart';

class PaginationList<T> extends StatefulWidget {
  final Future<ListModel<T>?> Function(int pageCount) future;
  final Future<String> Function() listCount;
  final ValueNotifier<bool> reset;
  final String search;

  ///dynamic works !, however it should be T !!!!!!!!!!
  final Widget Function(T t) listItem;

  const PaginationList(
      {Key? key,
      required this.future,
      required this.listItem,
      required this.reset,
      required this.search,
      required this.listCount})
      : super(key: key);

  @override
  State<PaginationList> createState() => _PaginationListState<T>(listItem);
}

class _PaginationListState<T> extends State<PaginationList> {
  APIService service = APIService();
  final Widget Function(T t) listItem;
  final ScrollController _scrollController = ScrollController();
  List<T> items = <T>[];

  int pageCount = -20;
  int newLoadCount = 0;
  String listCount = '';
  bool _isLoading = false;
  bool _noMoreItems = false;

  _PaginationListState(this.listItem);

  Future<void> getItems() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    pageCount += PAGINATION_PAGE_LENGTH;

    listCount = await widget.listCount();

    final res = await widget.future(pageCount) as ListModel<T>?;

    newLoadCount += res?.list.length ?? 0;
    Provider.of<ModuleProvider>(context, listen: false).setLoadCount =
        newLoadCount.toString();

    if (res != null) {
      if (res.list.isEmpty || res.list.length < PAGINATION_PAGE_LENGTH) {
        _noMoreItems = true;
      }
      items.addAll(res.list);
    }

    setState(() => _isLoading = false);
  }

  void loadMore() {
    if (_noMoreItems) return;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 600 &&
        !_isLoading) {
      getItems();
    }
  }

  bool _oldValue = false;

  void _reset() {
    if (widget.reset.value != _oldValue) {
      setState(() {
        pageCount = -20;
        newLoadCount = 0;
        _noMoreItems = false;
        items = <T>[];
        _oldValue = widget.reset.value;
        getItems();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _reset();
    // widget.reset.addListener(_reset);
    _scrollController.addListener(loadMore);
    getItems();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(loadMore);
    _scrollController.dispose();
    items.clear();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, snapshot) {
      if (items.isNotEmpty) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              top: 27,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      pageCount = -PAGINATION_PAGE_LENGTH;
                      newLoadCount -= newLoadCount;
                      _noMoreItems = false;
                      items = <T>[];
                      getItems();
                    });
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _noMoreItems ? items.length + 1 : items.length,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    itemBuilder: (context, i) {
                      if (i < items.length) return listItem(items[i]);
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'no more items',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      top: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$newLoadCount ${'of'.tr()} ',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                        //this to avoid Duplicate GlobalKey
                        (!context
                                .read<UserProvider>()
                                .showcaseProgress!
                                .contains('list_tut'))
                            ? Text(
                                listCount,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              )
                            : Text(
                                listCount,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                      ],
                    ),
                  )),
            ),
            if (_isLoading)
              const Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 5,
                  child: LinearProgressIndicator(
                    color: LOADING_PROGRESS_COLOR,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
          ],
        );
      }

      if (_isLoading) {
        return const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomLoadingWithImage(),
          ],
        ));
      }
      return Center(
        child: Text("No Data".tr()),
      );
    });
  }
}

class SearchBar extends StatefulWidget {
  final Function(String value) search;

  const SearchBar({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController controller = TextEditingController();
  Timer? debounceTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: SizedBox(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 0.5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              // Clear the previous debounce timer
              debounceTimer?.cancel();

              // Set a new debounce timer
              debounceTimer = Timer(const Duration(milliseconds: 1000), () {
                setState(() {
                  widget.search(value);
                });
              });
            },
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              hintText: "Search".tr(),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 7,
                top: 0,
                right: 15,
              ),
              disabledBorder: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  widget.search(controller.text);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
