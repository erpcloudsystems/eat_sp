import '../new_version/core/resources/strings_manager.dart';
import '../provider/user/user_provider.dart';
import 'custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../core/constants.dart';
import '../core/showcase_consts.dart';
import '../models/list_models/list_model.dart';
import '../provider/module/module_provider.dart';
import 'package:provider/provider.dart';

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

    final res = await widget.future(pageCount) as ListModel<T>?;

    listCount = await widget.listCount();

    newLoadCount += res?.list.length ?? 0;
    Provider.of<ModuleProvider>(context, listen: false).setLoadCount =
        newLoadCount.toString();

    print(res);
    print(res?.list);

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
    if (widget.reset.value != _oldValue)
      setState(() {
        pageCount = -20;
        newLoadCount = 0;
        _noMoreItems = false;
        items = <T>[];
        _oldValue = widget.reset.value;
        getItems();
      });
  }

  @override
  void initState() {
    super.initState();
//__________________________________________________________________________________________________________________
    // this function starts the new version architecture.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (context.read<ModuleProvider>().currentModule.genericListService ==
    //       ConstantStrings.newVersion) {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: ((context) =>
    //             context.read<ModuleProvider>().currentModule.pageWidget)));
    //   }
    // });
//__________________________________________________________________________________________________________________
    widget.reset.addListener(_reset);
    _scrollController.addListener(loadMore);
    getItems();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(loadMore);
    _scrollController.dispose();
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
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _noMoreItems ? items.length + 1 : items.length,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    itemBuilder: (context, i) {
                      if (i < items.length) return listItem(items[i]);
                      return Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('no more items')));
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      top: 3,
                    ),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                        margin: const EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$newLoadCount of ',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                            //this to avoid Duplicate GlobalKey
                            (!context
                                    .read<UserProvider>()
                                    .showcaseProgress!
                                    .contains('list_tut'))
                                ? Showcase(
                                    key: countGK,
                                    title: 'Count',
                                    titleTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                    description:
                                        'This is the count of your documents',
                                    shapeBorder: CircleBorder(),
                                    radius:
                                        BorderRadius.all(Radius.circular(4)),
                                    overlayPadding: EdgeInsets.only(
                                        left: 40, right: 8, top: 2, bottom: 2),
                                    blurValue: 1,
                                    child: Text(
                                      '$listCount',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5),
                                    ),
                                  )
                                : Text(
                                    '$listCount',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5),
                                  ),
                          ],
                        )),
                  )),
            ),
            if (_isLoading)
              Align(
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

      if (_isLoading)
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomLoadingWithImage(),
          ],
        ));
      return Center(child: Text("No Data"));
    });
  }
}

class SearchBar extends StatefulWidget {
  final Function(String value) search;
  SearchBar({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String searchText = '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: SizedBox(
        height: 47,
        child: Card(
          elevation: 1,
          color: Colors.white,
          child: TextField(
            controller: controller,
            onChanged: (value) {
              if (value.isEmpty && searchText.isNotEmpty) {
                widget.search(value);
                FocusScope.of(context).unfocus();
              }
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              widget.search(controller.text);
            },
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 7, top: 0, right: 15),
                disabledBorder: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    widget.search(controller.text);
                  },
                )),
          ),
        ),
      ),
    );
  }
}
