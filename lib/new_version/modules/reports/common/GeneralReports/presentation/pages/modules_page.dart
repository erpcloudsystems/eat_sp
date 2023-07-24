import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../../../../../../../screen/sub_category_screen.dart';
import '../../../../../../../test/home_item_test.dart';
import '../../../../../../core/resources/routes.dart';
import '../../data/models/module_model.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ModuleModel> modules = [
      const ModuleModel(
          name: StringsManager.selling,
          image: 'https://erpcloud.systems/files/selling.png'),
      const ModuleModel(
          name: StringsManager.stock,
          image: 'https://erpcloud.systems/files/stock.png'),
      const ModuleModel(
          name: StringsManager.buying,
          image: 'https://erpcloud.systems/files/buying.png'),
      const ModuleModel(
          name: StringsManager.accounts,
          image: 'https://erpcloud.systems/files/accounts.png'),
      const ModuleModel(
          name: StringsManager.hr,
          image: 'https://erpcloud.systems/files/hr.png'),
      const ModuleModel(
          name: StringsManager.projects,
          image: 'https://erpcloud.systems/files/accounts.png'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Reports',
          style: TextStyle(
            color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 22
          ),
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
