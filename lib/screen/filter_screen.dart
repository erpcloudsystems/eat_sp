import '../core/showcase_consts.dart';
import '../provider/module/module_provider.dart';
import '../provider/user/user_provider.dart';
import '../widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../core/constants.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  static _FilterScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_FilterScreenState>()!;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final Map<String, dynamic> values = {};
  late BuildContext showCaseContext;
  late Widget _filter;

  @override
  void initState() {
    _filter = context.read<ModuleProvider>().currentModule.filterWidget!;
    values.addAll(context.read<ModuleProvider>().filter);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!context.read<UserProvider>().showcaseProgress!.contains('filter_tut')) {
      Future.delayed(Duration.zero, () {
        ShowCaseWidget.of(showCaseContext)
            .startShowCase([clearFiltersGK, chooseFiltersGK, applyFiltersGK]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        context.read<UserProvider>().setShowcaseProgress('filter_tut');
      },
      builder: Builder(builder: (context) {
        showCaseContext = context;
        return Scaffold(
          appBar: AppBar(
            title: Text('Filter'.tr()),
            actions: [
              (!context
                      .read<UserProvider>()
                      .showcaseProgress!
                      .contains('filter_tut'))
                  ? CustomShowCase(
                      globalKey: clearFiltersGK,
                      title: 'Clear Filter',
                      description: 'Click here to clear all filters',
                      child: IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          values.clear();
                          context.read<ModuleProvider>().filter = {'': ''};
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                          setState(() {});
                        },
                      ),
                    )
                  : IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: () {
                        values.clear();
                        context.read<ModuleProvider>().filter = {'': ''};
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    super.widget));
                        setState(() {});
                      },
                    ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Group(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: (!context
                            .read<UserProvider>()
                            .showcaseProgress!
                            .contains('filter_tut'))
                        ? CustomShowCase(
                            globalKey: chooseFiltersGK,
                            title: 'Filter by',
                            description: 'Click here to choose your filter',
                            overlayPadding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 10),
                            child: _filter)
                        : _filter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // maximumSize: Size.fromWidth(106),
                    backgroundColor: APPBAR_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        GLOBAL_BORDER_RADIUS,
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<ModuleProvider>().filter = values;
                    Navigator.of(context).pop();
                  },
                  child: (!context
                          .read<UserProvider>()
                          .showcaseProgress!
                          .contains('filter_tut'))
                      ? CustomShowCase(
                          globalKey: applyFiltersGK,
                          title: 'Apply',
                          description: 'Click here to get results',
                          overlayPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Apply Filter',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.5),
                              ),
                            ],
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Apply Filter',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.5),
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
