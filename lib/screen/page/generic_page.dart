import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../widgets/nothing_here.dart';
import '../../provider/module/module_provider.dart';
import '../../widgets/generic_page_buttons.dart';

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
                        MaterialPageRoute(builder: (_) => GenericPage()));
                    provider.NotifyAmended = false;
                  }
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_new)),
            title: Padding(
              padding: const EdgeInsets.only(
                top: 3,
              ),
              child: Text(
                context.watch<ModuleProvider>().currentModule.title,
                style: TextStyle(
                  overflow: TextOverflow.visible,
                  height: 1,
                ),
              ),
            ),
            actions: [
              GenericPageButtons(),
            ],
          ),
        ),
      ),
      body: _GenericPageBody(),
    );
  }
}

class _GenericPageBody extends StatelessWidget {
  const _GenericPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ModuleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading)
          return Center(
              child: CircularProgressIndicator(
            color: CIRCULAR_PROGRESS_COLOR,
          ));

        if (provider.pageData.isEmpty) return NothingHere();

        return RefreshIndicator(
            child: provider.currentModule.pageWidget,
            onRefresh: provider.loadPage);
      },
    );
  }
}
