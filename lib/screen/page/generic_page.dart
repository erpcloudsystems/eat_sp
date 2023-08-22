import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new_version/core/resources/strings_manager.dart';
import '../home_screen.dart';
import '../../core/constants.dart';
import '../../service/service.dart';
import '../../widgets/nothing_here.dart';
import '../../test/floating_button_widget.dart';
import '../../widgets/generic_page_buttons.dart';
import '../../provider/module/module_provider.dart';
import '../../widgets/workflow_widgets/action_widget.dart';
import 'common_page_widgets/assigned_to.dart';
import 'common_page_widgets/comments.dart';
import 'common_page_widgets/page_pop_item.dart';
import 'common_page_widgets/shared_with.dart';

class GenericPage extends StatefulWidget {
  const GenericPage({Key? key}) : super(key: key);

  @override
  State<GenericPage> createState() => _GenericPageState();
}

class _GenericPageState extends State<GenericPage> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: APPBAR_COLOR,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  final provider = context.read<ModuleProvider>();
                  // We use this method to navigate back to "List Screen", and only in "Amended Mode".

                  if (provider.isAmended) {
                    provider.pushPage(provider.previousPageId);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const GenericPage(),
                      ),
                    );
                    provider.NotifyAmended = false;
                  }

                  setState(
                      () => context.read<ModuleProvider>().getWorkflow = false);

                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(
                  top: 3,
                  left: 50,
                ),
                child: Text(
                  context.watch<ModuleProvider>().currentModule.title,
                  style: const TextStyle(
                    color: Colors.black,
                    overflow: TextOverflow.visible,
                    height: 1,
                  ),
                ),
              ),
              actions: [
                const EditPageButton(),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeScreen();
                    }));
                  },
                  icon: const Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                ),
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              child: PagePopItem(
                            sheetFunction: showCommentsSheet,
                            buttonText: StringsManager.comments.tr(),
                            dataKey: 'comments',
                            buttonIcon: Icons.message,
                          )),
                          PopupMenuItem(
                              child: PagePopItem(
                            sheetFunction: showAssignedTOSheet,
                            buttonText: StringsManager.assignedTo.tr(),
                            dataKey: 'assignments',
                            buttonIcon: Icons.person,
                          )),
                          PopupMenuItem(
                              child: PagePopItem(
                            sheetFunction: showSharedWithSheet,
                            buttonText: StringsManager.sharedWith.tr(),
                            dataKey: 'shared_with',
                            buttonIcon: Icons.share,
                          )),
                          PopupMenuItem(
                              child: PagePopItem(
                            sheetFunction: showCommentsSheet,
                            buttonText: '${StringsManager.logs.tr()}         ',
                            dataKey: 'comments',
                            buttonIcon: Icons.history,
                          )),
                        ])
              ],
            ),
          ),
        ),
        body: const _GenericPageBody(),
        floatingActionButton: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: ExpandableFab(
            distance: 112,
            children: [
              DownloadPdfButton(),
              PrintPageButton(),
              AttachmentPageButton(),
              DuplicatePageButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenericPageBody extends StatefulWidget {
  const _GenericPageBody({Key? key}) : super(key: key);

  @override
  State<_GenericPageBody> createState() => _GenericPageBodyState();
}

class _GenericPageBodyState extends State<_GenericPageBody> {
  @override
  void initState() {
    super.initState();
    context.read<ModuleProvider>().getWorkflow = false;
    final provider = context.read<ModuleProvider>();
    provider.checkDocTypeWorkflow();
    provider.getActionList();
    provider.getWorkflowStatus();
  }

  @override
  void deactivate() {
    context.read<ModuleProvider>().getWorkflow = false;
    super.deactivate();
  }

  var service = APIService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ModuleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: CIRCULAR_PROGRESS_COLOR,
            ),
          );
        }

        if (provider.pageData.isEmpty) return const NothingHere();

        return RefreshIndicator(
          onRefresh: provider.loadPage,
          child: Column(
            children: [
              if (context.read<ModuleProvider>().getWorkflow)
                const ActionWidget(),
              Expanded(child: provider.currentModule.pageWidget),
            ],
          ),
        );
      },
    );
  }
}
