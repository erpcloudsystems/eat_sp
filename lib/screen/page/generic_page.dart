import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page_screen.dart';
import '../../core/constants.dart';
import '../../widgets/nothing_here.dart';
import '../../provider/module/module_provider.dart';

class GenericPage extends StatelessWidget {
  const GenericPage({Key? key}) : super(key: key);

  //TODO: try use bool variable here for is available pdf for

  void editPage(BuildContext context) {
    // notifying the provider to enable edit mood for the next form
    context.read<ModuleProvider>().editThisPage();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            context.read<ModuleProvider>().currentModule.createForm!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            context.watch<ModuleProvider>().currentModule.title,
            style: TextStyle(overflow: TextOverflow.visible, height: 1),
            softWrap: true,
          ),
        ),
        actions: [
          IconButton(
            onPressed: context.read<ModuleProvider>().pageSubmitStatus == 0 &&
                    context.read<ModuleProvider>().currentModule.createForm !=
                        null
                ? () => editPage(context)
                : null,
            splashRadius: 20,
            icon: Icon(
              Icons.edit,
              color: (context.read<ModuleProvider>().pageSubmitStatus == 0)
                  ? Colors.white
                  : Colors.white54,
            ),
          ),
          IconButton(
            onPressed: context.select<ModuleProvider, bool>(
                    (value) => value.availablePdfFormat)
                ? () => context.read<ModuleProvider>().downloadPdf(context)
                : null,
            splashRadius: 20,
            icon: Icon(Icons.download, color: Colors.white),
          ),
          IconButton(
            onPressed: context.select<ModuleProvider, bool>(
                    (value) => value.availablePdfFormat)
                ? () => context.read<ModuleProvider>().printPdf(context)
                : null,
            splashRadius: 20,
            icon: Icon(
              Icons.print_sharp,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () => showAttachments(context),
                splashRadius: 20,
                icon: badges.Badge(
                    badgeContent: Text(
                      '${((context.read<ModuleProvider>().pageData['attachments'] as List?)?.length)}',
                      style: TextStyle(
                          fontSize: 13, color: Colors.white, height: 1.5),
                    ),
                    stackFit: StackFit.passthrough,
                    badgeColor: Colors.redAccent,
                    elevation: 0,
                    showBadge: ((context
                                    .read<ModuleProvider>()
                                    .pageData['attachments'] as List?)
                                ?.length) ==
                            null
                        ? false
                        : ((context
                                        .read<ModuleProvider>()
                                        .pageData['attachments'] as List?)
                                    ?.length) ==
                                0
                            ? false
                            : true,
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                        child: Icon(
                          Icons.attach_file,
                          color: Colors.white,
                        )))),
          ),
        ],
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
