import '../../../../../../core/extensions/date_tine_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../../../widgets/list_card.dart';
import '../../../../../../core/resources/strings_manager.dart';
import '../../domain/entities/task_entity.dart';

class TasksListWidget extends StatelessWidget {
  final List<TaskEntity> tasksList;

  const TasksListWidget({
    super.key,
    required this.tasksList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = tasksList[index];
        return ListCard(
          id: item.name,
          title: item.subject,
          status: item.status,
          names: [
            AppStrings.department,
            AppStrings.priority,
            AppStrings.expectedStartTime,
            AppStrings.expectedEndTime,
          ],
          values: [
            item.department,
            item.priority,
            item.expectedStartDate.formatDate(),
            item.expectedEndDate.formatDate(),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: tasksList.length,
    );
  }
}
