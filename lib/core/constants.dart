import 'package:flutter/material.dart';

const int PAGINATION_PAGE_LENGTH = 20;
const double SEARCH_BAR_HEIGHT = 50;

///*** COLORS ***///
const APPBAR_COLOR = Color(0xff0099ff);
const APP_MAIN_COLOR = Color(0xff0066ff);
const APPBAR_ICONS_COLOR = Colors.white;
const FORM_SUBMIT_BTN_COLOR = Colors.white;
const LOADING_PROGRESS_COLOR = Color(0xff0066ff);
const CIRCULAR_PROGRESS_COLOR = Color(0xff0066ff);
const CONNECTION_ROUTE = 'CONNECTION_ROUTE';

/// New Const
const NEW_BLUE_COLOR = Color(0xFFE3F2FD);
const ORANGE_COLOR = Color(0xffF78138);

///*** BORDER RADIUS ***///
const GLOBAL_BORDER_RADIUS = 12.0;

///*** BUTTONS ***///
const SUBMIT_BUTTON_COLOR = Colors.green;
const CANCEL_BUTTON_COLOR = Colors.red;
const AMEND_BUTTON_COLOR = Colors.blue;

///*** TEXT ***///
const String KEnableGpsSnackBar =
    'Enable Location To Approve your current location';
const String KPermanentlyDeniedSnackBar =
    'Allow Location Permission form app settings';
const String KLocationGrantedSnackBar = 'Location Granted';
const String KLocationNotifySnackBar =
    'Location will be submitted to approve current location';
const String KFillRequiredSnackBar = 'Fill required fields and submit';

String mapStatus(int status) {
  switch (status) {
    case 0:
      return 'Draft';
    case 1:
      return 'Submitted';
    case 2:
      return 'Cancelled';
    default:
      return '';
  }
}

void bottomSheetBuilder({
  required Widget bottomSheetView,
  required BuildContext context,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: ((context) {
      return bottomSheetView;
    }),
  );
}
