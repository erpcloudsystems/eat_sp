import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'faq_screen.dart';
import 'aboutus_screen.dart';
import '../other/app_settings.dart';
import '../../provider/user/user_provider.dart';
import '../../widgets/dialog/loading_dialog.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final drawerNames = ['App Setting', 'About Us', 'FAQ', 'Logout'];
  final drawerPages = [const AppSettings(), const AboutUs(), const FAQ(), null];
  final drawerIcons = [
    Icons.settings,
    Icons.info,
    Icons.question_answer,
    Icons.logout
  ];

  void logout(BuildContext context) async {
    final res =
        await checkDialog(context, 'Are you sure do you want to logout ?');
    if (res == true) context.read<UserProvider>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: drawerNames.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 0,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                drawerNames[index],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              trailing: Icon(drawerIcons[index]),
              onTap: () async {
                if (drawerNames[index] == 'Logout') {
                  logout(context);
                  return;
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => drawerPages[index]!));
              },
            );
          },
        ),
      ),
    ));
  }
}
