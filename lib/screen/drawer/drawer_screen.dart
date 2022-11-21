import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/drawer/aboutus_screen.dart';
import 'package:next_app/screen/drawer/faq_screen.dart';
import 'package:next_app/screen/other/app_settings.dart';
import 'package:next_app/screen/other/login_screen.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  final drawerNames = ['App Setting', 'About Us', 'FAQ','Logout'];
  final drawerPages = [AppSettings(), AboutUs(), FAQ(),null];
  final drawerIcons = [Icons.settings,Icons.info,Icons.question_answer,Icons.logout];

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
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 10),
          itemCount: drawerNames.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 0,
            color: Colors.grey,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(drawerNames[index],
               // textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              trailing: Icon(drawerIcons[index]),
              onTap: () async{
                if(drawerNames[index] == 'Logout'){
                    logout(context);
                    // Navigator.push(context,MaterialPageRoute(builder: (c)=>LoginScreen()));


                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (c)=>drawerPages[index]!));
              },
            );
          },
        ),
      ),
    ));
  }
}

