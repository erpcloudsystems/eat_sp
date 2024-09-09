import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new_version/modules/printer/view/screens/printer_screen.dart';
import 'aboutus_screen.dart';
import '../../core/app_local.dart';
import '../other/app_settings.dart';
import '../../provider/user/user_provider.dart';
import '../../widgets/dialog/loading_dialog.dart';
import '../../new_version/modules/faq/presentation/pages/faq_screen.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final menuPages = [
    const AppSettings(),
    const PrinterScreen(),
    const AboutUs(),
    const FAQ(),
    null
  ];

  final menuIcons = [
    Icons.settings,
    Icons.print_outlined,
    Icons.info,
    Icons.question_answer,
    Icons.logout,
  ];

  void logout(BuildContext context) async {
    final res =
        await checkDialog(context, 'Are you sure do you want to logout ?'.tr());
    if (res == true) context.read<UserProvider>().logout();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.locale.languageCode == 'en') {
      AppLocal.isEnglish = true;
    } else {
      AppLocal.isEnglish = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> menuNames = [
      'App Settings'.tr(),
      StringsManager.printerSettings.tr(),
      'About Us'.tr(),
      'FAQ'.tr(),
      'Logout'.tr()
    ];
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 240,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 10),
              itemCount: menuNames.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 0,
                color: Colors.grey,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    menuNames[index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  trailing: Icon(menuIcons[index]),
                  onTap: () async {
                    if (menuNames[index] == 'Logout'.tr()) {
                      logout(context);
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => menuPages[index]!));
                  },
                );
              },
            ),
          ),
          const Divider(
            height: 0,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListTile(
                  title: const Text(
                    'English',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: AppLocal.isEnglish,
                    onChanged: (bool? value) {
                      AppLocal.isEnglish = value!;

                      AppLocal.toggleBetweenLocales(context);
                      setState(() {});
                    },
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  title: const Text(
                    'عربي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: AppLocal.isEnglish,
                    onChanged: (bool? value) {
                      AppLocal.isEnglish = value!;
                      AppLocal.toggleBetweenLocales(context);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
