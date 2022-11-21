import 'package:next_app/core/showcase_consts.dart';
import 'package:next_app/models/list_models/list_model.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/filter_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../service/service.dart';
import '../../core/constants.dart';
import '/widgets/pagination.dart';


/// this is a generic paginated list screen,
/// specify which datatype to deal with, this is the data model which used at service model parser
/// if you didn't specify a type it will be [dynamic]
class GenericListScreen<T> extends StatefulWidget {
  /// screen appBar title
  final String? title;

  /// target url where the screen fetch the data from
  final String? service;

  final String? filterById;
  final Map<String, dynamic>? filters;

  final String? connection;

  final Widget? createForm;

  /// how should present the return data from the service?
  /// function takes parameter of the [GenericListScreen] passed type (GenericListScreen<T>)
  /// so it takes item of your specified model, and return a widget to present this data in certain way
  final Widget Function(T)? listItem;

  /// how to parse the service returned data to you specified [ListModel]
  final ListModel<T> Function(Map<String, dynamic>)? serviceParser;

  final bool _useProvider;

  // used to set the data by yourself
  GenericListScreen({
    required this.title,
    required this.service,
    this.filterById,
    this.filters,
    this.connection,
    this.createForm,
    required this.listItem,
    required this.serviceParser,
  }) : _useProvider = false;

  GenericListScreen._({
    this.title,
    this.service,
    this.filterById,
    this.filters,
    this.connection,
    this.createForm,
    this.listItem,
    this.serviceParser,
    bool? useProvider,
  }) : this._useProvider = useProvider ?? false;

  /// used to make [GenericListScreen] method use [ModuleProvider]
  factory GenericListScreen.module() {
    return GenericListScreen._(useProvider: true);
  }

  @override
  createState() => _useProvider ? _GenericListModuleScreenState() : _GenericListScreenState<T>(listItem, serviceParser);
}

/// this state class of [GenericListScreen] is to handle state object based on provider
/// it sends to provider the search text and current page_models and the provider handles the request for the List Screen
class _GenericListModuleScreenState extends State<GenericListScreen> {

  final APIService service = APIService();

  String searchText = '';
  ValueNotifier<bool> reset = ValueNotifier(true);
  bool _isInit = false;

  late ModuleProvider moduleProvider;
  late UserProvider userProvider;

  void _search(value) {
    searchText = value;
    reset.value = !reset.value;
  }


  @override
  void didChangeDependencies() {
    if (!_isInit) moduleProvider = Provider.of<ModuleProvider>(context, listen: false);
     userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
    if(!userProvider.showcaseProgress!.contains('list_tut'))
    Future.delayed(Duration.zero,(){
      ShowCaseWidget.of(context).startShowCase([createGK, filterGK,listSearchGK,countGK]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(moduleProvider.currentModule.title),
        actions: [
          // Text('${Provider.of<ModuleProvider>(context,).loadCount} of '
          //     '${Provider.of<ModuleProvider>(context,).totalListCount}'),
          if (moduleProvider.currentModule.createForm != null)
            CustomShowCase(
              globalKey: createGK,
              title: 'Create',
              description: 'Click here to create new document',
              child: IconButton(
                splashRadius: 20,
                onPressed: () {
                  // notifying the provider to disable page update
                  moduleProvider.iAmCreatingAForm();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => moduleProvider.currentModule.createForm!)).then((value) {
                    // to auto reload List after new create
                     reset.value = !reset.value;
                     //context.read<ModuleProvider>().filter = {'': ''};
                  });
                },
                icon: Icon(Icons.add, color: APPBAR_ICONS_COLOR),
              ),
            ),

          if (moduleProvider.currentModule.filterWidget != null)
            CustomShowCase(
              globalKey: filterGK,
              title: 'Filter',
              description: 'Click here to filter',
              child: IconButton(
                splashRadius: 20,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FilterScreen())),
                icon: Icon(Icons.filter_list_alt, color: APPBAR_ICONS_COLOR),
              ),
            ),

        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(SEARCH_BAR_HEIGHT),
          child: CustomShowCase(
            globalKey: listSearchGK,
            title: 'Search',
            description: 'Click here to Search in your documents',
            overlayPadding: const EdgeInsets.only(top:6),
            child:  Column(
              children: [
                SearchBar(search: _search),
              ],
            ),
          ),
        ),
      ),
      body: Selector<ModuleProvider, Map<String, dynamic>>(
          selector: (_, provider) => provider.filter,
          builder: (context, _, __) {
            reset.value = !reset.value;
            return PaginationList(
              future: (_page) => moduleProvider.listService(page: _page, search: searchText.trim()),
              listCount: ()=> moduleProvider.listCount(search: searchText.trim()),
              reset: reset,
              listItem: moduleProvider.currentModule.listItem,
              search:searchText,
            );
          }),
    );
  }
}

/// this state class of [GenericListScreen] is to handle state object based on GIVEN DATA
/// it depends on given attributes, it make use of them by passing them to list service [service.getList]
class _GenericListScreenState<T> extends State<GenericListScreen> {
  final Widget Function(T)? listItem;
  final ListModel<T> Function(Map<String, dynamic>)? serviceParser;

  _GenericListScreenState(this.listItem, this.serviceParser);

  final APIService service = APIService();

  String searchText = '';
  ValueNotifier<bool> reset = ValueNotifier(false);
  late UserProvider userProvider;

  void _search(value) {
    searchText = value;
    reset.value = !reset.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if(!userProvider.showcaseProgress!.contains('list_tut'))
      Future.delayed(Duration.zero,(){
        ShowCaseWidget.of(context).startShowCase([createGK, filterGK,listSearchGK,countGK]);
      });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title.toString() ),
        actions: [
          if (widget.createForm != null)
            CustomShowCase(
              globalKey: createGK,
              title: 'Create',
              description: 'Click here to create new document',
              child: IconButton(
                splashRadius: 20,
                onPressed: () {
                  // notifying the provider to disable page update
                  context.read<ModuleProvider>().iAmCreatingAForm();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => widget.createForm!));
                },
                icon: Icon(Icons.add, color: APPBAR_ICONS_COLOR),
              ),
            ),
          // SizedBox(width: 8 )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(SEARCH_BAR_HEIGHT),
          child: SearchBar(search: _search),
        ),
      ),
      body: PaginationList<T>(
        future: (_page) =>
            service.getList<T>(widget.service!, _page, serviceParser!, filterById: widget.filterById, connection: widget.connection, search: searchText.trim(),filters: widget.filters),
        listCount:()=>  context.read<ModuleProvider>().listCount(service:widget.service!,search: searchText.trim()),
        reset: reset,
        listItem: listItem!,
        search:searchText,
      ),
    );
  }
}
