import '../../models/list_models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../service/service.dart';
import '../../provider/module/module_provider.dart';
import '/widgets/pagination.dart';

/// FOR CUSTOM LIST API ONLY
/// this is a generic paginated list screen,
/// specify which datatype to deal with, this is the data model which used at service model parser
/// if you didn't specify a type it will be [dynamic]
class CustomListScreen<T> extends StatefulWidget {
  /// screen appBar title
  final String title;

  /// target url where the screen fetch the data from
  final String service;

  /// how should present the return data from the service?
  /// function takes parameter of the [CustomListScreen] passed type (GenericListScreen<T>)
  /// so it takes item of your specified model, and return a widget to present this data in certain way
  final Widget Function(T) listItem;

  /// how to parse the service returned data to you specified [ListModel]
  final ListModel<T> Function(Map<String, dynamic>) serviceParser;

  /// scaffold background color
  final Color? backgroundColor;

  CustomListScreen(
      {required this.title,
      required this.service,
      required this.listItem,
      required this.serviceParser,
      this.backgroundColor});

  @override
  _CustomListScreenState createState() =>
      _CustomListScreenState<T>(listItem, serviceParser);
}

class _CustomListScreenState<T> extends State<CustomListScreen> {
  final Widget Function(T) listItem;
  final ListModel<T> Function(Map<String, dynamic>) serviceParser;

  _CustomListScreenState(this.listItem, this.serviceParser);

  final APIService service = APIService();

  String searchText = '';
  ValueNotifier<bool> reset = ValueNotifier(false);

  void _search(value) {
    setState(() {
      searchText = value;
    });
    reset.value = !reset.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(SEARCH_BAR_HEIGHT),
          child: SearchBar(search: _search),
        ),
      ),
      body: PaginationList<T>(
        future: (_page) => service.getCustomList<T>(
            widget.service, _page, serviceParser,
            search: searchText),
        listCount: () =>
            context.read<ModuleProvider>().listCount(search: searchText.trim()),
        reset: reset,
        listItem: listItem,
        search: searchText,
      ),
    );
  }
}
