import '../../core/constants.dart';
import '../list/otherLists.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: getNotificationListScreen(),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String id;
  final String for_user;
  final String from_user;
  final String document_name;
  final String document_type;
  final int read;
  final String subject;
  final String email_content;
  final String type;
  final void Function(BuildContext context)? onPressed;

  const NotificationCard({
    Key? key,
    required this.id,
    required this.for_user,
    required this.from_user,
    required this.document_name,
    required this.document_type,
    required this.read,
    required this.subject,
    required this.email_content,
    required this.type,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          child: InkWell(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            onTap: () => onPressed != null ? onPressed!(context) : null,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircleAvatar(
                              radius: 24,
                              child: Text(
                                for_user.toString()[0],
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(subject, maxLines: 3),
                            ),
                          ),
                          const SizedBox(width: 6)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
