import 'drawer/drawer_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../provider/module/module_provider.dart';
import '../provider/user/user_provider.dart';
import '../service/service.dart';
import '../widgets/botton_navigation_bar.dart';
import 'list/generic_list_screen.dart';
import 'other/app_settings.dart';
import 'other/notification_screen.dart';
import 'other/user_profile.dart';

class SubCategoryScreen extends StatefulWidget {
  final String title;
  final int moduleIndex;

  SubCategoryScreen(this.title, this.moduleIndex);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  int _page = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // final List<String> list = context.read<UserProvider>().getNames(title);
    final UserProvider userProvider = Provider.of(context, listen: false);
    DateTime _lastExitTime = DateTime.now();

    List<Widget?> pages = [
      AppSettings(),
      UserProfile(),
      GridView.count(
        padding:
            const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),

        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2, childAspectRatio: 1.2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(
            userProvider.modules[widget.moduleIndex]['docs'].keys.length,
            (index) {
          return HomeItem(
            title: userProvider.modules[widget.moduleIndex]['docs'].keys
                .toList()[index],
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
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ShowCaseWidget(
                  onFinish: () {
                    userProvider.setShowcaseProgress('list_tut');
                  },
                  onComplete: (index, key) {
                    userProvider.setShowcaseProgress('list_tut');
                  },
                  builder:
                      Builder(builder: (context) => GenericListScreen.module()),
                ),
              ));
            },
          );
        }),
      ),
      NotificationScreen(),
      CustomDrawer(),
    ];

    List<String> appBarTitles = [
      'Reports',
      'User Profile',
      widget.title,
      'Notification',
      ''
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(appBarTitles[_page]),
        centerTitle: true,
      ),
      bottomNavigationBar: getBottomNavigationBar(
          key: _bottomNavigationKey,
          onTap: (index) {
            if (index == 2 && pages[_page] == pages[2]) {
              Navigator.of(context).pop();
            }
            setState(() {
              _page = index;
            });
          }),
      extendBody: true,
      body: Container(
          padding: EdgeInsets.only(bottom: 50),
          child: pages[
              _page]), // This trailing comma makes auto-formatting nicer for build methods.
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
    Key? key,
  }) : super(key: key);

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
              elevation: 0,
              //shadowColor: Colors.grey.withOpacity(0.5),
              primary: Colors.white,
              onPrimary: Colors.grey.shade200,
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
                      constraints: BoxConstraints(maxWidth: 100),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          imageUrl,
                          headers: APIService().getHeaders,
                          loadingBuilder: (context, child, progress) {
                            return progress != null
                                ? SizedBox(
                                    child: Icon(Icons.image,
                                        color: Colors.grey, size: 60))
                                : child;
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return SizedBox(
                                child: Icon(Icons.image,
                                    color: Colors.grey, size: 60));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Text(title,
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
