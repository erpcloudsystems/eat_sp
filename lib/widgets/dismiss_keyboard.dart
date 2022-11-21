// The DismissKeybaord widget (it's reusable)
//Used in this Project to Dismiss Keybaord focus
import 'package:flutter/material.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onHorizontalDragCancel: (){
      //   FocusManager.instance.primaryFocus!.unfocus(); // to close KB if scrolled screen
      // },
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}