import '../core/showcase_consts.dart';
import '../provider/module/module_provider.dart';
import '../provider/user/user_provider.dart';
import '../widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../core/constants.dart';

class SortingScreen extends StatefulWidget {
  const SortingScreen({Key? key}) : super(key: key);

  static _SortingScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_SortingScreenState>()!;

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
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
    if (!context
        .read<UserProvider>()
        .showcaseProgress!
        .contains('filter_tut')) {
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
      builder:(context)=> Builder(builder: (context) {
        showCaseContext = context;
        return Scaffold(
          appBar: AppBar(
            title: Text('Sort'.tr()),
            actions: [
              (!context
                      .read<UserProvider>()
                      .showcaseProgress!
                      .contains('filter_tut'))
                  ? CustomShowCase(
                      globalKey: clearFiltersGK,
                      title: 'Clear Sort',
                      description: 'Click here to clear all sorting',
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
              ///-------------------Sorting------------------------
              Expanded(
                child: Group(
                  child: Column(
                    children: [
                      CustomDropDown(
                        'sort_field',
                        'Sorting Field'.tr(),
                        items: SortingFieldList,
                        onChanged: (String value) {
                          values['sort_field'] = value;
                        },
                        onClear: () {
                          values.remove('sort_field');
                        },
                        defaultValue: values['sort_field'],
                        clear: true,
                      ),
                      CustomDropDown(
                        'sort_type',
                        'Sort Type'.tr(),
                        items: SortingType,
                        onChanged: (String value) =>
                            values['sort_type'] = value,
                        onClear: () => values.remove('sort_type'),
                        defaultValue: values['sort_type'],
                        clear: true,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
                                'Apply Sorting',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.5,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Apply Sorting',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.5,
                              ),
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
