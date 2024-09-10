import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';
import '../../core/constants.dart';
import '../../service/service.dart';
import '../../widgets/nothing_here.dart';
import '../../widgets/new_widgets/floating_button_widget.dart';
import '../../widgets/generic_page_buttons.dart';
import '../../provider/module/module_provider.dart';
import 'common_page_widgets/page_actions_pop_menu.dart';
import '../../widgets/workflow_widgets/action_widget.dart';

class GenericPage extends StatefulWidget {
  const GenericPage({super.key});

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
          child: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                final provider = context.read<ModuleProvider>();
                // We use this method to navigate back to "List Screen",
                //and only in "Amended Mode".
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
            title: Text(
              context.watch<ModuleProvider>().currentModule.title.tr(),
              style: const TextStyle(
                color: Colors.black,
                overflow: TextOverflow.visible,
                height: 1,
              ),
            ),
            actions: [
              // if we put "const" it will make a bug when entering the page
              // for the first time in editing.
              // ignore: prefer_const_constructors
              EditPageButton(),
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
              const PageActionPopMenu(),
            ],
          ),
        ),
        body: const _GenericPageBody(),
        bottomNavigationBar: const Row(
          children: [
            Flexible(child: DownloadPdfButton()),
            Gutter.medium(),
            Flexible(child: PrintPageButton()),
          ],
        ),
      ),
    );
  }
}

class _GenericPageBody extends StatefulWidget {
  const _GenericPageBody({super.key});

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
