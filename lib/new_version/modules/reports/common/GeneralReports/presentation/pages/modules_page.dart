import 'package:flutter/material.dart';
import '../../../../../../../screen/sub_category_screen.dart';
import '../../../../../../core/resources/routes.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../data/models/module_model.dart';

class ReportModulesPage extends StatelessWidget {
  const ReportModulesPage({super.key});

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
      body: GridView.count(
        padding: const EdgeInsets.only(top: 20, right: 6, left: 6, bottom: 50),
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2, childAspectRatio: 1.1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(modules.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: HomeItem(
              title: '${modules[index].name} Reports',
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
