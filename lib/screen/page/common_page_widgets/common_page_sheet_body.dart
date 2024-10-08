import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'common_utils.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/app_values.dart';
import '../../../new_version/core/resources/strings_manager.dart';

class CommonPageSheetBody extends StatelessWidget {
  final String databaseKey, appBarHeader;
  final bool isThereBottomWidget;
  final Widget? bottomWidget;
  final BuildContext scaffoldContext;
  final Widget Function(BuildContext context, int index) bubbleWidgetFun;

  const CommonPageSheetBody({
    Key? key,
    required this.scaffoldContext,
    required this.databaseKey,
    required this.appBarHeader,
    required this.bubbleWidgetFun,
    this.isThereBottomWidget = false,
    this.bottomWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(scaffoldContext).padding.top + 100,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(CommonPageUtils.bottomSheetBorderRadius)),
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: DoublesManager.d_50,
                color: Colors.grey.shade200, //APPBAR_COLOR,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    //_____________________ Navigation back Button______________________
                    Padding(
                      padding: const EdgeInsets.only(left: DoublesManager.d_16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black87,
                                size: 25,
                              ))),
                    ),
                    //___________________________ Header text______________________________________
                    Text(
                        "${(context.read<ModuleProvider>().pageData[databaseKey] as List?)?.length ?? 0} $appBarHeader",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: DoublesManager.d_15,
                        ))
                  ],
                ),
              ),
              //___________________________ Header text______________________________________
              Expanded(
                child: ColoredBox(
                  color: Colors.transparent, //APPBAR_COLOR,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              CommonPageUtils.bottomSheetBorderRadius),
                          child: ((context
                                          .read<ModuleProvider>()
                                          .pageData[databaseKey] as List?) ??
                                      [])
                                  .isEmpty
                              ? Center(
                                  child: Text(StringsManager.noData.tr(),
                                      style:
                                          const TextStyle(color: Colors.grey)))
                              : ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 0),
                                  itemCount: (context
                                              .read<ModuleProvider>()
                                              .pageData[databaseKey] as List?)
                                          ?.length ??
                                      0,
                                  itemBuilder: bubbleWidgetFun),
                        ),
                        if (isThereBottomWidget) bottomWidget!,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
