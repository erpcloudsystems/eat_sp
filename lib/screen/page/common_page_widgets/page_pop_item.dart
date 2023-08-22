import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../provider/module/module_provider.dart';

class PagePopItem extends StatelessWidget {
  final Function(BuildContext context) sheetFunction;
  final String buttonText, dataKey;
  final IconData buttonIcon;

  const PagePopItem({
    Key? key,
    required this.buttonText,
    required this.dataKey,
    required this.buttonIcon,
    required this.sheetFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List? data =
        (context.read<ModuleProvider>().pageData[dataKey] as List?);
    return InkWell(
      onTap: () => sheetFunction(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            buttonIcon,
            color: Colors.grey,
          ),
          Text(
            buttonText,
            style:
                const TextStyle(fontSize: 16, color: Colors.black, height: 1.2),
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
    );
  }
}
