import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

import '../core/constants.dart';
import '../new_version/modules/printer/controller/cubit/printer_cubit.dart';
import '../new_version/modules/reports/common/GeneralReports/presentation/pages/modules_page.dart';
import '../service/gps_services.dart';
import 'drawer/drawer_screen.dart';
import 'sub_category_screen.dart';
import '../widgets/new_widgets/home_item_test.dart';
import 'other/notification_screen.dart';
import '../provider/user/user_provider.dart';
import '../widgets/botton_navigation_bar.dart';
import '../service/local_notification_service.dart';
import '../new_version/modules/dashboard/presentation/pages/dashpoard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  int indexNow = 0;

  final GlobalKey _bottomNavigationKey = GlobalKey();

  String release = '';

  @override
  void initState() {
    super.initState();
    notificationConfig(context);
    GPSService.trackUserLocation(context);
    Future.delayed(Duration.zero, () {
      context.read<PrinterCubit>().loadDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final UserProvider userProvider = Provider.of(context, listen: false);

    List<Widget?> pages = [
      const DashboardScreen(),
      const ReportModulesPage(),
      //ModulesPage(userProvider: userProvider),

      const NotificationScreen(),
      const SettingsMenu(),
    ];
    return UpgradeAlert(
      upgrader: Upgrader(),
      child: ColorfulSafeArea(
        color: APPBAR_COLOR,
        child: Scaffold(
          bottomNavigationBar: getBottomNavigationBar(
              key: _bottomNavigationKey,
              index: indexNow,
              onTap: (index) {
                setState(() {
                  _page = index;
                });
              }),
          extendBody: true,
          body: Container(
              padding: const EdgeInsets.only(bottom: 50), child: pages[_page]),
        ),
      ),
    );
  }
}

class ModulesPage extends StatelessWidget {
  const ModulesPage({
    super.key,
    required this.userProvider,
  });

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Modules.Modules'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.only(
          top: 30,
          right: 6,
          left: 6,
          bottom: 50,
        ),
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 8,
        children: List.generate(userProvider.modules.length, (index) {
          return HomeItemTest(
            title: 'Modules.${userProvider.modules[index].keys.first}'.tr(),
            imageUrl: userProvider.modules[index].values.first,
            onPressed: () => Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  SubCategoryScreen(
                userProvider.modules[index].keys.first,
                index,
              ),
            )),
          );
        }),
      ),
    );
  }
}
