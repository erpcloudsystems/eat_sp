import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/app_values.dart';

class PagePopItem extends StatelessWidget {
  final Function(BuildContext context) sheetFunction;
  final String buttonText, dataKey;
  final IconData buttonIcon;

  const PagePopItem({
    super.key,
    required this.buttonText,
    required this.dataKey,
    required this.buttonIcon,
    required this.sheetFunction,
  });

  @override
  Widget build(BuildContext context) {
    final List? data =
        (context.read<ModuleProvider>().pageData[dataKey] as List?);
    return InkWell(
      onTap: () => sheetFunction(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Icon(buttonIcon, color: Colors.grey),

          // Title
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 2.5),
              child: Text(
                buttonText,
                style: const TextStyle(
                    fontSize: 16, color: Colors.black, height: 1.2),
              ),
            ),
          ),

          // count
          if (data?.length != null && data!.isNotEmpty)
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(DoublesManager.d_2),
                width: DoublesManager.d_20,
                height: DoublesManager.d_20,
                decoration: const BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('${data.length}',
                      style: const TextStyle(color: Colors.white)),
                )),

          // If there is no items, this is an empty place holder, to maintain the alignment.
          if (data?.length == null || data!.isEmpty)
            const SizedBox.square(dimension: DoublesManager.d_20),
        ],
      ),
    );
  }
}
