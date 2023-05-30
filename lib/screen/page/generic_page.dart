import 'package:NextApp/service/service.dart';
import 'package:NextApp/widgets/snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../core/constants.dart';
import '../../service/service_constants.dart';
import '../../widgets/form_widgets.dart';
import '../../widgets/nothing_here.dart';
import '../../provider/module/module_provider.dart';
import '../../widgets/generic_page_buttons.dart';
import '../../widgets/workflow_widgets/action_widget.dart';

class GenericPage extends StatelessWidget {
  const GenericPage({Key? key}) : super(key: key);

  //TODO: try use bool variable here for is available pdf for

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AppBar(
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
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(
                top: 3,
              ),
              child: Text(
                context.watch<ModuleProvider>().currentModule.title,
                style: const TextStyle(
                  overflow: TextOverflow.visible,
                  height: 1,
                ),
              ),
            ),
            actions: const [
              GenericPageButtons(),
            ],
          ),
        ),
      ),
      body: const _GenericPageBody(),
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

    final provider = context.read<ModuleProvider>();
    provider.checkDocTypeWorkflow();
    provider.getActionList();
    provider.getWorkflowStatus();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
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
              Expanded(
                child: provider.currentModule.pageWidget,
              ),
            ],
          ),
        );
      },
    );
  }
}
