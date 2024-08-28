import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new_version/core/resources/strings_manager.dart';
import '../../provider/module/module_provider.dart';
import '../../screen/list/generic_list_screen.dart';

class IncomeWidget extends StatelessWidget {
  const IncomeWidget({
    super.key,
    required this.title,
    this.count,
    this.total,
    required this.arrowIcon,
    required this.color,
    this.status,
    this.isCounted = false,
    required this.docType,
    this.filters = const {},
  });
  final Map<String, dynamic>? filters;
  final String? status;
  final String docType;
  final String title;
  final String? total;
  final int? count;
  final bool isCounted;
  final IconData arrowIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModuleProvider>(context);
    return InkWell(
      onTap: () {
        /// Set Module
        provider.setModule = docType;

        /// Apply filter
        if (filters != null) {
          provider.filter.addAll(filters!);
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return GenericListScreen.module();
            },
          ),
        ).whenComplete(() => provider.filter.clear());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (count != null)
                    Text(
                      '$count ',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                ],
              ),
              FittedBox(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      !isCounted ? '${StringsManager.sar}  ' : tr('Count  '),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      margin: const EdgeInsets.only(left: 5, bottom: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[100],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$total ',
                            style: TextStyle(color: color, fontSize: 18),
                          ),
                          Icon(
                            arrowIcon,
                            size: 18,
                            color: color,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${tr(StringsManager.theLatest)} $title',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
