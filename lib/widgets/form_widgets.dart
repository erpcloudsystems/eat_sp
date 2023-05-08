import 'dart:io';

import 'list_card.dart';
import 'snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

const int KMaxLines = 5;

const List<String> orderTypeList = ['Sales', 'Maintenance', 'Shopping Cart'];
const List<String> requestTypeList = [
  'Product Enquiry',
  'Request for Information',
  'Suggestions',
  'Other'
];
const List<String> addressTypeList = [
  'Billing',
  'Shipping',
  'Office',
  'Personal',
  'Plant',
  'Postal',
  'Shop',
  'Subsidiary',
  'Warehouse',
  'Current',
  'Permanent',
  'Other',
];
const List<String> linkDocumentTypeList = ['Customer', 'Supplier'];

const List<String> LeadStatusList = [
  'Lead',
  'Open',
  'Replied',
  'Opportunity',
  'Quotation',
  'Lost Quotation',
  'Interested',
  'Converted',
  'Do Not Contact',
];

const List<String> TaskStatusList = [
  'Open',
  'Working',
  'Pending Review',
  'Overdue',
  'Template',
  'Completed',
  'Cancelled',
];
const List<String> ProjectStatusList = [
  'Open',
  'Completed',
  'Cancelled',
];

const List<String> TaskCompletionList = [
  'Manual',
  'Task Completion',
  'Task Progress',
  'Task Wight',
];


const List<String> IssueStatusList = [
  'Open',
  'Replied',
  'On Hold',
  'Resolved',
  'Closed',
];
const List<String> IssuePriorityList = [
  'Low',
  'Medium',
  'High',
];
const List<String> ProjectPriorityList = [
  'Low',
  'Medium',
  'High',
  'Urgent',
];

const List<String> AssignToPriorityList = [
  'Low',
  'Medium',
  'High',
];
const List<String> TimeSheetList = [
  'Draft',
  'Cancelled',
  'Submitted',
];

const List<String> KQuotationToList = ['Lead', 'Customer'];
const List<String> KPaymentPartyList = ['Customer', 'Supplier'];
const List<String> applicantTypeList = ['Employee', 'Customer'];
const List<String> paymentType = ['Receive', 'Pay', 'Internal Transfer'];
const List<String> customerType = ['Company', 'Individual'];
const List<String> supplierType = ['Company', 'Individual'];
const List<String> leaveApplicationStatus = [
  'Approved',
  'Open',
  'Cancelled',
  'Rejected                   '
];
const List<String> attendanceRequestReason = [
  'Work From Home',
  ' On Duty',
];
const List<String> employeeStatus = [
  'Active',
  'Inactive',
  'Suspended',
  'Left',
];
const List<String> loanApplicationStatus = ['Open', 'Approved', 'Rejected'];

const List<String> journalEntryTypeStatus = [
  'Journal Entry',
  'Inter Company Journal Entry',
  'Bank Entry',
  'Cash Entry',
  'Credit Card Entry',
  'Debit Note',
  'Credit Note',
  'Contra Entry',
  'Excise Entry',
  'Write Off Entry',
  'Opening Entry',
  'Depreciation Entry',
  'Exchange Rate Revaluation',
  'Deferred Revenue',
  'Deferred Expense',
];

const List<String> journalEntryTypePartyType1 = ['Customer'];
const List<String> journalEntryTypePartyType2 = ['Supplier', 'Employee'];

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(p);
  return regExp.hasMatch(em);
}

String? mailValidation(String? value) {
  if (value == null || value.trim().length < 3) {
    return 'please enter your email';
  } else if (!isEmail(value)) {
    return "please enter valid email";
  }
  return null;
}

String? numberValidation(value, {bool isInt = false, bool allowNull = false}) {
  if (allowNull) return null;
  if (value == null || value.isEmpty) return 'This field is required';
  var num;

  if (isInt)
    num = int.tryParse(value);
  else
    num = double.tryParse(value);

  if (num == null || num < 0) return 'Invalid value';

  return null;
}

String? validateMobile(String? value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{11,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value?.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value!)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

String? numberValidationToast(String? value, String field,
    {bool isInt = false}) {
  print(value);
  if (value == null || value.isEmpty) {
    Fluttertoast.showToast(
        msg: '$field is required',
        backgroundColor: Colors.grey.shade700.withOpacity(0.8));
    return '';
  }
  var num;

  if (isInt)
    num = int.tryParse(value);
  else
    num = double.tryParse(value);

  if (num == null || num < 0) {
    Fluttertoast.showToast(
        msg: '$value is not a valid $field',
        backgroundColor: Colors.grey.shade700.withOpacity(0.8));
    return '';
  }
  return null;
}

class CheckBoxWidget extends StatefulWidget {
  final String id, title;
  final bool initialValue;
  final bool clear;
  final bool enable;
  final double fontSize;
  final void Function(String id, bool value)? onChanged;
  final VoidCallback? onClear;

  const CheckBoxWidget._(this.id, this.title,
      {required this.initialValue,
      this.clear = false,
      this.enable = true,
      this.onClear,
      this.fontSize = 14,
      this.onChanged,
      Key? key})
      : super(key: key);

  factory CheckBoxWidget(
    String id,
    title, {
    bool? initialValue,
    bool? clear,
    bool? enable,
    double? fontSize,
    VoidCallback? onClear,
    void Function(String id, bool value)? onChanged,
  }) =>
      CheckBoxWidget._(id, title,
          initialValue: initialValue = initialValue ?? false,
          onChanged: onChanged,
          clear: clear ?? false,
          enable: enable ?? true,
          fontSize: fontSize ?? 14,
          onClear: onClear,
          key: Key(id));

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool _value = false;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    if (oldWidget.initialValue != widget.initialValue)
      _value = widget.initialValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            child: Text(
          widget.title,
          style: TextStyle(fontSize: widget.fontSize),
        )),
        Checkbox(
            value: _value,
            onChanged: widget.enable
                ? (value) {
                    if (value != null) {
                      setState(() => _value = value);
                      if (widget.onChanged != null)
                        widget.onChanged!(widget.id, value);
                    }
                  }
                : null),
        if (widget.clear)
          Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                splashRadius: 20,
                onPressed: () {
                  setState(() => _value = false);
                  if (widget.onClear != null) widget.onClear!();
                }),
          )
      ]),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String id, title;
  final bool disableError;
  final bool? clearValue;
  final bool clearButton;
  final bool removeUnderLine;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final TextInputType? keyboardType;
  final Future<String?> Function()? onPressed;
  final void Function(String id, String value)? onSave;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmit;
  final VoidCallback? onClear;
  final void Function(String value)? onEditingComplete;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool disableValidation;
  final bool enabled;

  const CustomTextField._(this.id, this.title,
      {Key? key,
      this.maxLines = 1,
      this.minLines = 1,
      this.keyboardType,
      this.onPressed,
      this.onSave,
      this.onSubmit,
      required this.clearButton,
      required this.removeUnderLine,
      required this.enabled,
      this.hintText,
      this.validator,
      this.initialValue,
      this.onEditingComplete,
      required this.disableValidation,
      required this.disableError,
      this.clearValue,
      this.onClear,
      this.onChanged})
      : super(key: key);

  factory CustomTextField(String id, String title,
          {Key? key,
          bool? disableError,
          maxLines = 1,
          minLines = 1,
          bool? disableValidation,
          String? initialValue,
          String? hintText,
          TextInputType? keyboardType,
          bool? liestenToInitialValue,
          bool? clearButton,
          bool? removeUnderLine,
          bool? enabled,
          Future<String?> Function()? onPressed,
          void Function(String id, String value)? onSave,
          void Function(String value)? onChanged,
          void Function(String value)? onSubmit,
          void Function(String value)? onEditingComplete,
          VoidCallback? onClear,
          String? Function(String?)? validator}) =>
      CustomTextField._(
        id,
        title,
        clearValue: liestenToInitialValue,
        key: key ?? Key(id),
        maxLines: maxLines,
        minLines: minLines,
        onChanged: onChanged,
        keyboardType: keyboardType,
        onPressed: onPressed,
        onSave: onSave,
        onSubmit: onSubmit,
        enabled: enabled ?? true,
        onEditingComplete: onEditingComplete,
        validator: validator,
        clearButton: clearButton ?? false,
        removeUnderLine: removeUnderLine ?? false,
        hintText: hintText,
        initialValue: initialValue,
        onClear: onClear,
        disableValidation: disableValidation ?? false,
        disableError: disableError ?? false,
      );

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) controller.text = widget.initialValue!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.initialValue != widget.initialValue ||
            widget.clearValue == true) &&
        widget.initialValue != controller.value.text)
      Future.delayed(Duration(seconds: 0))
          .then((value) => controller.text = widget.initialValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        onTap: widget.onPressed == null
            ? null
            : () async {
                final res = await widget.onPressed!();
                if (res != null) setState(() => controller.text = res);
              },
        controller: controller,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onEditingComplete: widget.onEditingComplete == null
            ? null
            : () => widget.onEditingComplete!(controller.text),
        keyboardType: widget.keyboardType,
        readOnly: widget.onPressed != null,
        onChanged: widget.onChanged,
        onSaved: (_) => widget.onSave == null
            ? null
            : widget.onSave!(widget.id, controller.text),
        onFieldSubmitted: widget.onSubmit,
        decoration: InputDecoration(
            labelText: tr(widget.title),
            labelStyle: TextStyle(color: Colors.grey),
            isDense: true,
            isCollapsed: false,
            hintText: widget.hintText,
            enabled: widget.enabled,
            border: widget.removeUnderLine ? InputBorder.none : null,
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: widget.removeUnderLine
                ? null
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusColor: widget.onPressed != null ? Colors.grey : null,
            contentPadding: const EdgeInsets.all(2),
            errorStyle: widget.disableError ? TextStyle(height: 0) : null,
            suffix: !widget.clearButton
                ? null
                : SizedBox(
                    height: 24,
                    child: Material(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.clear, color: Colors.grey),
                          splashRadius: 20,
                          onPressed: () {
                            controller.text = '';
                            if (widget.onClear != null) widget.onClear!();
                            FocusScope.of(context).unfocus();
                          }),
                    ),
                  )),
        validator: widget.disableValidation
            ? null
            : widget.validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return widget.disableError ? '' : 'This field is required';
                  }
                  return null;
                },
      ),
    );
  }
}

class CustomExpandableTile extends StatefulWidget {
  CustomExpandableTile({
    Key? key,
    required this.title,
    required this.children,
    required this.hideArrow,
  }) : super(key: key);
  final bool hideArrow;
  final Widget title;
  final List<Widget>? children;
  bool isOpened = false;

  @override
  State<CustomExpandableTile> createState() => _CustomExpandableTileState();
}

class _CustomExpandableTileState extends State<CustomExpandableTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        trailing: !widget.hideArrow
            ? AnimatedRotation(
                turns: widget.isOpened ? .5 : 0,
                duration: Duration(milliseconds: 400),
                child: Icon(Icons.expand_more),
              )
            : null,
        onExpansionChanged: (v) {
          setState(() {
            widget.isOpened = !widget.isOpened;
          });
        },
        childrenPadding: EdgeInsets.zero,
        tilePadding: EdgeInsets.zero,
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: widget.title,
        children: widget.children ?? []);
  }
}

class NumberTextField extends StatefulWidget {
  final String id, title;
  final bool disableError;
  final bool removeUnderLine;
  final bool? clearValue;
  final int? maxLines;
  final String? hintText;
  final TextInputType? keyboardType;
  final Future<String?> Function()? onPressed;
  final void Function(String id, String value)? onSave;
  final void Function(String value)? onChanged;
  final void Function(String value)? onEditingComplete;
  final String? Function(String?)? validator;
  final num? initialValue;

  const NumberTextField._(this.id, this.title,
      {Key? key,
      this.maxLines = 1,
      this.keyboardType,
      this.onPressed,
      this.onSave,
      this.hintText,
      this.validator,
      this.initialValue,
      this.onEditingComplete,
      required this.disableError,
      this.removeUnderLine = false,
      this.clearValue,
      this.onChanged})
      : super(key: key);

  factory NumberTextField(String id, String title,
          {Key? key,
          bool? disableError,
          bool? removeUnderLine,
          maxLines = 1,
          num? initialValue,
          String? hintText,
          TextInputType? keyboardType,
          bool? clearValue,
          Future<String?> Function()? onPressed,
          void Function(String id, String value)? onSave,
          void Function(String value)? onChanged,
          void Function(String value)? onEditingComplete,
          String? Function(String?)? validator}) =>
      NumberTextField._(
        id,
        title,
        clearValue: clearValue,
        key: key ?? Key(id),
        maxLines: maxLines,
        onChanged: onChanged,
        keyboardType: keyboardType,
        onPressed: onPressed,
        onSave: onSave,
        onEditingComplete: onEditingComplete,
        validator: validator,
        hintText: hintText,
        initialValue: initialValue,
        disableError: disableError ?? false,
        removeUnderLine: removeUnderLine ?? false,
      );

  @override
  _NumberTextFieldState createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null)
      controller.text = widget.initialValue!.toStringAsFixed(2);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NumberTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.initialValue != widget.initialValue ||
            widget.clearValue == true) &&
        widget.initialValue != num.tryParse(controller.value.text))
      Future.delayed(Duration(seconds: 0)).then((value) => controller.text =
          widget.initialValue == null ? '' : widget.initialValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        onTap: widget.onPressed == null
            ? null
            : () async {
                final res = await widget.onPressed!();
                if (res != null) setState(() => controller.text = res);
              },
        controller: controller,
        maxLines: widget.maxLines,
        onEditingComplete: widget.onEditingComplete == null
            ? null
            : () => widget.onEditingComplete!(controller.text),
        keyboardType: widget.keyboardType,
        readOnly: widget.onPressed != null,
        onChanged: widget.onChanged,
        onSaved: (_) => widget.onSave == null
            ? null
            : widget.onSave!(widget.id, controller.text),
        decoration: InputDecoration(
          labelText: tr(widget.title),
          labelStyle: TextStyle(color: Colors.grey),
          isDense: true,
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.all(2),
          border: widget.removeUnderLine ? InputBorder.none : null,
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: widget.removeUnderLine
              ? null
              : UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300)),
          focusColor: widget.onPressed != null ? Colors.grey : null,
          focusedBorder: widget.onPressed != null
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300))
              : null,
          errorStyle: widget.disableError ? TextStyle(height: 0) : null,
        ),
        validator: widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return widget.disableError ? '' : 'This field is required';
              }
              return null;
            },
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  final String id, title;
  final void Function(String value)? onChanged;
  final String? initialValue;
  final DateTime? firstDate, lastDate;
  final bool clear;
  final bool enable;
  final VoidCallback? onClear;
  final bool disableValidation;
  final bool removeUnderLine;

  const DatePicker._(this.id, this.title,
      {Key? key,
      this.onChanged,
      this.initialValue,
      this.lastDate,
      this.firstDate,
      this.clear = false,
      this.enable = true,
      required this.disableValidation,
      this.removeUnderLine = false,
      this.onClear})
      : super(key: key);

  factory DatePicker(
    id,
    title, {
    Key? key,
    void Function(String value)? onChanged,
    String? initialValue,
    DateTime? firstDate,
    lastDate,
    bool clear = false,
    bool enable = true,
    bool disableValidation = false,
    bool removeUnderLine = false,
    VoidCallback? onClear,
  }) =>
      DatePicker._(
        id,
        title,
        key: key ?? Key(id),
        onChanged: onChanged,
        initialValue: initialValue,
        firstDate: firstDate,
        lastDate: lastDate,
        clear: clear,
        enable: enable,
        onClear: onClear,
        disableValidation: disableValidation,
        removeUnderLine: removeUnderLine,
      );

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      if (widget.initialValue.toString().contains("T")) {
        controller.text = formatDate(DateTime.parse(widget.initialValue!));
      } else if (widget.initialValue.toString().contains(" ")) {
        var date = widget.initialValue.toString().split(" ")[0] +
            "T" +
            widget.initialValue.toString().split(" ")[1];
        controller.text = formatDate(DateTime.parse(date));
      } else {
        controller.text = formatDate(DateTime.parse(widget.initialValue!));
      }
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    if (oldWidget.initialValue != widget.initialValue)
      Future.delayed(Duration.zero).then((value) {
        setState(() {
          if (widget.initialValue == null) {
            controller.clear();
          } else if (widget.initialValue != null &&
              widget.initialValue.toString().contains("T")) {
            controller.text = widget.initialValue!.isEmpty
                ? ''
                : formatDate(DateTime.parse(widget.initialValue!));
          } else if (widget.initialValue.toString().contains(" ")) {
            var date = widget.initialValue.toString().split(" ")[0] +
                "T" +
                widget.initialValue.toString().split(" ")[1];
            controller.text = formatDate(DateTime.parse(date));
          } else {
            controller.text = formatDate(DateTime.parse(widget.initialValue!));
          }
        });
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(2),
            border: widget.removeUnderLine ? InputBorder.none : null,
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            suffixIcon: widget.clear && controller.text.isNotEmpty
                ? Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                        icon: Icon(Icons.clear),
                        splashRadius: 20,
                        onPressed: () {
                          setState(() => controller.text = '');
                          if (widget.onClear != null) widget.onClear!();
                        }),
                  )
                : Icon(Icons.date_range),
            labelText: widget.title),
        onTap: !widget.enable
            ? null
            : () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.text.isNotEmpty
                      ? DateTime(
                          int.parse(controller.text.split('/')[2]),
                          int.parse(controller.text.split('/')[1]),
                          int.parse(controller.text.split('/')[0]))
                      : widget.firstDate ?? DateTime.now(),
                  firstDate:
                      widget.firstDate ?? DateTime(DateTime.now().year - 1),
                  lastDate:
                      widget.lastDate ?? DateTime(DateTime.now().year + 5),
                );

                if (selectedDate != null) {
                  setState(() => controller.text = formatDate(selectedDate));
                  if (widget.onChanged != null)
                    widget.onChanged!(selectedDate.toIso8601String());
                }
              },
        validator: widget.disableValidation
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  showSnackBar('Please enter Required By Date', context);

                  return 'Please enter date.';
                }
                return null;
              },
      ),
    );
  }
}

class TimePicker extends StatefulWidget {
  final String id, title;
  final void Function(String value)? onChanged;
  final String? initialValue;
  final bool clear;
  final bool enable;
  final bool removeUnderLine;
  final VoidCallback? onClear;
  final bool disableValidation;

  const TimePicker._(this.id, this.title,
      {Key? key,
      this.onChanged,
      this.initialValue,
      this.clear = false,
      this.enable = true,
      this.removeUnderLine = false,
      required this.disableValidation,
      this.onClear})
      : super(key: key);

  factory TimePicker(
    id,
    title, {
    Key? key,
    void Function(String value)? onChanged,
    String? initialValue,
    bool clear = false,
    bool enable = true,
    bool removeUnderLine = false,
    bool disableValidation = false,
    VoidCallback? onClear,
  }) =>
      TimePicker._(
        id,
        title,
        key: key ?? Key(id),
        onChanged: onChanged,
        initialValue: initialValue,
        clear: clear,
        enable: enable,
        removeUnderLine: removeUnderLine,
        onClear: onClear,
        disableValidation: disableValidation,
      );

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      if (widget.initialValue.toString().contains("T")) {
        controller.text = widget.initialValue!.split("T")[1].split(":")[0] +
            ":" +
            widget.initialValue!.split("T")[1].split(":")[1] +
            ":" +
            "00";
      } else {
        controller.text = widget.initialValue!.split(" ")[1].split(":")[0] +
            ":" +
            widget.initialValue!.split(" ")[1].split(":")[1] +
            ":" +
            "00";
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimePicker oldWidget) {
    if (oldWidget.initialValue != widget.initialValue)
      Future.delayed(Duration.zero).then((value) {
        setState(() {
          if (widget.initialValue == null) {
            controller.clear();
          } else if (widget.initialValue != null &&
              widget.initialValue.toString().contains("T")) {
            controller.text = widget.initialValue!.isEmpty
                ? ''
                : widget.initialValue!.split("T")[1].split(":")[0] +
                    ":" +
                    widget.initialValue!.split("T")[1].split(":")[1] +
                    ":" +
                    "00";
          } else {
            controller.text = widget.initialValue!.isEmpty
                ? ''
                : widget.initialValue!.split(" ")[1].split(":")[0] +
                    ":" +
                    widget.initialValue!.split(" ")[1].split(":")[1] +
                    ":" +
                    "00";
          }
        });
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(2),
            border: widget.removeUnderLine ? InputBorder.none : null,
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300)),
            suffixIcon: widget.clear && controller.text.isNotEmpty
                ? Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                        icon: Icon(Icons.clear),
                        splashRadius: 20,
                        onPressed: () {
                          setState(() => controller.text = '');
                          if (widget.onClear != null) widget.onClear!();
                        }),
                  )
                : Icon(Icons.schedule),
            labelText: widget.title),
        onTap: !widget.enable
            ? null
            : () async {
                FocusScope.of(context).requestFocus(FocusNode());

                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: controller.text.isNotEmpty
                      ? TimeOfDay(
                          hour: int.parse(controller.text.split(':')[0]),
                          minute: int.parse(controller.text.split(':')[1]))
                      : TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() => controller.text = formatTime(selectedTime));
                  if (widget.onChanged != null)
                    widget.onChanged!(formatTime(selectedTime));
                }
              },
        validator: widget.disableValidation
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  showSnackBar('Please enter Required By Date', context);

                  return 'Please enter date.';
                }
                return null;
              },
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final String id, title;
  final List<String> items;
  final String? defaultValue;
  final bool clear;
  final bool enable;
  final double fontSize;
  final VoidCallback? onClear;
  final DropdownMenuItem<String> Function(String)? itemBuilder;
  final void Function(String value)? onChanged;
  final void Function()? onTap;

  const CustomDropDown(this.id, this.title,
      {required this.items,
      this.defaultValue,
      this.itemBuilder,
      this.onChanged,
      this.onTap,
      this.clear = false,
      this.enable = true,
      this.fontSize = 14.0,
      this.onClear,
      Key? key})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  void didUpdateWidget(covariant CustomDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(children: [
        Text(
          tr(widget.title),
          style: TextStyle(
            fontSize: widget.fontSize,
          ),
        ),
        Spacer(),
        DropdownButton<String>(
            value: _value,
            borderRadius: BorderRadius.circular(5),
            isExpanded: false,
            onTap: widget.onTap,
            underline: null,
            menuMaxHeight: 300,
            hint: Text('none'.tr()),
            onChanged: (widget.enable)
                ? (value) {
                    if (value == null) return;
                    setState(() => _value = value);
                    if (widget.onChanged != null) widget.onChanged!(value);
                  }
                : null,
            items: widget.items
                .map((e) => widget.itemBuilder != null
                    ? widget.itemBuilder!(e)
                    : DropdownMenuItem(
                        value: e,
                        child: FittedBox(
                            child: Text(e, overflow: TextOverflow.ellipsis))))
                .toList()),
        if (widget.clear && _value != null)
          Material(
            color: Colors.transparent,
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                splashRadius: 20,
                onPressed: () {
                  setState(() => _value = null);
                  if (widget.onClear != null) widget.onClear!();
                  FocusScope.of(context).unfocus();
                }),
          )
      ]),
    );
  }
}

class SelectImage extends StatefulWidget {
  final String id, title;
  final void Function(String value)? onChanged;

  const SelectImage(this.id, this.title, {this.onChanged, Key? key})
      : super(key: key);

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          height: 100,
          width: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _image == null
              ? Icon(Icons.image, color: Colors.grey.shade700, size: 35)
              : Image.file(
                  File(_image!.path),
                  fit: BoxFit.fill,
                ),
        ),
        Expanded(
          child: SizedBox(
            height: 100,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(child: Text('Add Image')),
                if (_image != null)
                  TextButton(
                    onPressed: () {
                      setState(() => _image = null);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 25),
                        Text(
                          'Remove Image',
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: IconButton(
            onPressed: () async {
              final _picker = ImagePicker();
              final image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) setState(() => _image = image);
            },
            icon: Icon(Icons.add, color: Colors.blueAccent, size: 30),
          ),
        )
      ],
    );
  }
}

class Group extends StatelessWidget {
  final Widget child;
  final Color? color;

  const Group({required this.child, Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color ?? Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
