import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../../widgets/pagination.dart';
import '../../../../../../core/utils/error_dialog.dart';
import '../../../../../../core/utils/request_state.dart';
import '../widgets/tasks_item_widget.dart';
import '../bloc/task_bloc.dart';

class TaskMainPage extends StatelessWidget {
  const TaskMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TaskBloc>(context).add(GetTaskEvent(startKey: 0));
    return Scaffold(
      body: BlocConsumer<TaskBloc, TaskState>(
        listenWhen: (previous, current) =>
            previous.getTaskState != current.getTaskState,
        listener: (context, state) {
          if (state.getTaskState == RequestState.error) {
            showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(errorMessage: state.getTaskMessage));
          }
        },
        buildWhen: (previous, current) =>
            previous.getTaskState != current.getTaskState,
        builder: (context, state) {
          if (state.getTaskState == RequestState.loading) {
            return CircularProgressIndicator();
          }
          return TasksListWidget(tasksList: state.getTaskData);
        },
      ),
    );
  }
}
