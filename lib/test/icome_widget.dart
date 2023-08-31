import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/module/module_provider.dart';
import '../screen/list/generic_list_screen.dart';

class IncomeWidget extends StatelessWidget {
  const IncomeWidget({
    Key? key,
    required this.title,
    this.count,
    required this.total,
    required this.arrowIcon,
    required this.color,
    this.status,
    this.isCounted = false,
    required this.docType,
    this.filters = const {},
  }) : super(key: key);
  final Map<String, dynamic>? filters;
  final String? status;
  final String docType;
  final String title;
  final String total;
  final String? count;
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
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
                    !isCounted ? 'EGP  ' : 'Count  ',
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
              'The latest $title',
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
