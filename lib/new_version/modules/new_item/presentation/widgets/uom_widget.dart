import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants.dart';
import '../../../../../provider/module/module_provider.dart';

class UomWidget extends StatefulWidget {
  UomWidget({super.key, required this.itemCode, this.uom});
  final String itemCode;
  String? uom;
  @override
  State<UomWidget> createState() => _UomWidgetState();
}

class _UomWidgetState extends State<UomWidget> {
  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    provider.getUOM(itemCode: widget.itemCode);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModuleProvider>(builder: (context, provider, child) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.workflowStatus ?? 'none'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 25.w,
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  if (provider.getUOMList.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        insetPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.1,
                        ),
                        content: SizedBox(
                          height: provider.getUOMList.length > 2 ? 100 : 60,
                          width: 20,
                          child: ListView.builder(
                            itemCount: provider.getUOMList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    widget.uom =
                                        provider.getUOMList[index];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: Text(
                                      provider.getUOMList[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: APPBAR_COLOR,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.uom!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
