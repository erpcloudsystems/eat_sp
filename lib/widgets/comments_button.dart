import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import '../provider/module/module_provider.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import 'comments.dart';

class CommentsButton extends StatelessWidget {
  final Color? color;

  const CommentsButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
      child: TextButton(
        style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)), padding: EdgeInsets.zero),
        onPressed: () {
          showCommentsSheet(Scaffold.of(context).context);
        },
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          padding: const EdgeInsets.all(2),
          child: Ink(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS), border: Border.all(color:  Colors.transparent)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.message, color: Colors.grey,)),
                Text(
                  'Comments',
                  style: const TextStyle(fontSize: 16, color: Colors.black,height: 1.2),
                ),
            SizedBox(width: 10),
            Container(
              alignment: Alignment.topCenter,
              width: 20,
                decoration: BoxDecoration(
                    color:Colors.redAccent,
                    shape: BoxShape.circle
                ),
                child: Text('${(context
                    .read<ModuleProvider>()
                    .pageData['comments'] as List?)
                    ?.length}',style: TextStyle(fontSize: 14,color: Colors.white,height: 1.5))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

