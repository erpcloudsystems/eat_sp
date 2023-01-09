import 'package:next_app/core/constants.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context, String message) => showDialog(
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.4),
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(12),
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: const TextStyle(fontSize: 17)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LinearProgressIndicator(
                    color: LOADING_PROGRESS_COLOR,
                    backgroundColor: Colors.transparent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

Future<dynamic> checkDialog ([
  context,
  String message = '',
  String title = '',
])  =>  CoolAlert.show(
  context: context,
  type: CoolAlertType.custom,
  barrierDismissible: true,
  showCancelBtn: true,
  confirmBtnText: 'Yes',
  cancelBtnText: 'No',
  title: (title != '') ? title: null,
  widget: Text(message,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
  borderRadius: GLOBAL_BORDER_RADIUS,
  backgroundColor: Colors.white,
  confirmBtnColor: Colors.white,
  // okBtnElevation:0,
  // okBtnhighlightElevation:0,
  confirmBtnTextStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600,fontSize: 18.0),
  lottieAsset: 'assets/lottie/warning.json',
  loopAnimation: false,
  // contentOfTextAndButtonsPadding: EdgeInsets.fromLTRB(15,0,15,10),
  // contentOflottiePadding: EdgeInsets.fromLTRB(0,5,0,0),
  onConfirmBtnTap: () {
    return Navigator.pop(context, true);
  },
  onCancelBtnTap: () {
    return Navigator.pop(context, false);
  },
);
//
// Future<bool?> checkDialogOld(context, String message) => showDialog(
//     context: context,
//     builder: (BuildContext context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
//           backgroundColor: Colors.white,
//           insetPadding: const EdgeInsets.all(12),
//           content: Text(message,textAlign: TextAlign.center,),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: TextButton(
//                       style: TextButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.8)),
//                       child: Text('Cancel', style: const TextStyle(color: Colors.black, fontSize: 15)),
//                       onPressed: () => Navigator.pop(context,false)),
//                 ),
//                 Flexible(child: SizedBox()),
//                 Expanded(
//                   child: TextButton(
//                       style: TextButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.8)),
//                       child: Text('Yes', style: const TextStyle(color: Colors.black, fontSize: 15)),
//                       onPressed: () => Navigator.pop(context, true)),
//                 ),
//               ],
//             ),
//           ],
//         ));
