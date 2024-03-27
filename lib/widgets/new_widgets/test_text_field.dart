import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../list_card.dart';
import '../snack_bar.dart';

class CustomTextFieldTest extends StatefulWidget {
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

  const CustomTextFieldTest._(this.id, this.title,
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

  factory CustomTextFieldTest(String id, String title,
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
      CustomTextFieldTest._(
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
  _CustomTextFieldTestState createState() => _CustomTextFieldTestState();
}

class _CustomTextFieldTestState extends State<CustomTextFieldTest> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) controller.text = widget.initialValue!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTextFieldTest oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.initialValue != widget.initialValue ||
            widget.clearValue == true) &&
        widget.initialValue != controller.value.text) {
      Future.delayed(const Duration(seconds: 0))
          .then((value) => controller.text = widget.initialValue ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          TextFormField(
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
                filled: true,
                //<-- SEE HERE
                fillColor: Colors.grey.shade200,
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                isDense: true,
                isCollapsed: false,
                enabled: widget.enabled,
                border: widget.removeUnderLine ? InputBorder.none : null,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.transparent,
                  ),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.transparent,
                  ),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.transparent,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                focusColor: widget.onPressed != null ? Colors.grey : null,
                contentPadding: const EdgeInsets.all(5),
                errorStyle:
                    widget.disableError ? const TextStyle(height: 0) : null,
                suffix: !widget.clearButton
                    ? null
                    : SizedBox(
                        height: 24,
                        child: Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                              padding: const EdgeInsets.only(top: 3),
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
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
                        return widget.disableError
                            ? ''
                            : 'This field is required';
                      }
                      return null;
                    },
          ),
        ],
      ),
    );
  }
}

class CustomDropDownTest extends StatefulWidget {
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

  const CustomDropDownTest(this.id, this.title,
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
  _CustomDropDownTestState createState() => _CustomDropDownTestState();
}

class _CustomDropDownTestState extends State<CustomDropDownTest> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  void didUpdateWidget(covariant CustomDropDownTest oldWidget) {
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
        const Spacer(),
        DropdownButton<String>(
            value: _value,
            borderRadius: BorderRadius.circular(5),
            isExpanded: false,
            onTap: widget.onTap,
            underline: null,
            menuMaxHeight: 300,
            hint: Text(
              'none'.tr(),
            ),
            onChanged: (widget.enable)
                ? (value) {
                    if (value == null) return;
                    setState(() => _value = value);
                    if (widget.onChanged != null) widget.onChanged!(value);
                  }
                : null,
            items: widget.items
                .map(
                  (e) => widget.itemBuilder != null
                      ? widget.itemBuilder!(e)
                      : DropdownMenuItem(
                          value: e,
                          child: FittedBox(
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                )
                .toList()),
        if (widget.clear && _value != null)
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
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

class DatePickerTest extends StatefulWidget {
  final String id, title;
  final void Function(String value)? onChanged;
  final String? initialValue;
  final DateTime? firstDate, lastDate;
  final bool clear;
  final bool enable;
  final VoidCallback? onClear;
  final bool disableValidation;
  final bool removeUnderLine;

  const DatePickerTest._(this.id, this.title,
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

  factory DatePickerTest(
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
      DatePickerTest._(
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
  _DatePickerTestState createState() => _DatePickerTestState();
}

class _DatePickerTestState extends State<DatePickerTest> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      if (widget.initialValue.toString().contains("T")) {
        controller.text = formatDate(DateTime.parse(widget.initialValue!));
      } else if (widget.initialValue.toString().contains(" ")) {
        var date =
            "${widget.initialValue.toString().split(" ")[0]}T${widget.initialValue.toString().split(" ")[1]}";
        controller.text = formatDate(DateTime.parse(date));
      } else {
        controller.text = formatDate(DateTime.parse(widget.initialValue!));
      }
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePickerTest oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
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
            var date =
                "${widget.initialValue.toString().split(" ")[0]}T${widget.initialValue.toString().split(" ")[1]}";
            controller.text = formatDate(DateTime.parse(date));
          } else {
            controller.text = formatDate(DateTime.parse(widget.initialValue!));
          }
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              //<-- SEE HERE
              fillColor: Colors.grey.shade300,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              isDense: true,
              isCollapsed: false,
              contentPadding: const EdgeInsets.all(2),
              border: widget.removeUnderLine ? InputBorder.none : null,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.transparent,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.transparent,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              suffixIcon: widget.clear && controller.text.isNotEmpty
                  ? Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          splashRadius: 20,
                          onPressed: () {
                            setState(() => controller.text = '');
                            if (widget.onClear != null) widget.onClear!();
                          }),
                    )
                  : const Icon(
                      Icons.date_range,
                      color: APPBAR_COLOR,
                    ),
            ),
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
                      setState(
                          () => controller.text = formatDate(selectedDate));
                      if (widget.onChanged != null) {
                        widget.onChanged!(selectedDate.toIso8601String());
                      }
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
        ],
      ),
    );
  }
}

class TimePickerTest extends StatefulWidget {
  final String id, title;
  final void Function(String value)? onChanged;
  final String? initialValue;
  final bool clear;
  final bool enable;
  final bool removeUnderLine;
  final VoidCallback? onClear;
  final bool disableValidation;

  const TimePickerTest._(this.id, this.title,
      {Key? key,
      this.onChanged,
      this.initialValue,
      this.clear = false,
      this.enable = true,
      this.removeUnderLine = false,
      required this.disableValidation,
      this.onClear})
      : super(key: key);

  factory TimePickerTest(
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
      TimePickerTest._(
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
  _TimePickerTestState createState() => _TimePickerTestState();
}

class _TimePickerTestState extends State<TimePickerTest> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      if (widget.initialValue.toString().contains("T")) {
        controller.text =
            "${widget.initialValue!.split("T")[1].split(":")[0]}:${widget.initialValue!.split("T")[1].split(":")[1]}:00";
      } else if (widget.initialValue.toString().contains(" ")) {
        controller.text =
            "${widget.initialValue!.split(" ")[1].split(":")[0]}:${widget.initialValue!.split(" ")[1].split(":")[1]}:00";
      } else {
        controller.text = widget.initialValue.toString();
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TimePickerTest oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      Future.delayed(Duration.zero).then((value) {
        setState(() {
          if (widget.initialValue == null) {
            controller.clear();
          } else if (widget.initialValue != null &&
              widget.initialValue.toString().contains("T")) {
            controller.text = widget.initialValue!.isEmpty
                ? ''
                : "${widget.initialValue!.split("T")[1].split(":")[0]}:${widget.initialValue!.split("T")[1].split(":")[1]}:00";
          } else {
            controller.text = widget.initialValue!.isEmpty
                ? ''
                : "${widget.initialValue!.split(" ")[1].split(":")[0]}:${widget.initialValue!.split(" ")[1].split(":")[1]}:00";
          }
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          TextFormField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              isDense: false,
              filled: true,
              //<-- SEE HERE
              fillColor: Colors.grey.shade300,
              contentPadding: const EdgeInsets.all(2),
              border: widget.removeUnderLine ? InputBorder.none : null,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.transparent,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.transparent,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.red,
                ),
              ),
              suffixIcon: widget.clear && controller.text.isNotEmpty
                  ? Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                          icon: const Icon(Icons.clear),
                          splashRadius: 20,
                          onPressed: () {
                            setState(() => controller.text = '');
                            if (widget.onClear != null) widget.onClear!();
                          }),
                    )
                  : const Icon(Icons.schedule),
            ),
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
                      setState(
                          () => controller.text = formatTime(selectedTime));
                      if (widget.onChanged != null) {
                        widget.onChanged!(formatTime(selectedTime));
                      }
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
        ],
      ),
    );
  }
}
