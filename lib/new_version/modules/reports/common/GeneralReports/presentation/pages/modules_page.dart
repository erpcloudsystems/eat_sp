import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../widgets/new_widgets/home_item_test.dart';
import '../../../../../../core/resources/routes.dart';
import '../../data/models/module_model.dart';

class ReportsModulePage extends StatelessWidget {
  const ReportsModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ModuleModel> modules = [
      const ModuleModel(
          name: StringsManager.stock,
          image: 'https://erpcloud.systems/files/stock.png'),
      const ModuleModel(
          name: StringsManager.accounts,
          image: 'https://erpcloud.systems/files/accounts.png'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Reports'.tr(),
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.only(top: 30, right: 6, left: 6, bottom: 50),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2, childAspectRatio: 1.1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(modules.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: HomeItemTest(
              title: 'Modules.${modules[index].name}'.tr(),
              imageUrl: modules[index].image,
              onPressed: () => Navigator.of(context).pushNamed(
                  Routes.reportsScreen,
                  arguments: modules[index].name),
            ),
          );
        }),
      ),
    );
  }
}
