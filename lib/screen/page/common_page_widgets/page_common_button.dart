import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/app_values.dart';

class PageCommonButton extends StatelessWidget {
  final Color? color;
  final Function(BuildContext context) sheetFunction;
  final String buttonText, dataKey;
  final IconData buttonIcon;

  const PageCommonButton(
      {Key? key,
      this.color,
      required this.sheetFunction,
      required this.buttonText,
      required this.dataKey,
      required this.buttonIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List? data =
        (context.read<ModuleProvider>().pageData[dataKey] as List?);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DoublesManager.d_8, vertical: DoublesManager.d_8),
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
            padding: EdgeInsets.zero),
        onPressed: () => sheetFunction(Scaffold.of(context).context),
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          padding: const EdgeInsets.all(2),
          child: Ink(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
                border: Border.all(color: Colors.transparent)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  buttonIcon,
                  color: Colors.grey,
                ),
                Text(
                  buttonText,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black, height: 1.2),
                ),
                if (data?.length != null && data!.isNotEmpty)
                  Container(
                      alignment: Alignment.center,
                      width: 20,
                      decoration: const BoxDecoration(
                          color: Colors.redAccent, shape: BoxShape.circle),
                      child: Text('${data.length}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white, height: 1.5))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
