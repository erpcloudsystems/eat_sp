import 'package:NextApp/core/constants.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';

import '../new_version/modules/dashboard/presentation/pages/dashpoard_screen.dart';
import '../widgets/new_widgets/home_item_test.dart';
import 'drawer/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '../service/service.dart';
import 'other/app_settings.dart';
import 'list/generic_list_screen.dart';
import 'other/notification_screen.dart';
import '../provider/user/user_provider.dart';
import '../provider/module/module_provider.dart';

class SubCategoryScreen extends StatefulWidget {
  final String title;
  final int moduleIndex;

  const SubCategoryScreen(this.title, this.moduleIndex, {super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final int _page = 1;

  @override
  Widget build(BuildContext context) {
    // final List<String> list = context.read<UserProvider>().getNames(title);
    final UserProvider userProvider = Provider.of(context, listen: false);

    List<Widget?> pages = [
      const AppSettings(),
      GridView.count(
        padding: const EdgeInsets.only(
          top: 30,
          right: 10,
          left: 10,
          bottom: 10,
        ),
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(
            userProvider.modules[widget.moduleIndex]['docs'].keys.length,
            (index) {
          return HomeItemTest(
            title:
                'DocType.${userProvider.modules[widget.moduleIndex]['docs'].keys.toList()[index]}'
                    .tr(),
            imageUrl: userProvider.modules[widget.moduleIndex]['docs'].values
                .toList()[index],
            onPressed: () {
              final String module = userProvider
                  .modules[widget.moduleIndex]['docs'].keys
                  .toList()[index];
              context.read<ModuleProvider>().setModule = module;
              if (context.read<ModuleProvider>().currentModule.title !=
                  module) {
                // no implementation supports this module
                return;
              }
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ShowCaseWidget(
                    onFinish: () {
                      userProvider.setShowcaseProgress('list_tut');
                    },
                    onComplete: (index, key) {
                      userProvider.setShowcaseProgress('list_tut');
                    },
                    builder: (ctx) => Builder(
                        builder: (context) => GenericListScreen.module()),
                  ),
                ),
              );
            },
          );
        }),
      ),
      const DashboardScreen(),
      const NotificationScreen(),
      const SettingsMenu(),
    ];

    List<String> appBarTitles = [
      'Reports',
      widget.title,
      'User Profile',
      'Notification',
      ''
    ];

    return ColorfulSafeArea(
      color: APPBAR_COLOR,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'Modules.${appBarTitles[_page]}'.tr(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),

        extendBody: true,
        body: Container(child: pages[_page]),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class HomeItem extends StatelessWidget {
  final String imageUrl, title;
  final VoidCallback onPressed;

  const HomeItem({
    required this.title,
    required this.imageUrl,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey.shade200,
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          imageUrl,
                          headers: APIService().getHeaders,
                          loadingBuilder: (context, child, progress) {
                            return progress != null
                                ? const SizedBox(
                                    child: Icon(Icons.image,
                                        color: Colors.grey, size: 60))
                                : child;
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const SizedBox(
                                child: Icon(Icons.image,
                                    color: Colors.grey, size: 60));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text(title.tr(),
                    style: const TextStyle(
                        fontSize: 15.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
