import 'package:flutter/material.dart';

const int PAGINATION_PAGE_LENGTH = 20;
const double SEARCH_BAR_HEIGHT = 50;

///*** COLORS ***///
const APPBAR_COLOR = MAIN_COLOR;
const MAIN_COLOR = Colors.green;
const APPBAR_ICONS_COLOR = Colors.white;
const FORM_SUBMIT_BTN_COLOR = Colors.white;
const LOADING_PROGRESS_COLOR = MAIN_COLOR;
const CIRCULAR_PROGRESS_COLOR = MAIN_COLOR;
const CONNECTION_ROUTE = 'CONNECTION_ROUTE';

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
