import 'package:NextApp/models/list_models/permmision_model.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../sorting_screen.dart';
import '../../core/cloud_system_widgets.dart';
import '../../models/list_models/statistics_model.dart';
import '../../widgets/new_widgets/statisics_widget.dart';
import '../home_screen.dart';
import '/widgets/pagination.dart' as pagination;
import '../../core/constants.dart';
import '../../models/list_models/list_model.dart';
import '../../provider/module/module_provider.dart';
import '../../provider/user/user_provider.dart';
import '../../service/service.dart';
import '../filter_screen.dart';

/// this is a generic paginated list screen,
/// specify which datatype to deal with, this is the data model which used at service model parser
/// if you didn't specify a type it will be [dynamic]
class GenericListScreen<T> extends StatefulWidget {
  /// screen appBar title
  final String? title;

  /// target url where the screen fetch the data from
  final String? service;

  final String? customServiceURL;

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
  final bool disableAppBar;

  // used to set the data by yourself
  const GenericListScreen({
    super.key,
    required this.title,
    required this.service,
    this.customServiceURL,
    this.filterById,
    this.filters,
    this.connection,
    this.createForm,
    this.disableAppBar = false,
    required this.listItem,
    required this.serviceParser,
  }) : _useProvider = false;

  const GenericListScreen._({
    this.title,
    this.service,
    this.customServiceURL,
    this.filterById,
    this.filters,
    this.connection,
    this.createForm,
    this.disableAppBar = false,
    this.listItem,
    this.serviceParser,
    bool? useProvider,
  }) : _useProvider = useProvider ?? false;

  /// used to make [GenericListScreen] method use [ModuleProvider]
  factory GenericListScreen.module() {
    return const GenericListScreen._(useProvider: true);
  }

  @override
  createState() => _useProvider
      ? _GenericListModuleScreenState()
      : _GenericListScreenState<T>(listItem, serviceParser);
}

/// this state class of [GenericListScreen] is to handle state object based on provider
/// it sends to provider the search text and current page_models and the provider handles the request for the List Screen
class _GenericListModuleScreenState extends State<GenericListScreen> {
  final APIService service = APIService();
  PermissionModel permissionModel =
      PermissionModel(docType: '', permission: true);

  String searchText = '';
  ValueNotifier<bool> reset = ValueNotifier(true);
  final bool _isInit = false;

  late ModuleProvider moduleProvider;
  late UserProvider userProvider;

  void _search(value) {
    searchText = value;
    reset.value = !reset.value;
  }

  //Statistics
  List<StatisticsModel> statistics = [];

  Future<void> getStatistics() async {
    statistics = (await service.getStatisticsList(
      docType: context.read<ModuleProvider>().currentModule.title,
    ))!;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    context.read<ModuleProvider>().filter.addAll({
      'sort_field': 'modified',
      'sort_type': 'desc',
    });
    if (!_isInit) {
      moduleProvider = Provider.of<ModuleProvider>(context, listen: false);
    }
    userProvider = Provider.of<UserProvider>(context, listen: false);

    getStatistics();
    for (var permission in userProvider.permissionList) {
      if (permission.docType == moduleProvider.currentModule.title) {
        permissionModel = permission;
        break;
      }
    }
    // TODO:
    // permissionModel = userProvider.permissionList.firstWhere((model) =>
    //     model.docType == moduleProvider.currentModule.genericListService);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: APPBAR_COLOR,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: widget.disableAppBar
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                titleTextStyle:
                    const TextStyle(color: Colors.black, fontSize: 18),
                title: Text(
                  widget.title != null
                      ? widget.title!.tr()
                      : moduleProvider.currentModule.title.tr(),
                ),
                actions: [
                  IconButton(
                    splashRadius: 20,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SortingScreen(),
                      ),
                    ),
                    icon: const Icon(
                      Icons.sort,
                      color: Colors.black,
                    ),
                  ),
                  if (moduleProvider.currentModule.filterWidget != null)
                    IconButton(
                      splashRadius: 20,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FilterScreen(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.filter_list_alt,
                        color: Colors.black,
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const HomeScreen();
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.home_outlined,
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(SEARCH_BAR_HEIGHT),
                  child: Column(
                    children: [
                      pagination.SearchBar(search: _search),
                    ],
                  ),
                ),
              ),
        body: Column(
          children: [
            if (statistics.isNotEmpty)
              SizedBox(
                height: 98,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: statistics.length,
                  itemBuilder: (context, index) {
                    return StatisticsWidget(
                      text: statistics[index].title!,
                      color: statusColor(statistics[index].title!),
                      number: statistics[index].count.toString(),
                    );
                  },
                ),
              ),
            Expanded(
              flex: 4,
              child: Selector<ModuleProvider, Map<String, dynamic>>(
                selector: (_, provider) => provider.filter,
                builder: (context, _, __) {
                  reset.value = !reset.value;
                  return pagination.PaginationList(
                    future: (page) => moduleProvider.listService(
                        page: page, search: searchText.trim()),
                    listCount: () => moduleProvider.listCount(
                      search: searchText.trim(),
                    ),
                    reset: reset,
                    listItem: moduleProvider.currentModule.listItem,
                    search: searchText,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: permissionModel.permission
            ? InkWell(
                onTap: () {
                  // Notifying the provider to disable page update
                  moduleProvider.iAmCreatingAForm();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          moduleProvider.currentModule.createForm!,
                    ),
                  ).then((value) {
                    // to auto reload List after new create
                    reset.value = !reset.value;
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: APPBAR_COLOR,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : null,
      ),
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
  ValueNotifier<bool> reset = ValueNotifier(true);
  late UserProvider userProvider;

  void _search(value) {
    searchText = value;
    reset.value = !reset.value;
  }

  @override
  Widget build(BuildContext context) {
    final moduleProvider = Provider.of<ModuleProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.disableAppBar
          ? null
          : AppBar(
              elevation: 0,
              title: Text(
                widget.title != null
                    ? widget.title!.tr()
                    : moduleProvider.currentModule.title.tr(),
              ),
              actions: [
                if (widget.createForm != null)
                  IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      // notifying the provider to disable page update
                      context.read<ModuleProvider>().iAmCreatingAForm();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.createForm!));
                    },
                    icon: const Icon(Icons.add, color: APPBAR_ICONS_COLOR),
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(SEARCH_BAR_HEIGHT),
                child: pagination.SearchBar(search: _search),
              ),
            ),
      body: pagination.PaginationList<T>(
        future: (page) => service.getList<T>(
          widget.service!,
          page,
          serviceParser!,
          customServiceURL: widget.customServiceURL,
          filterById: widget.filterById,
          connection: widget.connection,
          search: searchText.trim(),
          filters: widget.filters,
        ),
        listCount: () => context
            .read<ModuleProvider>()
            .listCount(service: widget.service!, search: searchText.trim()),
        reset: reset,
        listItem: listItem!,
        search: searchText,
      ),
    );
  }
}
