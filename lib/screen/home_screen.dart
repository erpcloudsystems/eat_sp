import 'package:next_app/screen/Drawer/drawer_screen.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../provider/user/user_provider.dart';
import '../service/service.dart';
import '../widgets/botton_navigation_bar.dart';
import '../widgets/dialog/awsom_dialogs.dart';
import 'other/app_settings.dart';
import 'other/notification_screen.dart';
import 'other/user_profile.dart';
import 'sub_category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 2;
  int indexNow = 2;

  GlobalKey _bottomNavigationKey = GlobalKey();
  final _one = GlobalKey();
  final _two = GlobalKey();



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of(context, listen: false);

    List<Widget?> pages = [
      AppSettings(),
      UserProfile(),
      GridView.count(
        padding: const EdgeInsets.only(top: 20, right: 6, left: 6, bottom: 50),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2, childAspectRatio: 1.1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(userProvider.modules.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: HomeItem(
              title: userProvider.modules[index].keys.first,
              imageUrl: userProvider.modules[index].values.first,
              onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    SubCategoryScreen(
                        userProvider.modules[index].keys.first, index),
              )),
            ),
          );
        }),
      ),
      NotificationScreen(),
      CustomDrawer(),
    ];

    void logout() async {
      final res =
          await checkDialog(context, 'Are you sure do you want to logout ?');
      if (res == true) userProvider.logout();
    }

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Home"),
        centerTitle: true,
        elevation: 1,
        // actions: [
        //   IconButton(onPressed: (){
        //     ShowCaseWidget.of(context).startShowCase([_one, _two,]);
        //   }, icon:Icon(
        //       Icons.help
        //   ))
        // ],
        ///// for logout from home
        // leading: _page == 2
        //     ? IconButton(
        //       onPressed: logout,
        //       icon: Icon(Icons.logout),
        //       splashRadius: 24,
        //     )
        //     : null,
      ),
      /* drawer: Drawer(child: Container(color: Colors.red,)),*/
      bottomNavigationBar: getBottomNavigationBar(
          key: _bottomNavigationKey,
          index:indexNow,
          onTap: (index) {
            // if (index == 4) {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => CustomDrawer())).then((value) => setState(() {
            //     _page = 2;
            //   }));
            // }
            setState(() {
              _page = index;
            });
          }),
      extendBody: true,
      body: Container(
          padding: EdgeInsets.only(bottom: 50), child: pages[_page]),
    );
  }
}
