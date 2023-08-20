import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../new_version/core/resources/app_values.dart';
import '../provider/module/module_provider.dart';
import '../models/page_models/model_functions.dart';

import '../core/constants.dart';
import '../provider/user/user_provider.dart';
import '../screen/page/common_page_widgets/common_utils.dart';

showCommentsSheet(BuildContext context) {
  return CommonPageUtils.commonBottomSheet(
      context: context, builderWidget: CommentsSheet(scaffoldContext: context));
}

class CommentsSheet extends StatefulWidget {
  final BuildContext scaffoldContext;

  const CommentsSheet({Key? key, required this.scaffoldContext})
      : super(key: key);

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(widget.scaffoldContext).padding.top +
              DoublesManager.d_100,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(CommonPageUtils.bottomSheetBorderRadius)),
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: DoublesManager.d_50,
                color: Colors.grey.shade200, //APPBAR_COLOR,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black87,
                                size: 25,
                              ))),
                    ),
                    Text(
                        "${(context.read<ModuleProvider>().pageData['comments'] as List?)?.length} comments",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 15))
                  ],
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: Colors.transparent, //APPBAR_COLOR,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          CommonPageUtils.bottomSheetBorderRadius),
                      child: ((context
                                      .read<ModuleProvider>()
                                      .pageData['comments'] as List?) ??
                                  [])
                              .isEmpty
                          ? const Center(
                              child: Text('No comments',
                                  style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0),
                              itemCount: (context
                                          .read<ModuleProvider>()
                                          .pageData['comments'] as List?)
                                      ?.length ??
                                  0,
                              itemBuilder: (_, index) => MessageBubble(
                                context
                                    .read<ModuleProvider>()
                                    .pageData['comments'][index],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              MessageField(onSend: (comment) async {
                final success = await context
                    .read<ModuleProvider>()
                    .addComment(context, comment);
                setState(() {});
                return success;
              })
            ],
          ),
        ),
      ),
    );
  }
}

class MessageField extends StatefulWidget {
  final Future<bool> Function(String message) onSend;

  const MessageField({Key? key, required this.onSend}) : super(key: key);

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final controller = TextEditingController();
  String lastValue = '';

  void update() {
    if ((controller.text.trim().isEmpty && lastValue.isNotEmpty) ||
        (controller.text.trim().isNotEmpty && lastValue.isEmpty)) {
      setState(() {});
    }
    lastValue = controller.text.trim();
  }

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  void send() async {
    final message = controller.text.trim();
    controller.clear();
    await widget.onSend(message).then((success) {
      if (!success) {
        setState(() => controller.text = message);
      } else {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 125,
      child: ColoredBox(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 20,
                child: Text(
                  context.read<UserProvider>().username.toString()[0],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.newline,
                  autofocus: false,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Add Comment...",
                    contentPadding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 3, top: 3),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    labelStyle: const TextStyle(height: 0.5),
                    hintStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.text.trim().isEmpty ? null : send,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: controller.text.trim().isEmpty
                      ? Colors.black45
                      : APPBAR_COLOR,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> comment;

  const MessageBubble(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            child: Text(
              comment['owner']!.toString()[0],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comment['owner']!.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                      ),
                      Text(
                          DateFormat("d/M/y  h:mm a").format(
                              DateTime.parse(comment['creation']!.toString())),
                          style: const TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: Colors.black54)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    formatDescription(comment['content'].toString()),
                    style: const TextStyle(
                        height: 1.5, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
