import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/page/common_page_widgets/comments.dart';
import '../core/constants.dart';
import '../provider/module/module_provider.dart';

class CommentsButton extends StatelessWidget {
  final Color? color;

  const CommentsButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
            padding: EdgeInsets.zero),
        onPressed: () {
          showCommentsSheet(Scaffold.of(context).context);
        },
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
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.message,
                      color: Colors.grey,
                    )),
                const Text(
                  'Comments',
                  style:
                      TextStyle(fontSize: 16, color: Colors.black, height: 1.2),
                ),
                const SizedBox(width: 10),
                Container(
                    alignment: Alignment.topCenter,
                    width: 20,
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    child: Text(
                        '${(context.read<ModuleProvider>().pageData['comments'] as List?)?.length}',
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
